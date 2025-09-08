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
- 🧠 **Smart Features**: Context awareness, A/B testing, personalization
- 🎭 **Advanced Animations**: Custom curves, duration controls, preview system
- 📊 **Analytics Ready**: User interaction tracking and insights

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

### Smart Features

#### Context Awareness

The package includes intelligent context awareness that learns from user interactions:

```dart
final contextService = ContextAwarenessService();

// Analyze user interaction patterns
final insights = await contextService.analyzeUserInteractions();

// Get personalized suggestions
final suggestions = await contextService.getPersonalizedSuggestions();
```

#### A/B Testing Framework

Built-in A/B testing with traffic allocation and results tracking:

```dart
final abTesting = ABTestingFramework();

// Register an experiment
await abTesting.registerExperiment(
  Experiment(
    id: 'theme_variants',
    variants: ['classic', 'modern', 'minimal'],
    trafficAllocation: [0.5, 0.3, 0.2],
  ),
);

// Get variant for current user
final variant = await abTesting.getVariant('theme_variants');
```

#### Personalization Engine

AI-powered personalization that adapts to user preferences:

```dart
final personalization = PersonalizationEngine();

// Learn from user interactions
await personalization.recordInteraction('theme_changed', 'dark_mode');

// Get personalized recommendations
final recommendations = await personalization.getRecommendations();
```

#### Custom Animations

Advanced animation system with preview and customization:

```dart
// Configure custom animations
final config = AnimationConfig(
  enabled: true,
  curve: Curves.elasticOut,
  duration: Duration(milliseconds: 500),
);

// Preview animation
final preview = CustomAnimationsWidget(
  config: config,
  onChanged: (newConfig) {
    // Handle animation changes
  },
);
```

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
