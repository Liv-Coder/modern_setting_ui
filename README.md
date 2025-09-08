# Modern Settings UI

A Flutter package for creating modern, customizable settings screens with Material 3 design.

## What's New in v1.1.0

### 🚀 Major Feature Release

**Advanced Smart Features & Enhanced Animations** - Introducing intelligent context awareness, A/B testing framework, personalization engine, and advanced animation system.

#### 🧠 Smart Features

- **Context Awareness Service**: Intelligent analysis of user interaction patterns

  - Time-based analysis (morning/evening preferences)
  - Value-based analysis (frequent selections)
  - Frequency-based analysis (usage patterns)
  - Personalized suggestions and recommendations

- **A/B Testing Framework**: Built-in experimentation platform

  - Traffic allocation and variant assignment
  - Experiment lifecycle management
  - Results tracking and analytics
  - Persistent experiment state

- **Personalization Engine**: AI-powered user experience adaptation
  - User profile learning and pattern recognition
  - Dynamic recommendation generation
  - Preference-based customization
  - Interaction history analysis

#### 🎭 Advanced Animations

- **Custom Animation System**: Comprehensive animation configuration

  - Custom curves and easing functions
  - Adjustable duration controls
  - Real-time animation preview
  - Theme transition animations

- **Animation Widgets**: Specialized animation components
  - `CustomAnimationsWidget`: Full animation configuration interface
  - `AnimationCurveSelector`: Interactive curve selection
  - `AnimationDurationSelector`: Duration adjustment controls

#### 🎨 Brand Integration

- **Brand Color Schemes**: Complete brand color management
- **Brand Assets**: Logo and branding asset handling
- **Theme Customization**: Advanced theming capabilities

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
  modern_setting_ui: ^1.1.0
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
              SettingsItem(
                id: 'dark_mode',
                type: SettingsItemType.switch_,
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                value: true,
                onChanged: (value) {
                  // Handle dark mode toggle
                },
              ),
              SettingsItem(
                id: 'language',
                type: SettingsItemType.dropdown,
                title: 'Language',
                subtitle: 'Select your preferred language',
                value: 'English',
                dropdownOptions: const [
                  DropdownItem(value: 'English', label: 'English'),
                  DropdownItem(value: 'Spanish', label: 'Español'),
                  DropdownItem(value: 'French', label: 'Français'),
                ],
                onChanged: (value) {
                  // Handle language change
                },
              ),
              SettingsItem(
                id: 'notifications',
                type: SettingsItemType.navigation,
                title: 'Notifications',
                subtitle: 'Configure notification preferences',
                onChanged: (value) {
                  // Navigate to notifications screen
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

### Migration from v1.0.x

If you're upgrading from v1.0.x, the API has been simplified to use a unified `SettingsItem` approach:

**Before (v1.0.x):**

```dart
SettingsSwitch(
  title: 'Dark Mode',
  value: true,
  onChanged: (value) => {},
),
SettingsDropdown(
  title: 'Language',
  options: ['English', 'Spanish'],
  value: 'English',
  onChanged: (value) => {},
),
```

**After (v1.1.0):**

```dart
SettingsItem(
  id: 'dark_mode',
  type: SettingsItemType.switch_,
  title: 'Dark Mode',
  value: true,
  onChanged: (value) => {},
),
SettingsItem(
  id: 'language',
  type: SettingsItemType.dropdown,
  title: 'Language',
  value: 'English',
  dropdownOptions: const [
    DropdownItem(value: 'English', label: 'English'),
    DropdownItem(value: 'Spanish', label: 'Español'),
  ],
  onChanged: (value) => {},
),
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

### SettingsItem

The core component for all settings items with support for multiple types:

- **Switch Items**: Toggle switches with Material 3 styling
- **Dropdown Items**: Dropdown selectors with custom options
- **Navigation Items**: Items that navigate to sub-screens
- **Custom Items**: Extensible for custom implementations

### SettingsSection

Groups related settings items with expandable sections and optional icons.

### ModernSettingsUI

The main container widget that orchestrates the settings screen with theming support.

### SettingsItemType

Enum defining the available item types:

- `SettingsItemType.switch_` - Toggle switches
- `SettingsItemType.dropdown` - Dropdown selections
- `SettingsItemType.navigation` - Navigation items
- `SettingsItemType.custom` - Custom implementations

### DropdownItem

Represents individual dropdown options with value, label, and optional icon.

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
