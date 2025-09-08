import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_setting_ui/src/models/settings_theme.dart';

/// Service for managing dynamic theme switching and persistence.
class DynamicThemeService extends ChangeNotifier {
  static const String _themeKey = 'modern_settings_theme';
  static const String _themeHistoryKey = 'modern_settings_theme_history';

  final SharedPreferences _prefs;
  SettingsTheme _currentTheme;
  final List<SettingsTheme> _themeHistory = [];

  /// Creates a new DynamicThemeService.
  DynamicThemeService(this._prefs) : _currentTheme = _createDefaultTheme() {
    _loadTheme();
  }

  /// Gets the current theme.
  SettingsTheme get currentTheme => _currentTheme;

  /// Gets the theme history for undo functionality.
  List<SettingsTheme> get themeHistory => List.unmodifiable(_themeHistory);

  /// Switches to a new theme with performance optimization.
  Future<void> switchTheme(SettingsTheme newTheme) async {
    final stopwatch = Stopwatch()..start();

    // Save current theme to history for undo functionality
    _themeHistory.add(_currentTheme);

    // Limit history to last 10 themes
    if (_themeHistory.length > 10) {
      _themeHistory.removeAt(0);
    }

    _currentTheme = newTheme;

    // Persist the new theme
    await _saveTheme();

    stopwatch.stop();

    // Ensure theme switching is within performance requirements (<200ms)
    assert(stopwatch.elapsedMilliseconds < 200,
        'Theme switching took ${stopwatch.elapsedMilliseconds}ms, should be <200ms');

    // Notify listeners about theme change
    notifyListeners();
  }

  /// Gets the current theme asynchronously.
  Future<SettingsTheme> getCurrentTheme() async {
    return _currentTheme;
  }

  /// Reverts to the previous theme if available.
  Future<bool> undoThemeChange() async {
    if (_themeHistory.isNotEmpty) {
      final previousTheme = _themeHistory.removeLast();
      await switchTheme(previousTheme);
      return true;
    }
    return false;
  }

  /// Resets to the default theme.
  Future<void> resetToDefault() async {
    await switchTheme(_createDefaultTheme());
  }

  /// Creates a theme transition animation.
  SettingsTheme createThemeTransition(
    SettingsTheme fromTheme,
    SettingsTheme toTheme,
    double progress,
  ) {
    return SettingsTheme(
      brightness: progress < 0.5 ? fromTheme.brightness : toTheme.brightness,
      primaryColor:
          Color.lerp(fromTheme.primaryColor, toTheme.primaryColor, progress)!,
      secondaryColor: Color.lerp(
          fromTheme.secondaryColor, toTheme.secondaryColor, progress)!,
      backgroundColor: Color.lerp(
          fromTheme.backgroundColor, toTheme.backgroundColor, progress),
      surfaceColor:
          Color.lerp(fromTheme.surfaceColor, toTheme.surfaceColor, progress),
      itemHeight:
          lerpDouble(fromTheme.itemHeight, toTheme.itemHeight, progress),
      borderRadius:
          lerpDouble(fromTheme.borderRadius, toTheme.borderRadius, progress),
      transitionDuration: toTheme.transitionDuration,
    );
  }

  /// Preloads a theme for faster switching.
  Future<void> preloadTheme(SettingsTheme theme) async {
    // In a real implementation, this could preload theme assets
    // For now, just validate the theme
    _validateTheme(theme);
  }

  /// Validates a theme configuration.
  void _validateTheme(SettingsTheme theme) {
    // Since fields are now non-nullable, just ensure they have valid values
    assert((theme.primaryColor.a * 255.0).round() & 0xff > 0,
        'Theme must have a valid primary color');
    assert((theme.secondaryColor.a * 255.0).round() & 0xff > 0,
        'Theme must have a valid secondary color');
  }

  /// Loads the theme from persistent storage.
  Future<void> _loadTheme() async {
    final themeJson = _prefs.getString(_themeKey);
    if (themeJson != null) {
      try {
        final themeMap = jsonDecode(themeJson) as Map<String, dynamic>;
        _currentTheme = SettingsTheme.fromJson(themeMap);
      } catch (e) {
        // If loading fails, use default theme
        _currentTheme = _createDefaultTheme();
      }
    }

    // Load theme history
    final historyJson = _prefs.getString(_themeHistoryKey);
    if (historyJson != null) {
      try {
        final historyList = jsonDecode(historyJson) as List;
        _themeHistory.clear();
        for (final item in historyList) {
          if (item is Map<String, dynamic>) {
            _themeHistory.add(SettingsTheme.fromJson(item));
          }
        }
      } catch (e) {
        // If history loading fails, clear it
        _themeHistory.clear();
      }
    }
  }

  /// Saves the current theme to persistent storage.
  Future<void> _saveTheme() async {
    final themeJson = jsonEncode(_currentTheme.toJson());
    await _prefs.setString(_themeKey, themeJson);

    // Save theme history
    final historyJson =
        jsonEncode(_themeHistory.map((t) => t.toJson()).toList());
    await _prefs.setString(_themeHistoryKey, historyJson);
  }

  /// Creates the default theme.
  static SettingsTheme _createDefaultTheme() {
    return const SettingsTheme(
      brightness: Brightness.light,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF64B5F6),
      backgroundColor: Color(0xFFFFFFFF),
      surfaceColor: Color(0xFFFFFFFF),
      itemHeight: 56.0,
      borderRadius: 8.0,
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}
