import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Engine for personalizing settings based on user behavior and preferences.
class PersonalizationEngine {
  static const String _userProfileKey = 'personalization_user_profile';

  final SharedPreferences _prefs;

  /// Creates a new PersonalizationEngine.
  PersonalizationEngine(this._prefs);

  /// Updates user profile with new interaction data.
  Future<void> updateUserProfile(
      String settingId, dynamic value, DateTime timestamp) async {
    final profile = await _loadUserProfile();
    final interaction = UserInteraction(
      settingId: settingId,
      value: value,
      timestamp: timestamp,
      context: await _getInteractionContext(),
    );

    profile.interactions.add(interaction);

    // Keep only last 1000 interactions
    if (profile.interactions.length > 1000) {
      profile.interactions.removeRange(0, profile.interactions.length - 1000);
    }

    await _saveUserProfile(profile);
    await _updateRecommendations(profile);
  }

  /// Gets personalized recommendations for settings.
  Future<List<PersonalizedRecommendation>> getRecommendations() async {
    final profile = await _loadUserProfile();
    return profile.recommendations;
  }

  /// Applies a personalized recommendation.
  Future<void> applyRecommendation(String recommendationId) async {
    final profile = await _loadUserProfile();
    final recommendation =
        profile.recommendations.firstWhere((r) => r.id == recommendationId);

    // Record that recommendation was applied
    recommendation.appliedCount++;
    recommendation.lastApplied = DateTime.now();

    await _saveUserProfile(profile);

    // Update user preferences
    await updateUserProfile(
      recommendation.settingId,
      recommendation.recommendedValue,
      DateTime.now(),
    );
  }

  /// Gets user profile insights.
  Future<UserProfileInsights> getProfileInsights() async {
    final profile = await _loadUserProfile();

    final insights = UserProfileInsights(
      totalInteractions: profile.interactions.length,
      favoriteSettings: _calculateFavoriteSettings(profile),
      usagePatterns: _calculateUsagePatterns(profile),
      preferences: _extractPreferences(profile),
    );

    return insights;
  }

  Future<InteractionContext> _getInteractionContext() async {
    final now = DateTime.now();
    final hour = now.hour;

    // Determine time context
    TimeContext timeContext;
    if (hour >= 6 && hour < 12) {
      timeContext = TimeContext.morning;
    } else if (hour >= 12 && hour < 18) {
      timeContext = TimeContext.afternoon;
    } else if (hour >= 18 && hour < 22) {
      timeContext = TimeContext.evening;
    } else {
      timeContext = TimeContext.night;
    }

    return InteractionContext(
      timeContext: timeContext,
      dayOfWeek: now.weekday,
      isWeekend: now.weekday >= 6,
      timestamp: now,
    );
  }

  Future<void> _updateRecommendations(UserProfile profile) async {
    final recommendations = <PersonalizedRecommendation>[];

    // Analyze interaction patterns
    final settingFrequency = <String, int>{};
    final settingValues = <String, Map<dynamic, int>>{};

    for (final interaction in profile.interactions) {
      settingFrequency[interaction.settingId] =
          (settingFrequency[interaction.settingId] ?? 0) + 1;

      settingValues.putIfAbsent(interaction.settingId, () => {});
      settingValues[interaction.settingId]![interaction.value] =
          (settingValues[interaction.settingId]![interaction.value] ?? 0) + 1;
    }

    // Generate recommendations based on patterns
    for (final entry in settingValues.entries) {
      final settingId = entry.key;
      final values = entry.value;

      if (values.length > 1) {
        // Find most common value
        final mostCommon =
            values.entries.reduce((a, b) => a.value > b.value ? a : b);

        if (mostCommon.value > 1) {
          // Used more than once
          final confidence =
              mostCommon.value / values.values.reduce((a, b) => a + b);

          recommendations.add(
            PersonalizedRecommendation(
              id: '${settingId}_preferred_${mostCommon.key}',
              settingId: settingId,
              recommendedValue: mostCommon.key,
              reason:
                  'You prefer this value ${((confidence * 100).round())}% of the time',
              confidence: confidence,
              type: RecommendationType.preference,
              appliedCount: 0,
              createdAt: DateTime.now(),
              lastApplied: null,
            ),
          );
        }
      }
    }

    // Time-based recommendations
    final timeBasedRecs = await _generateTimeBasedRecommendations(profile);
    recommendations.addAll(timeBasedRecs);

    // Frequency-based recommendations
    final frequencyRecs =
        _generateFrequencyBasedRecommendations(settingFrequency);
    recommendations.addAll(frequencyRecs);

    // Update profile with new recommendations
    profile.recommendations = recommendations;
    await _saveUserProfile(profile);
  }

