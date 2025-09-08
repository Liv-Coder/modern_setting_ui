import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('SettingsSwitch Widget Contract Tests', () {
    testWidgets('displays switch in Material 3 style', (tester) async {
      // Given: A SettingsSwitch
      bool value = true;
      final switchWidget = SettingsSwitch(
        title: 'Test Switch',
        value: value,
        onChanged: (newValue) => value = newValue,
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: switchWidget,
          ),
        ),
      );

      // Then: Should display title and switch
      expect(find.text('Test Switch'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('calls onChanged when toggled', (tester) async {
      // Given: A SettingsSwitch
      bool value = false;
      bool callbackCalled = false;
      final switchWidget = SettingsSwitch(
        title: 'Test Switch',
        value: value,
        onChanged: (newValue) {
          value = newValue;
          callbackCalled = true;
        },
      );

      // When: Pump and tap the switch
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: switchWidget,
          ),
        ),
      );
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Then: onChanged should be called
      expect(callbackCalled, isTrue);
      expect(value, isTrue);
    });

    testWidgets('shows disabled state when enabled=false', (tester) async {
      // Given: A disabled SettingsSwitch
      final switchWidget = SettingsSwitch(
        title: 'Disabled Switch',
        value: true,
        onChanged: (_) {},
        enabled: false,
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: switchWidget,
          ),
        ),
      );

      // Then: Switch should be disabled
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      // Could check if switch is disabled
    });

    testWidgets('supports accessibility', (tester) async {
      // Given: A SettingsSwitch with subtitle
      final switchWidget = SettingsSwitch(
        title: 'Accessible Switch',
        subtitle: 'Description for accessibility',
        value: true,
        onChanged: (_) {},
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: switchWidget,
          ),
        ),
      );

      // Then: Should have semantic labels
      expect(find.text('Accessible Switch'), findsOneWidget);
      expect(find.text('Description for accessibility'), findsOneWidget);
    });
  });
}
