import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/services/dynamic_theme_service.dart';
import 'package:modern_setting_ui/src/models/settings_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DynamicThemeService themeService;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    themeService = DynamicThemeService(prefs);
  });

  group('DynamicThemeService', () {
    test('should initialize with default theme', () async {
      final theme = await themeService.getCurrentTheme();
      expect(theme, isNotNull);
      expect(theme.brightness, equals(Brightness.light));
    });

    test('should switch theme at runtime', () async {
      final darkTheme = SettingsTheme(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        secondaryColor: Colors.blueAccent,
      );

      await themeService.switchTheme(darkTheme);
      final currentTheme = await themeService.getCurrentTheme();

      expect(currentTheme.brightness, equals(Brightness.dark));
      expect(currentTheme.primaryColor, equals(Colors.blue));
    });

    test('should persist theme changes', () async {
      final customTheme = SettingsTheme(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF9C27B0),
        secondaryColor: const Color(0xFFBA68C8),
      );

      await themeService.switchTheme(customTheme);

      // Create new instance to test persistence
      final newThemeService = DynamicThemeService(prefs);
      final persistedTheme = await newThemeService.getCurrentTheme();

      expect(persistedTheme.brightness, equals(Brightness.dark));
      expect(persistedTheme.primaryColor, equals(const Color(0xFF9C27B0)));
    });

    test('should notify listeners on theme change', () async {
      final customTheme = SettingsTheme(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4CAF50),
        secondaryColor: const Color(0xFF81C784),
      );

      SettingsTheme? notifiedTheme;
      bool listenerCalled = false;

      themeService.addListener(() {
        listenerCalled = true;
        notifiedTheme = themeService.currentTheme;
      });

      await themeService.switchTheme(customTheme);

      expect(listenerCalled, isTrue);
      expect(notifiedTheme, isNotNull);
      expect(notifiedTheme!.brightness, equals(Brightness.dark));
    });

    test('should handle theme switching performance within 200ms', () async {
      final customTheme = SettingsTheme(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        secondaryColor: Colors.redAccent,
      );

      final stopwatch = Stopwatch()..start();
      await themeService.switchTheme(customTheme);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });

    test('should create theme transition', () async {
      final lightTheme = SettingsTheme(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2196F3),
        secondaryColor: const Color(0xFF64B5F6),
      );

      final darkTheme = SettingsTheme(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2196F3),
        secondaryColor: const Color(0xFF64B5F6),
      );

      // Test theme transition at 50% progress
      final transitionTheme = themeService.createThemeTransition(
        lightTheme,
        darkTheme,
        0.5,
      );

      expect(transitionTheme.primaryColor, equals(const Color(0xFF2196F3)));
      expect(transitionTheme.secondaryColor, equals(const Color(0xFF64B5F6)));
    });
  });
}
