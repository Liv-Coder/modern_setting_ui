# GitHub Copilot Instructions for Modern Settings UI

## Project Context

This is a Flutter package for creating modern, customizable settings screens. The package provides ready-to-use UI components that follow Material 3 design patterns.

## Technology Stack

- **Language**: Dart with null safety enabled
- **Framework**: Flutter 3.22+
- **Platform**: Cross-platform (iOS, Android, Web)
- **Dependencies**: provider (optional), flutter_hooks (optional), intl (optional)
- **Testing**: flutter_test, mocktail
- **Persistence**: SharedPreferences (optional)

## Development Guidelines

- Follow Material 3 design specifications
- Ensure accessibility support (screen readers, high contrast)
- Support internationalization with RTL layouts
- Maintain 60fps performance on mid-tier devices
- Use TDD: write tests before implementation
- Keep code modular and customizable

## Code Patterns

- Use const constructors where possible
- Implement proper state management with provider
- Handle async operations gracefully
- Provide clear, typed APIs
- Document all public APIs

## Testing Approach

- Write widget tests for UI components
- Test accessibility features
- Verify cross-platform compatibility
- Include golden tests for visual regression

## Recent Changes

- Initial implementation of Modern Settings UI package
- Added support for switches, dropdowns, and sections
- Implemented theme customization
- Added accessibility features

Keep this file under 150 lines for optimal token usage.
