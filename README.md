# Modern Settings UI

A Flutter package for creating modern, customizable settings screens with Material 3 design.

## Features

- 🎨 Modern Material 3 design
- 🔧 Highly customizable themes and styles
- 📱 Cross-platform support (iOS, Android, Web)
- ♿ Accessibility support (screen readers, high contrast)
- 🌐 Internationalization ready
- 💾 Optional persistence with SharedPreferences
- ⚡ Smooth 60fps performance
- 🧩 Modular and extensible architecture

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  modern_setting_ui: ^1.0.0
```

### Basic Usage

```dart
import 'package:modern_setting_ui/modern_setting_ui.dart';

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

### Customization

```dart
ModernSettingsUI(
  theme: SettingsTheme(
    primaryColor: Colors.blue,
    backgroundColor: Colors.grey[100],
    titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
  sections: [...],
)
```

## Components

### SettingsSwitch

A toggle switch with Material 3 styling.

### SettingsDropdown

A dropdown selector with smooth animations.

### SettingsSection

Groups related settings items with expandable sections.

### ModernSettingsUI

The main container widget that orchestrates the settings screen.

## Advanced Usage

### Persistence

```dart
final prefsService = PreferencesService();

// Save preference
await prefsService.savePreference(
  UserPreference(
    key: 'dark_mode',
    value: true,
    type: PreferenceType.boolean,
  ),
);

// Load preference
final preference = await prefsService.loadPreference('dark_mode');
```

### Localization

```dart
// Add to MaterialApp
MaterialApp(
  localizationsDelegates: [
    ModernSettingsUILocalizations.delegate,
    // ... other delegates
  ],
  supportedLocales: [
    const Locale('en', ''),
    const Locale('es', ''),
    const Locale('fr', ''),
  ],
  // ...
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
