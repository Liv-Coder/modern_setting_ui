# Modern Settings UI Package Development Guidelines

Auto-generated from all feature plans. Last updated: [CURRENT_DATE]

## Active Technologies

- **Flutter**: 3.22+ (Material 3, cross-platform UI framework)
- **Dart**: 3.0+ (null safety enabled)
- **Provider**: ^6.1.2 (state management)
- **flutter_hooks**: ^0.20.5 (functional components)
- **intl**: ^0.19.0 (internationalization)
- **shared_preferences**: ^2.5.3 (local persistence)
- **flutter_test**: Unit, widget, integration, and performance testing

## Project Structure

```bash
lib/
├── modern_setting_ui.dart          # Main library export
└── src/
    ├── models/                     # Data models
    │   ├── settings_screen.dart
    │   ├── settings_section.dart
    │   ├── settings_item.dart
    │   ├── settings_theme.dart
    │   └── user_preference.dart
    ├── widgets/                    # UI components
    │   ├── modern_settings_ui.dart
    │   ├── settings_section_widget.dart
    │   ├── settings_switch.dart
    │   ├── settings_dropdown.dart
    │   └── settings_item_widget.dart
    ├── services/                   # Business logic
    │   └── preferences_service.dart
    └── localization/               # Internationalization
        └── modern_settings_ui_localizations.dart

test/
├── models/                        # Unit tests
├── widgets/                       # Widget tests
├── services/                      # Service tests
├── integration/                   # Integration tests
└── performance/                   # Performance tests

example/                           # Demo application
├── lib/
├── test/
└── pubspec.yaml
```

## Commands

### Flutter Commands

- `flutter create .` - Initialize Flutter project
- `flutter pub get` - Install dependencies
- `flutter analyze` - Static analysis (linting)
- `flutter test` - Run all tests
- `flutter test --coverage` - Run tests with coverage
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter pub publish` - Publish to pub.dev

### Development Workflow

- `flutter run` - Run app in debug mode
- `flutter run --release` - Run app in release mode
- `flutter doctor` - Check Flutter installation
- `flutter clean` - Clean build artifacts

## Code Style

### Dart/Flutter Conventions

- Use `const` constructors where possible
- Prefix private fields with underscore: `_privateField`
- Use null safety throughout
- Follow Material 3 design patterns
- Implement proper state management with Provider
- Handle async operations gracefully
- Provide clear, typed APIs with documentation
- Use meaningful variable and method names
- Follow TDD: write tests before implementation

### File Organization

- One class per file (except simple related classes)
- Group related functionality in feature directories
- Use relative imports within lib/
- Export public APIs through main library file

## Recent Changes

### Modern Settings UI Package (v0.0.1)

- Complete Flutter package for modern settings screens
- Material 3 design with customizable themes
- Comprehensive test suite (unit, widget, integration, performance)
- Accessibility support and internationalization
- SharedPreferences integration for persistence
- Provider state management
- Example application demonstrating usage

### Quality Assurance

- Zero linting errors (flutter analyze)
- 100% test coverage target
- Performance benchmarks (<200ms initialization)
- Cross-platform compatibility (iOS, Android, Web)

### Documentation

- Comprehensive README with usage examples
- API documentation for all public classes
- CHANGELOG.md with version history
- Example app with working implementation

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
