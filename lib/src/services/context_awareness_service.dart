import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for providing context-aware settings suggestions and adjustments.
class ContextAwarenessService {
  static const String _usageHistoryKey = 'context_awareness_usage_history';

  final SharedPreferences _prefs;
  final StreamController<ContextSuggestion> _suggestionsController =
      StreamController<ContextSuggestion>.broadcast();

  Timer? _contextCheckTimer;

  /// Stream of context suggestions.
  Stream<ContextSuggestion> get suggestions => _suggestionsController.stream;

  /// Creates a new ContextAwarenessService.
  ContextAwarenessService(this._prefs) {
    _startContextMonitoring();
  }

  /// Records user interaction with a settings item.
  Future<void> recordInteraction(
      String itemId, dynamic value, DateTime timestamp) async {
    final usageData = await _loadUsageHistory();
    final interaction = UsageInteraction(
      itemId: itemId,
      value: value,
      timestamp: timestamp,
      context: await _getCurrentContext(),
    );

    usageData.add(interaction);

    // Keep only last 1000 interactions
    if (usageData.length > 1000) {
      usageData.removeRange(0, usageData.length - 1000);
    }

    await _saveUsageHistory(usageData);
    await _analyzePatternsAndSuggest();
  }

  /// Gets context-aware suggestions for settings.
  Future<List<ContextSuggestion>> getSuggestions() async {
    final usageData = await _loadUsageHistory();
    final suggestions = <ContextSuggestion>[];

    if (usageData.isEmpty) return suggestions;

    // Analyze time-based patterns
    final timeSuggestions = await _analyzeTimePatterns(usageData);
    suggestions.addAll(timeSuggestions);

    // Analyze value patterns
    final valueSuggestions = await _analyzeValuePatterns(usageData);
    suggestions.addAll(valueSuggestions);

    // Analyze frequency patterns
    final frequencySuggestions = await _analyzeFrequencyPatterns(usageData);
    suggestions.addAll(frequencySuggestions);

    return suggestions;
  }

  /// Gets the current context information.
  Future<ContextInfo> _getCurrentContext() async {
    final now = DateTime.now();
    final hour = now.hour;

    // Determine time of day
    TimeOfDay timeOfDay;
    if (hour >= 6 && hour < 12) {
      timeOfDay = TimeOfDay.morning;
    } else if (hour >= 12 && hour < 18) {
      timeOfDay = TimeOfDay.afternoon;
    } else if (hour >= 18 && hour < 22) {
      timeOfDay = TimeOfDay.evening;
    } else {
      timeOfDay = TimeOfDay.night;
    }

    return ContextInfo(
      timeOfDay: timeOfDay,
      dayOfWeek: now.weekday,
      isWeekend: now.weekday >= 6,
      timestamp: now,
    );
  }

  Future<List<ContextSuggestion>> _analyzeTimePatterns(
      List<UsageInteraction> usageData) async {
    final suggestions = <ContextSuggestion>[];
    final now = await _getCurrentContext();

    // Group interactions by time of day and item
    final timePatterns = <String, Map<TimeOfDay, int>>{};

    for (final interaction in usageData) {
      final itemId = interaction.itemId;
      final timeOfDay = interaction.context.timeOfDay;

      timePatterns.putIfAbsent(itemId, () => {});
      timePatterns[itemId]![timeOfDay] =
          (timePatterns[itemId]![timeOfDay] ?? 0) + 1;
    }

    // Generate suggestions based on patterns
    for (final entry in timePatterns.entries) {
      final itemId = entry.key;
      final patterns = entry.value;

      final currentTimeCount = patterns[now.timeOfDay] ?? 0;
      final maxTimeCount = patterns.values.reduce((a, b) => a > b ? a : b);

      if (maxTimeCount > currentTimeCount * 2) {
        // User frequently uses this setting at different times
        final preferredTime =
            patterns.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        suggestions.add(
          ContextSuggestion(
            itemId: itemId,
            type: SuggestionType.timeBased,
            title: 'Time-based suggestion',
            description:
                'You often use this setting during ${preferredTime.name}',
            confidence: (maxTimeCount - currentTimeCount) / maxTimeCount,
            suggestedValue: null, // Keep current value
          ),
        );
      }
    }

    return suggestions;
  }

  Future<List<ContextSuggestion>> _analyzeValuePatterns(
      List<UsageInteraction> usageData) async {
    final suggestions = <ContextSuggestion>[];
    final valuePatterns = <String, Map<dynamic, int>>{};

    // Group by item and value
    for (final interaction in usageData) {
      final itemId = interaction.itemId;
      final value = interaction.value;

      valuePatterns.putIfAbsent(itemId, () => {});
      valuePatterns[itemId]![value] = (valuePatterns[itemId]![value] ?? 0) + 1;
    }

    // Find most common values
    for (final entry in valuePatterns.entries) {
      final itemId = entry.key;
      final patterns = entry.value;

      if (patterns.length > 1) {
        final mostCommon =
            patterns.entries.reduce((a, b) => a.value > b.value ? a : b);
        final total = patterns.values.reduce((a, b) => a + b);

        if (mostCommon.value / total > 0.6) {
          // 60% preference
          suggestions.add(
            ContextSuggestion(
              itemId: itemId,
              type: SuggestionType.valueBased,
              title: 'Preferred value',
              description:
                  'You prefer this value ${((mostCommon.value / total) * 100).round()}% of the time',
              confidence: mostCommon.value / total,
              suggestedValue: mostCommon.key,
            ),
          );
        }
      }
    }

    return suggestions;
  }

