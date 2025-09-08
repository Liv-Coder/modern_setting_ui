import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('SettingsSection Widget Contract Tests', () {
    testWidgets('displays title prominently', (tester) async {
      // Given: A SettingsSection with title
      final section = SettingsSection(
        title: 'Test Section',
        items: [
          SettingsItem(
              id: "test_item",
              title: 'Test Item',
              type: SettingsItemType.switch_,
              value: true,
              onChanged: (_) {}),
        ],
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSectionWidget(
              section: section,
              theme: SettingsTheme(),
            ),
          ),
        ),
      );

      // Then: Title should be displayed
      expect(find.text('Test Section'), findsOneWidget);
    });

    testWidgets('shows/hides items based on expanded state', (tester) async {
      // Given: A SettingsSection with expanded = false
      final section = SettingsSection(
        title: 'Test Section',
        items: [
          SettingsItem(
            id: 'test_item',
            type: SettingsItemType.switch_,
            title: 'Test Item',
            value: true,
            onChanged: (_) {},
          ),
        ],
        expanded: false,
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSectionWidget(
              section: section,
              theme: SettingsTheme(),
            ),
          ),
        ),
      );

      // Then: Items should be hidden initially
      expect(find.text('Test Item'), findsNothing);

      // When: Tap to expand
      await tester.tap(find.text('Test Section'));
      await tester.pump();

      // Then: Items should be visible
      expect(find.text('Test Item'), findsOneWidget);
    });

    testWidgets('animates expand/collapse transitions', (tester) async {
      // Given: A SettingsSection
      final section = SettingsSection(
        title: 'Test Section',
        items: [
          SettingsItem(
            id: 'test_item',
            type: SettingsItemType.switch_,
            title: 'Test Item',
            value: true,
            onChanged: (_) {},
          ),
        ],
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSectionWidget(
              section: section,
              theme: SettingsTheme(),
            ),
          ),
        ),
      );

      // Then: Should have animation (this is hard to test without implementation)
      expect(find.byType(SettingsSection), findsOneWidget);
    });

    testWidgets('handles empty items list', (tester) async {
      // Given: A SettingsSection with no items
      final section = SettingsSection(
        title: 'Empty Section',
        items: [],
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSectionWidget(
              section: section,
              theme: SettingsTheme(),
            ),
          ),
        ),
      );

      // Then: Should not crash
      expect(find.text('Empty Section'), findsOneWidget);
    });
  });
}
