import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_preference.dart';
import '../models/settings_item.dart';

/// Service for managing user preferences using SharedPreferences.
class PreferencesService {
  static const String _prefix = 'modern_settings_ui_';

  /// Saves a user preference.
  Future<void> savePreference(UserPreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefix + preference.key;

    switch (preference.type) {
      case PreferenceType.boolean:
        await prefs.setBool(key, preference.value as bool);
        break;
      case PreferenceType.string:
        await prefs.setString(key, preference.value as String);
        break;
      case PreferenceType.integer:
        await prefs.setInt(key, preference.value as int);
        break;
      case PreferenceType.double:
        await prefs.setDouble(key, preference.value as double);
        break;
      case PreferenceType.stringList:
        await prefs.setStringList(key, preference.value as List<String>);
        break;
    }
  }

  /// Loads a user preference.
  Future<UserPreference?> loadPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final fullKey = _prefix + key;

    if (!prefs.containsKey(fullKey)) {
      return null;
    }

    final value = prefs.get(fullKey);
    final type = _determineType(value);

    return UserPreference(key: key, value: value, type: type);
  }

  /// Loads all user preferences.
  Future<List<UserPreference>> loadAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_prefix));

    final preferences = <UserPreference>[];
    for (final key in keys) {
      final cleanKey = key.substring(_prefix.length);
      final preference = await loadPreference(cleanKey);
      if (preference != null) {
        preferences.add(preference);
      }
    }

    return preferences;
  }

  /// Deletes a user preference.
  Future<void> deletePreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final fullKey = _prefix + key;
    await prefs.remove(fullKey);
  }

  /// Clears all user preferences.
  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((key) => key.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Updates preference from settings item.
  Future<void> updateFromSettingsItem(SettingsItem item) async {
    final preference = UserPreference(
      key: item.id,
      value: item.value,
      type: _determineType(item.value),
    );
    await savePreference(preference);
  }

  PreferenceType _determineType(dynamic value) {
    if (value is bool) return PreferenceType.boolean;
    if (value is String) return PreferenceType.string;
    if (value is int) return PreferenceType.integer;
    if (value is double) return PreferenceType.double;
    if (value is List<String>) return PreferenceType.stringList;
    return PreferenceType.string; // Default
  }
}