  Future<List<ContextSuggestion>> _analyzeFrequencyPatterns(
      List<UsageInteraction> usageData) async {
    final suggestions = <ContextSuggestion>[];
    final recentInteractions = usageData.where((interaction) {
      final daysDiff = DateTime.now().difference(interaction.timestamp).inDays;
      return daysDiff <= 7; // Last 7 days
    }).toList();

    final frequencyMap = <String, int>{};
    for (final interaction in recentInteractions) {
      frequencyMap[interaction.itemId] =
          (frequencyMap[interaction.itemId] ?? 0) + 1;
    }

    // Suggest frequently used items
    final sortedItems = frequencyMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedItems.take(3)) {
      // Top 3
      if (entry.value >= 5) {
        // Used at least 5 times in last week
        suggestions.add(
          ContextSuggestion(
            itemId: entry.key,
            type: SuggestionType.frequencyBased,
            title: 'Frequently used',
            description:
                'You\'ve used this setting ${entry.value} times this week',
            confidence: entry.value / recentInteractions.length,
            suggestedValue: null,
          ),
        );
      }
    }

    return suggestions;
  }

  Future<void> _analyzePatternsAndSuggest() async {
    final suggestions = await getSuggestions();

    for (final suggestion in suggestions) {
      _suggestionsController.add(suggestion);
    }
  }

  Future<List<UsageInteraction>> _loadUsageHistory() async {
    final jsonList = _prefs.getStringList(_usageHistoryKey) ?? [];
    return jsonList.map((jsonString) {
      final map = Map<String, dynamic>.from(jsonDecode(jsonString));
      return UsageInteraction.fromJson(map);
    }).toList();
  }

  Future<void> _saveUsageHistory(List<UsageInteraction> history) async {
    final jsonList =
        history.map((interaction) => jsonEncode(interaction.toJson())).toList();
    await _prefs.setStringList(_usageHistoryKey, jsonList);
  }

  void _startContextMonitoring() {
    _contextCheckTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      _analyzePatternsAndSuggest();
    });
  }

  /// Disposes the service.
  void dispose() {
    _contextCheckTimer?.cancel();
    _suggestionsController.close();
  }
}

/// Represents a usage interaction with context.
class UsageInteraction {
  final String itemId;
  final dynamic value;
  final DateTime timestamp;
  final ContextInfo context;

  const UsageInteraction({
    required this.itemId,
    required this.value,
    required this.timestamp,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'context': context.toJson(),
      };

  factory UsageInteraction.fromJson(Map<String, dynamic> json) =>
      UsageInteraction(
        itemId: json['itemId'],
        value: json['value'],
        timestamp: DateTime.parse(json['timestamp']),
        context: ContextInfo.fromJson(json['context']),
      );
}

/// Context information for an interaction.
class ContextInfo {
  final TimeOfDay timeOfDay;
  final int dayOfWeek;
  final bool isWeekend;
  final DateTime timestamp;

  const ContextInfo({
    required this.timeOfDay,
    required this.dayOfWeek,
    required this.isWeekend,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'timeOfDay': timeOfDay.name,
        'dayOfWeek': dayOfWeek,
        'isWeekend': isWeekend,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ContextInfo.fromJson(Map<String, dynamic> json) => ContextInfo(
        timeOfDay: TimeOfDay.values.firstWhere(
          (e) => e.name == json['timeOfDay'],
          orElse: () => TimeOfDay.morning,
        ),
        dayOfWeek: json['dayOfWeek'],
        isWeekend: json['isWeekend'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Time of day enumeration.
enum TimeOfDay { morning, afternoon, evening, night }

/// Extension to get name of TimeOfDay.
extension TimeOfDayExtension on TimeOfDay {
  String get name {
    switch (this) {
      case TimeOfDay.morning:
        return 'morning';
      case TimeOfDay.afternoon:
        return 'afternoon';
      case TimeOfDay.evening:
        return 'evening';
      case TimeOfDay.night:
        return 'night';
    }
  }
}

/// Type of context suggestion.
enum SuggestionType { timeBased, valueBased, frequencyBased }

/// A context-aware suggestion for settings.
class ContextSuggestion {
  final String itemId;
  final SuggestionType type;
  final String title;
  final String description;
  final double confidence;
  final dynamic suggestedValue;

  const ContextSuggestion({
    required this.itemId,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    this.suggestedValue,
  });
}
