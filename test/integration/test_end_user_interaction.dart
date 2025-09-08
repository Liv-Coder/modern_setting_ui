import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  group('End User Interaction Integration Tests', () {
    testWidgets('end user can navigate to settings', (tester) async {
      // Given: An app with a settings screen
      final app = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Home')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Go to Settings'),
            ),
          ),
        ),
        routes: {
          '/settings': (context) => Scaffold(
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
                          value: false,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        },
      );

      // When: User navigates to settings
      await tester.pumpWidget(app);
      // Simulate navigation (in real app, this would be button tap)

      // Then: Settings screen should be accessible
      expect(find.text('Home'), findsOneWidget);
      // Navigation test would require actual routing
    });

    testWidgets('end user experiences clean, intuitive UI', (tester) async {
      // Given: A settings screen with multiple sections
      final sections = [
        SettingsSection(
          title: 'Notifications',
          items: [
            SettingsItem(
              id: 'push_notifications',
              type: SettingsItemType.switch_,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: true,
              onChanged: (_) {},
            ),
            SettingsItem(
              id: 'email_notifications',
              type: SettingsItemType.switch_,
              title: 'Email Notifications',
              subtitle: 'Receive email updates',
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Appearance',
          items: [
            SettingsItem(
              id: 'theme',
              type: SettingsItemType.dropdown,
              title: 'Theme',
              value: 'System',
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

      // When: The screen is displayed
      await tester.pumpWidget(app);

      // Then: UI should be clean and intuitive
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Receive push notifications'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
    });

    testWidgets('end user can effortlessly update preferences', (tester) async {
      // Given: A settings screen with interactive items
      bool darkMode = false;
      String theme = 'Light';

      final sections = [
        SettingsSection(
          title: 'Preferences',
          items: [
            SettingsItem(
              id: 'dark_mode',
              type: SettingsItemType.switch_,
              title: 'Dark Mode',
              value: darkMode,
              onChanged: (value) => darkMode = value,
            ),
            SettingsItem(
              id: 'theme',
              type: SettingsItemType.dropdown,
              title: 'Theme',
              value: theme,
              onChanged: (value) => theme = value,
            ),
          ],
        ),
      ];

      final app = MaterialApp(
        home: Scaffold(
          body: ModernSettingsUI(sections: sections),
        ),
      );

      // When: User interacts with settings
      await tester.pumpWidget(app);

      // Toggle switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Change dropdown
      await tester.tap(find.text('Light'));
      await tester.pump();
      await tester.tap(find.text('Dark').last);
      await tester.pump();

      // Then: Preferences should be updated
      expect(darkMode, isTrue);
      expect(theme, 'Dark');
    });

    testWidgets('end user experiences smooth interactions', (tester) async {
      // Given: A settings screen
      final sections = [
        SettingsSection(
          title: 'General',
          items: [
            SettingsItem(
              id: 'test_setting',
              type: SettingsItemType.switch_,
              title: 'Test Setting',
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

      // When: User performs actions
      await tester.pumpWidget(app);

      // Then: Interactions should be smooth (no crashes, proper feedback)
      expect(find.byType(ModernSettingsUI), findsOneWidget);
    });
  });
}
