# Modern Settings UI Package Development Guidelines

Auto-generated from all feature plans. Last updated: [CURRENT_DATE]

## Active Technologies

- **Flutter**: 3.22+ (Material 3, cross-platform UI framework)
- **Dart**: 3.0+ (null safety enabled)
- **Provider**: ^6.1.2 (state management)
- **flutter_hooks**: ^0.20.5 (functional components)
- **intl**: ^0.19.0 (internationalization)
- **shared_preferences**: ^2.5.3 (local persistence)
- **flutter_cache_manager**: Optional (advanced caching)
- **tflite_flutter**: Optional (ML personalization)
- **flutter_test**: Unit, widget, integration, performance, theming, and scale testing

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
    │   ├── user_preference.dart
    │   ├── brand_color_scheme.dart
    │   └── ab_test_variant.dart
    ├── widgets/                    # UI components
    │   ├── modern_settings_ui.dart
    │   ├── settings_section_widget.dart
    │   ├── settings_switch.dart
    │   ├── settings_dropdown.dart
    │   ├── settings_item_widget.dart
    │   ├── theme_transition_controller.dart
    │   ├── custom_animations.dart
    │   ├── auto_complete_widget.dart
    │   ├── adaptive_ui_components.dart
    │   └── virtualized_settings_list.dart
    ├── services/                   # Business logic
    │   ├── preferences_service.dart
    │   ├── dynamic_theme_service.dart
    │   ├── auto_complete_service.dart
    │   ├── context_awareness_service.dart
    │   ├── ab_testing_framework.dart
    │   ├── personalization_engine.dart
    │   ├── virtualization_controller.dart
    │   ├── lazy_loading_service.dart
    │   ├── intelligent_cache_manager.dart
    │   ├── offline_mode_service.dart
    │   └── performance_monitor.dart
    └── localization/               # Internationalization
        └── modern_settings_ui_localizations.dart

test/
├── models/                        # Unit tests
├── widgets/                       # Widget tests
├── services/                      # Service tests
├── integration/                   # Integration tests
├── performance/                   # Performance tests
├── theming/                       # Theme switching tests
└── scale/                         # Scale and virtualization tests

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

### Modern Settings UI Package (v1.1.0)

- Complete Flutter package for modern settings screens
- Material 3 design with customizable themes
- Advanced theming: Dynamic theme switching, custom animations, brand integration
- Smart features: Auto-complete, context awareness, A/B testing, ML personalization
- Performance & scale: Virtualization for 1000+ settings, lazy loading, intelligent caching, offline mode
- Comprehensive test suite (unit, widget, integration, performance, theming, scale)
- Accessibility support and internationalization
- SharedPreferences integration for persistence
- Provider state management
- Example application demonstrating usage

### Quality Assurance

- Zero linting errors (flutter analyze)
- 100% test coverage target
- Performance benchmarks (<200ms initialization, <100ms theme switching, <100ms auto-complete)
- Cross-platform compatibility (iOS, Android, Web)
- Advanced theming validation (<200ms theme switching)
- Smart features testing (auto-complete, A/B testing isolation)
- Scale testing (1000+ settings virtualization, offline mode)

### Documentation

- Comprehensive README with usage examples
- API documentation for all public classes
- CHANGELOG.md with version history
- Example app with working implementation

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