  Future<List<PersonalizedRecommendation>> _generateTimeBasedRecommendations(
      UserProfile profile) async {
    final recommendations = <PersonalizedRecommendation>[];
    final timePatterns = <String, Map<TimeContext, int>>{};

    for (final interaction in profile.interactions) {
      final settingId = interaction.settingId;
      final timeContext = interaction.context.timeContext;

      timePatterns.putIfAbsent(settingId, () => {});
      timePatterns[settingId]![timeContext] =
          (timePatterns[settingId]![timeContext] ?? 0) + 1;
    }

    final currentContext = await _getInteractionContext();

    for (final entry in timePatterns.entries) {
      final settingId = entry.key;
      final patterns = entry.value;

      final currentCount = patterns[currentContext.timeContext] ?? 0;
      final maxCount = patterns.values.reduce((a, b) => a > b ? a : b);

      if (maxCount > currentCount * 1.5) {
        // 50% more usage at different time
        final preferredTime =
            patterns.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        recommendations.add(
          PersonalizedRecommendation(
            id: '${settingId}_time_${preferredTime.name}',
            settingId: settingId,
            recommendedValue: null, // No specific value, just timing
            reason:
                'You often adjust this setting during ${preferredTime.name}',
            confidence: (maxCount - currentCount) / maxCount,
            type: RecommendationType.timing,
            appliedCount: 0,
            createdAt: DateTime.now(),
            lastApplied: null,
          ),
        );
      }
    }

    return recommendations;
  }

  List<PersonalizedRecommendation> _generateFrequencyBasedRecommendations(
      Map<String, int> settingFrequency) {
    final recommendations = <PersonalizedRecommendation>[];

    // Sort by frequency
    final sortedSettings = settingFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedSettings.take(5)) {
      // Top 5
      if (entry.value >= 10) {
        // Used at least 10 times
        recommendations.add(
          PersonalizedRecommendation(
            id: '${entry.key}_frequent',
            settingId: entry.key,
            recommendedValue: null,
            reason: 'You frequently adjust this setting (${entry.value} times)',
            confidence:
                entry.value / settingFrequency.values.reduce((a, b) => a + b),
            type: RecommendationType.frequency,
            appliedCount: 0,
            createdAt: DateTime.now(),
            lastApplied: null,
          ),
        );
      }
    }

    return recommendations;
  }

  Map<String, int> _calculateFavoriteSettings(UserProfile profile) {
    final favorites = <String, int>{};

    for (final interaction in profile.interactions) {
      favorites[interaction.settingId] =
          (favorites[interaction.settingId] ?? 0) + 1;
    }

    // Sort by frequency
    final sorted = favorites.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(10)); // Top 10
  }

  Map<String, UsagePattern> _calculateUsagePatterns(UserProfile profile) {
    final patterns = <String, UsagePattern>{};

    for (final interaction in profile.interactions) {
      final settingId = interaction.settingId;
      final hour = interaction.timestamp.hour;

      patterns.putIfAbsent(
          settingId, () => UsagePattern(settingId: settingId, hourlyUsage: {}));
      patterns[settingId]!.hourlyUsage[hour] =
          (patterns[settingId]!.hourlyUsage[hour] ?? 0) + 1;
    }

    return patterns;
  }

  Map<String, dynamic> _extractPreferences(UserProfile profile) {
    final preferences = <String, dynamic>{};

    for (final interaction in profile.interactions) {
      final settingId = interaction.settingId;
      final value = interaction.value;

      if (!preferences.containsKey(settingId)) {
        preferences[settingId] = value;
      } else {
        // If different values, mark as variable
        if (preferences[settingId] != value) {
          preferences[settingId] = 'variable';
        }
      }
    }

    return preferences;
  }

  Future<UserProfile> _loadUserProfile() async {
    final jsonString = _prefs.getString(_userProfileKey);
    if (jsonString == null) {
      return UserProfile(
        interactions: [],
        recommendations: [],
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
    }

    final map = Map<String, dynamic>.from(jsonDecode(jsonString));
    return UserProfile.fromJson(map);
  }

  Future<void> _saveUserProfile(UserProfile profile) async {
    profile.lastUpdated = DateTime.now();
    final jsonString = jsonEncode(profile.toJson());
    await _prefs.setString(_userProfileKey, jsonString);
  }
}

