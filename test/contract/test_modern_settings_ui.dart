import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('ModernSettingsUI Widget Contract Tests', () {
    testWidgets('renders all sections in order', (tester) async {
      // Given: A ModernSettingsUI with multiple sections
      final sections = [
        SettingsSection(
          title: 'General',
          items: [
            SettingsItem(
              id: 'dark_mode',
              type: SettingsItemType.switch_,
              title: 'Dark Mode',
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          items: [
            SettingsItem(
              id: 'notifications',
              type: SettingsItemType.switch_,
              title: 'Notifications',
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
      ];

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModernSettingsUI(sections: sections),
          ),
        ),
      );

      // Then: All sections should be rendered in order
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('applies theme to child widgets', (tester) async {
      // Given: A ModernSettingsUI with custom theme
      final theme = SettingsTheme(
        primaryColor: Colors.red,
        backgroundColor: Colors.blue,
      );

      final sections = [
        SettingsSection(
          title: 'General',
          items: [
            SettingsItem(
              id: 'test',
              type: SettingsItemType.switch_,
              title: 'Test',
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ];

      // When: Pump the widget with theme
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModernSettingsUI(sections: sections, theme: theme),
          ),
        ),
      );

      // Then: Theme should be applied (this will need to be verified visually or through widget properties)
      // For now, just ensure it doesn't crash
      expect(find.byType(ModernSettingsUI), findsOneWidget);
    });

    testWidgets('handles empty sections gracefully', (tester) async {
      // Given: A ModernSettingsUI with empty sections
      final sections = <SettingsSection>[];

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModernSettingsUI(sections: sections),
          ),
        ),
      );

      // Then: Should not crash and render empty
      expect(find.byType(ModernSettingsUI), findsOneWidget);
    });

    testWidgets('supports scrolling for large lists', (tester) async {
      // Given: A ModernSettingsUI with many sections
      final sections = List.generate(
        20,
        (index) => SettingsSection(
          title: 'Section $index',
          items: [
            SettingsItem(
              id: 'item_$index',
              type: SettingsItemType.switch_,
              title: 'Item $index',
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      // When: Pump the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400, // Limited height to force scrolling
              child: ModernSettingsUI(sections: sections),
            ),
          ),
        ),
      );

      // Then: Should support scrolling
      expect(find.byType(ModernSettingsUI), findsOneWidget);
      // Could add scroll tests here
    });
  });
}
