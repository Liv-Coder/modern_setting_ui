import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Framework for A/B testing different settings variants.
class ABTestingFramework {
  static const String _experimentsKey = 'ab_testing_experiments';
  static const String _userVariantKey = 'ab_testing_user_variant';

  final SharedPreferences _prefs;
  final Random _random = Random();

  /// Creates a new ABTestingFramework.
  ABTestingFramework(this._prefs);

  /// Registers a new A/B test experiment.
  Future<void> registerExperiment(Experiment experiment) async {
    final experiments = await _loadExperiments();
    experiments[experiment.id] = experiment;
    await _saveExperiments(experiments);
  }

  /// Gets the variant for a user in a specific experiment.
  Future<String?> getUserVariant(String experimentId) async {
    final experiments = await _loadExperiments();
    final experiment = experiments[experimentId];

    if (experiment == null) return null;

    // Check if user is already assigned to a variant
    final userVariants = await _loadUserVariants();
    if (userVariants.containsKey(experimentId)) {
      return userVariants[experimentId];
    }

    // Assign user to a variant
    final variant = _assignVariant(experiment);
    userVariants[experimentId] = variant;
    await _saveUserVariants(userVariants);

    // Record the assignment
    await _recordEvent(experimentId, 'assigned', {'variant': variant});

    return variant;
  }

  /// Records an event for an experiment.
  Future<void> recordEvent(String experimentId, String eventType,
      [Map<String, dynamic>? properties]) async {
    await _recordEvent(experimentId, eventType, properties ?? {});
  }

  /// Gets the results of an experiment.
  Future<ExperimentResults?> getExperimentResults(String experimentId) async {
    final experiments = await _loadExperiments();
    final experiment = experiments[experimentId];

    if (experiment == null) return null;

    final events = await _loadExperimentEvents(experimentId);
    return _calculateResults(experiment, events);
  }

  /// Gets all active experiments.
  Future<List<Experiment>> getActiveExperiments() async {
    final experiments = await _loadExperiments();
    final now = DateTime.now();

    return experiments.values.where((experiment) {
      return experiment.startDate.isBefore(now) &&
          (experiment.endDate == null || experiment.endDate!.isAfter(now));
    }).toList();
  }

  /// Ends an experiment and determines the winner.
  Future<String?> endExperiment(String experimentId) async {
    final experiments = await _loadExperiments();
    final experiment = experiments[experimentId];

    if (experiment == null) return null;

    final results = await getExperimentResults(experimentId);
    if (results == null) return null;

    // Determine winner based on primary metric
    final winner = results.variantResults.entries
        .reduce(
            (a, b) => a.value.conversionRate > b.value.conversionRate ? a : b)
        .key;

    // Record experiment end
    await _recordEvent(experimentId, 'ended', {'winner': winner});

    return winner;
  }

  String _assignVariant(Experiment experiment) {
    final randomValue = _random.nextDouble();
    double cumulativeProbability = 0.0;

    for (final variant in experiment.variants) {
      cumulativeProbability += variant.trafficAllocation;
      if (randomValue <= cumulativeProbability) {
        return variant.id;
      }
    }

    // Fallback to first variant
    return experiment.variants.first.id;
  }

  Future<void> _recordEvent(String experimentId, String eventType,
      Map<String, dynamic> properties) async {
    final events = await _loadExperimentEvents(experimentId);
    final event = ExperimentEvent(
      experimentId: experimentId,
      eventType: eventType,
      timestamp: DateTime.now(),
      properties: properties,
    );

    events.add(event);
    await _saveExperimentEvents(experimentId, events);
  }

  ExperimentResults _calculateResults(
      Experiment experiment, List<ExperimentEvent> events) {
    final variantResults = <String, VariantResult>{};

    // Initialize results for each variant
    for (final variant in experiment.variants) {
      variantResults[variant.id] = VariantResult(
        variantId: variant.id,
        participantCount: 0,
        conversionCount: 0,
        conversionRate: 0.0,
        events: [],
      );
    }

    // Process events
    for (final event in events) {
      if (event.eventType == 'assigned') {
        final variantId = event.properties['variant'] as String?;
        if (variantId != null && variantResults.containsKey(variantId)) {
          variantResults[variantId]!.participantCount++;
          variantResults[variantId]!.events.add(event);
        }
      } else if (experiment.conversionEvents.contains(event.eventType)) {
        // Find which variant this user is in
        final assignmentEvents = events
            .where((e) =>
                e.eventType == 'assigned' &&
                e.timestamp.isBefore(event.timestamp))
            .toList();

        if (assignmentEvents.isNotEmpty) {
          final assignmentEvent = assignmentEvents.last;
          final variantId = assignmentEvent.properties['variant'] as String?;
          if (variantId != null && variantResults.containsKey(variantId)) {
            variantResults[variantId]!.conversionCount++;
            variantResults[variantId]!.events.add(event);
          }
        }
      }
    }

    // Calculate conversion rates
    for (final result in variantResults.values) {
      if (result.participantCount > 0) {
        result.conversionRate =
            result.conversionCount / result.participantCount;
      }
    }

    return ExperimentResults(
      experimentId: experiment.id,
      variantResults: variantResults,
      totalParticipants: variantResults.values
          .fold(0, (sum, result) => sum + result.participantCount),
      totalConversions: variantResults.values
          .fold(0, (sum, result) => sum + result.conversionCount),
    );
  }

