# Quickstart: Modern Settings UI

## Installation

Add to pubspec.yaml:

```yaml
dependencies:
  modern_settings_ui: ^1.0.0
```

## Basic Usage

```dart
import 'package:modern_settings_ui/modern_settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ModernSettingsUI(
        sections: [
          SettingsSection(
            title: 'General',
            items: [
              SettingsSwitch(
                title: 'Dark Mode',
                value: true,
                onChanged: (value) {
                  // Handle dark mode toggle
                },
              ),
              SettingsDropdown(
                title: 'Language',
                options: ['English', 'Spanish', 'French'],
                value: 'English',
                onChanged: (value) {
                  // Handle language change
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Customization

```dart
ModernSettingsUI(
  theme: SettingsTheme(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16),
  ),
  sections: [...],
)
```

## Testing

```dart
testWidgets('Settings screen renders correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SettingsScreen(),
    ),
  );

  expect(find.text('General'), findsOneWidget);
  expect(find.byType(SettingsSwitch), findsOneWidget);
});
```

## Next Steps

- Explore all available widgets
- Implement persistence with SharedPreferences
- Add custom themes
- Test on multiple platforms

This quickstart should take less than 10 minutes to complete.
