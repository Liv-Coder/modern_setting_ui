import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/widgets/theme_transition_controller.dart';
import 'package:modern_setting_ui/src/models/settings_theme.dart';
import 'package:flutter/scheduler.dart';

class MockTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'MockTicker');
  }
}

void main() {
  late SettingsTheme lightTheme;
  late SettingsTheme darkTheme;

  setUp(() {
    lightTheme = const SettingsTheme(
      brightness: Brightness.light,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF64B5F6),
      backgroundColor: Color(0xFFFFFFFF),
      surfaceColor: Color(0xFFFFFFFF),
    );

    darkTheme = const SettingsTheme(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF64B5F6),
      backgroundColor: Color(0xFF121212),
      surfaceColor: Color(0xFF1E1E1E),
    );
  });

  group('ThemeTransitionController', () {
    testWidgets('should initialize with provided theme',
        (WidgetTester tester) async {
      final controller = ThemeTransitionController(initialTheme: lightTheme);

      expect(controller.currentTheme.brightness, equals(Brightness.light));
      expect(controller.currentTheme.primaryColor,
          equals(const Color(0xFF2196F3)));
    });

    testWidgets('should handle instant theme switch',
        (WidgetTester tester) async {
      final controller = ThemeTransitionController(initialTheme: lightTheme);

      controller.switchToTheme(darkTheme);

      expect(controller.currentTheme.brightness, equals(Brightness.dark));
      expect(controller.isAnimating, isFalse);
    });

    test('should get theme at specific progress', () {
      final controller = ThemeTransitionController(initialTheme: lightTheme);

      final progressTheme = controller.getThemeAtProgress(0.5);

      // Since no animation is running, should return current theme
      expect(progressTheme.brightness, equals(Brightness.light));
      expect(progressTheme.primaryColor, equals(lightTheme.primaryColor));
    });

    testWidgets('should dispose properly', (WidgetTester tester) async {
      final controller = ThemeTransitionController(initialTheme: lightTheme);

      controller.dispose();

      expect(controller.isAnimating, isFalse);
    });

    test('should get theme at specific progress', () {
      final controller = ThemeTransitionController(initialTheme: lightTheme);

      final progressTheme = controller.getThemeAtProgress(0.5);

      // Since no animation is running, should return current theme
      expect(progressTheme.brightness, equals(Brightness.light));
      expect(progressTheme.primaryColor, equals(lightTheme.primaryColor));
    });
  });
}
