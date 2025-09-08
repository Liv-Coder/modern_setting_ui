/// Types of preference values.
enum PreferenceType {
  /// Boolean value.
  boolean,

  /// String value.
  string,

  /// Integer value.
  integer,

  /// Double value.
  double,

  /// List of strings.
  stringList,
}

/// Represents a persistent user preference.
class UserPreference {
  /// Unique key for the preference.
  final String key;

  /// The value of the preference.
  final dynamic value;

  /// The type of the preference value.
  final PreferenceType type;

  /// Creates a new UserPreference.
  UserPreference({
    required this.key,
    required this.value,
    required this.type,
  }) : assert(key.isNotEmpty, 'UserPreference key cannot be empty');
}
