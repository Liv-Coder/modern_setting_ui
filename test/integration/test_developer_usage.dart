import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('Developer Usage Integration Tests', () {
    testWidgets('developer can import and use the package', (tester) async {
      // Given: A Flutter app that imports the package
      final app = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Settings')),
          body: ModernSettingsUI(
            sections: [
              SettingsSection(
                title: 'General',
                items: [
                  SettingsItem(
                    id: 'dark_mode',
                    type: SettingsItemType.switch_,
                    title: 'Dark Mode',
                    value: true,
                    onChanged: (value) {
                      // Handle dark mode toggle
                    },
                  ),
                  SettingsItem(
                    id: 'language',
                    type: SettingsItemType.dropdown,
                    title: 'Language',
                    value: 'English',
                    onChanged: (value) {
                      // Handle language change
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // When: The app is run
      await tester.pumpWidget(app);

      // Then: The settings screen should render correctly
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('developer can customize styles and themes', (tester) async {
      // Given: A customized settings screen
      final theme = SettingsTheme(
        primaryColor: Colors.blue,
        backgroundColor: Colors.grey[100],
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );

      final app = MaterialApp(
        home: Scaffold(
          body: ModernSettingsUI(
            theme: theme,
            sections: [
              SettingsSection(
                title: 'Appearance',
                items: [
                  SettingsItem(
                    id: 'bold_text',
                    type: SettingsItemType.switch_,
                    title: 'Bold Text',
                    value: false,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // When: The app is run
      await tester.pumpWidget(app);

      // Then: The customized theme should be applied
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Bold Text'), findsOneWidget);
    });

    testWidgets('developer can compose settings screen in minutes',
        (tester) async {
      // Given: A complex settings screen
      final sections = [
        SettingsSection(
          title: 'Account',
          items: [
            SettingsItem(
              id: 'email_notifications',
              type: SettingsItemType.switch_,
              title: 'Email Notifications',
              value: true,
              onChanged: (_) {},
            ),
            SettingsItem(
              id: 'push_notifications',
              type: SettingsItemType.switch_,
              title: 'Push Notifications',
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Privacy',
          items: [
            SettingsItem(
              id: 'data_sharing',
              type: SettingsItemType.dropdown,
              title: 'Data Sharing',
              value: 'Basic',
              onChanged: (_) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Support',
          items: [
            SettingsItem(
              id: 'crash_reports',
              type: SettingsItemType.switch_,
              title: 'Crash Reports',
              value: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ];

      final app = MaterialApp(
        home: Scaffold(
          body: ModernSettingsUI(sections: sections),
        ),
      );

      // When: The app is run
      await tester.pumpWidget(app);

      // Then: All sections and items should render
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Email Notifications'), findsOneWidget);
      expect(find.text('Data Sharing'), findsOneWidget);
    });
  });
}