  Future<Map<String, Experiment>> _loadExperiments() async {
    final jsonMap = _prefs.getString(_experimentsKey);
    if (jsonMap == null) return {};

    final map = Map<String, dynamic>.from(jsonDecode(jsonMap));
    return map.map((key, value) => MapEntry(key, Experiment.fromJson(value)));
  }

  Future<void> _saveExperiments(Map<String, Experiment> experiments) async {
    final jsonMap =
        experiments.map((key, value) => MapEntry(key, value.toJson()));
    await _prefs.setString(_experimentsKey, jsonEncode(jsonMap));
  }

  Future<Map<String, String>> _loadUserVariants() async {
    final jsonMap = _prefs.getString(_userVariantKey);
    if (jsonMap == null) return {};

    return Map<String, String>.from(jsonDecode(jsonMap));
  }

  Future<void> _saveUserVariants(Map<String, String> variants) async {
    await _prefs.setString(_userVariantKey, jsonEncode(variants));
  }

  Future<List<ExperimentEvent>> _loadExperimentEvents(
      String experimentId) async {
    final key = 'ab_testing_events_$experimentId';
    final jsonList = _prefs.getStringList(key) ?? [];

    return jsonList.map((json) {
      final map = Map<String, dynamic>.from(jsonDecode(json));
      return ExperimentEvent.fromJson(map);
    }).toList();
  }

  Future<void> _saveExperimentEvents(
      String experimentId, List<ExperimentEvent> events) async {
    final key = 'ab_testing_events_$experimentId';
    final jsonList = events.map((event) => jsonEncode(event.toJson())).toList();
    await _prefs.setStringList(key, jsonList);
  }
}

/// Represents an A/B testing experiment.
class Experiment {
  final String id;
  final String name;
  final String description;
  final List<Variant> variants;
  final List<String> conversionEvents;
  final DateTime startDate;
  final DateTime? endDate;

  const Experiment({
    required this.id,
    required this.name,
    required this.description,
    required this.variants,
    required this.conversionEvents,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'variants': variants.map((v) => v.toJson()).toList(),
        'conversionEvents': conversionEvents,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  factory Experiment.fromJson(Map<String, dynamic> json) => Experiment(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        variants:
            (json['variants'] as List).map((v) => Variant.fromJson(v)).toList(),
        conversionEvents: List<String>.from(json['conversionEvents']),
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      );
}

/// Represents a variant in an experiment.
class Variant {
  final String id;
  final String name;
  final String description;
  final double trafficAllocation;

  const Variant({
    required this.id,
    required this.name,
    required this.description,
    required this.trafficAllocation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'trafficAllocation': trafficAllocation,
      };

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        trafficAllocation: json['trafficAllocation'],
      );
}

/// Represents an event in an experiment.
class ExperimentEvent {
  final String experimentId;
  final String eventType;
  final DateTime timestamp;
  final Map<String, dynamic> properties;

  const ExperimentEvent({
    required this.experimentId,
    required this.eventType,
    required this.timestamp,
    required this.properties,
  });

  Map<String, dynamic> toJson() => {
        'experimentId': experimentId,
        'eventType': eventType,
        'timestamp': timestamp.toIso8601String(),
        'properties': properties,
      };

  factory ExperimentEvent.fromJson(Map<String, dynamic> json) =>
      ExperimentEvent(
        experimentId: json['experimentId'],
        eventType: json['eventType'],
        timestamp: DateTime.parse(json['timestamp']),
        properties: Map<String, dynamic>.from(json['properties']),
      );
}

/// Results of an experiment.
class ExperimentResults {
  final String experimentId;
  final Map<String, VariantResult> variantResults;
  final int totalParticipants;
  final int totalConversions;

  const ExperimentResults({
    required this.experimentId,
    required this.variantResults,
    required this.totalParticipants,
    required this.totalConversions,
  });

  double get overallConversionRate =>
      totalParticipants > 0 ? totalConversions / totalParticipants : 0.0;
}

/// Results for a specific variant.
class VariantResult {
  final String variantId;
  int participantCount;
  int conversionCount;
  double conversionRate;
  final List<ExperimentEvent> events;

  VariantResult({
    required this.variantId,
    required this.participantCount,
    required this.conversionCount,
    required this.conversionRate,
    required this.events,
  });
}
