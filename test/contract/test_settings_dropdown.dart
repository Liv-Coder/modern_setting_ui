import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('SettingsDropdown Widget Contract Tests', () {
    testWidgets('displays current value', (tester) async {
      // Given: A SettingsDropdown
      final dropdown = SettingsDropdown(
        title: 'Test Dropdown',
        options: ['Option 1', 'Option 2', 'Option 3'],
        value: 'Option 2',
        onChanged: (_) {},
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: dropdown,
          ),
        ),
      );

      // Then: Should display title and current value
      expect(find.text('Test Dropdown'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('shows dropdown menu on tap', (tester) async {
      // Given: A SettingsDropdown
      final dropdown = SettingsDropdown(
        title: 'Test Dropdown',
        options: ['Option 1', 'Option 2', 'Option 3'],
        value: 'Option 1',
        onChanged: (_) {},
      );

      // When: Pump and tap the dropdown
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: dropdown,
          ),
        ),
      );
      await tester.tap(find.text('Option 1'));
      await tester.pump();

      // Then: Dropdown menu should appear
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('calls onChanged with selected value', (tester) async {
      // Given: A SettingsDropdown
      String selectedValue = 'Option 1';
      final dropdown = SettingsDropdown(
        title: 'Test Dropdown',
        options: ['Option 1', 'Option 2', 'Option 3'],
        value: selectedValue,
        onChanged: (newValue) => selectedValue = newValue,
      );

      // When: Pump, tap, and select option
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: dropdown,
          ),
        ),
      );
      await tester.tap(find.text('Option 1'));
      await tester.pump();
      await tester.tap(find.text('Option 2').last);
      await tester.pump();

      // Then: onChanged should be called with new value
      expect(selectedValue, 'Option 2');
    });

    testWidgets('handles invalid values gracefully', (tester) async {
      // Given: A SettingsDropdown with invalid value
      final dropdown = SettingsDropdown(
        title: 'Test Dropdown',
        options: ['Option 1', 'Option 2', 'Option 3'],
        value: 'Invalid Option',
        onChanged: (_) {},
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: dropdown,
          ),
        ),
      );

      // Then: Should not crash, perhaps show first option or handle gracefully
      expect(find.byType(SettingsDropdown), findsOneWidget);
    });
  });
}