/// User profile containing interaction history and recommendations.
class UserProfile {
  List<UserInteraction> interactions;
  List<PersonalizedRecommendation> recommendations;
  DateTime createdAt;
  DateTime lastUpdated;

  UserProfile({
    required this.interactions,
    required this.recommendations,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'interactions': interactions.map((i) => i.toJson()).toList(),
        'recommendations': recommendations.map((r) => r.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        interactions: (json['interactions'] as List)
            .map((i) => UserInteraction.fromJson(i))
            .toList(),
        recommendations: (json['recommendations'] as List)
            .map((r) => PersonalizedRecommendation.fromJson(r))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );
}

/// Represents a user interaction with a setting.
class UserInteraction {
  final String settingId;
  final dynamic value;
  final DateTime timestamp;
  final InteractionContext context;

  const UserInteraction({
    required this.settingId,
    required this.value,
    required this.timestamp,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
        'settingId': settingId,
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'context': context.toJson(),
      };

  factory UserInteraction.fromJson(Map<String, dynamic> json) =>
      UserInteraction(
        settingId: json['settingId'],
        value: json['value'],
        timestamp: DateTime.parse(json['timestamp']),
        context: InteractionContext.fromJson(json['context']),
      );
}

/// Context of a user interaction.
class InteractionContext {
  final TimeContext timeContext;
  final int dayOfWeek;
  final bool isWeekend;
  final DateTime timestamp;

  const InteractionContext({
    required this.timeContext,
    required this.dayOfWeek,
    required this.isWeekend,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'timeContext': timeContext.name,
        'dayOfWeek': dayOfWeek,
        'isWeekend': isWeekend,
        'timestamp': timestamp.toIso8601String(),
      };

  factory InteractionContext.fromJson(Map<String, dynamic> json) =>
      InteractionContext(
        timeContext: TimeContext.values.firstWhere(
          (e) => e.name == json['timeContext'],
          orElse: () => TimeContext.morning,
        ),
        dayOfWeek: json['dayOfWeek'],
        isWeekend: json['isWeekend'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Time context for interactions.
enum TimeContext { morning, afternoon, evening, night }

/// Extension to get name of TimeContext.
extension TimeContextExtension on TimeContext {
  String get name {
    switch (this) {
      case TimeContext.morning:
        return 'morning';
      case TimeContext.afternoon:
        return 'afternoon';
      case TimeContext.evening:
        return 'evening';
      case TimeContext.night:
        return 'night';
    }
  }
}

/// Type of recommendation.
enum RecommendationType { preference, timing, frequency }

/// A personalized recommendation for a setting.
class PersonalizedRecommendation {
  final String id;
  final String settingId;
  final dynamic recommendedValue;
  final String reason;
  final double confidence;
  final RecommendationType type;
  int appliedCount;
  final DateTime createdAt;
  DateTime? lastApplied;

  PersonalizedRecommendation({
    required this.id,
    required this.settingId,
    required this.recommendedValue,
    required this.reason,
    required this.confidence,
    required this.type,
    required this.appliedCount,
    required this.createdAt,
    this.lastApplied,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'settingId': settingId,
        'recommendedValue': recommendedValue,
        'reason': reason,
        'confidence': confidence,
        'type': type.name,
        'appliedCount': appliedCount,
        'createdAt': createdAt.toIso8601String(),
        'lastApplied': lastApplied?.toIso8601String(),
      };

  factory PersonalizedRecommendation.fromJson(Map<String, dynamic> json) =>
      PersonalizedRecommendation(
        id: json['id'],
        settingId: json['settingId'],
        recommendedValue: json['recommendedValue'],
        reason: json['reason'],
        confidence: json['confidence'],
        type: RecommendationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => RecommendationType.preference,
        ),
        appliedCount: json['appliedCount'],
        createdAt: DateTime.parse(json['createdAt']),
        lastApplied: json['lastApplied'] != null
            ? DateTime.parse(json['lastApplied'])
            : null,
      );
}

/// Insights about user profile.
class UserProfileInsights {
  final int totalInteractions;
  final Map<String, int> favoriteSettings;
  final Map<String, UsagePattern> usagePatterns;
  final Map<String, dynamic> preferences;

  const UserProfileInsights({
    required this.totalInteractions,
    required this.favoriteSettings,
    required this.usagePatterns,
    required this.preferences,
  });
}

/// Usage pattern for a setting.
class UsagePattern {
  final String settingId;
  final Map<int, int> hourlyUsage;

  const UsagePattern({
    required this.settingId,
    required this.hourlyUsage,
  });
}
