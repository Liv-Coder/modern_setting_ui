# Modern Settings UI Constitution

## Core Principles

### I. Package-First Architecture

Every feature starts as a standalone Flutter package; Packages must be self-contained, independently testable, documented; Clear purpose required - no organizational-only packages

### II. Widget Interface

Every component exposes functionality via Flutter widgets; Declarative UI protocol: props → widgets, state → internal; Support Material 3 + custom themes

### III. Test-First (NON-NEGOTIABLE)

TDD mandatory: Tests written → User approved → Tests fail → Then implement; Red-Green-Refactor cycle strictly enforced

### IV. Integration Testing

Focus areas requiring integration tests: New widget contract tests, Contract changes, Inter-widget communication, Theme integration

### V. Performance Optimization

60fps rendering required; Memory leaks prohibited; Bundle size optimization mandatory; Accessibility compliance required

### VI. Material 3 Design

Latest Material Design specification compliance; Cross-platform adaptation required; Dark mode support mandatory

### VII. Simplicity

Start simple, YAGNI principles; Maximum 5 core widgets; Clear separation of concerns; Modular architecture

## Technical Standards

### Flutter Requirements

- **SDK**: >=3.22.0
- **Dart**: >=3.0.0
- **Platform Support**: iOS, Android, Web
- **Architecture**: Provider pattern for state management

### Quality Gates

- **Linting**: Zero warnings/errors
- **Testing**: 100% coverage target
- **Performance**: <1000ms rendering, <500ms interactions
- **Accessibility**: WCAG 2.1 AA compliance

### Dependencies

- **Core**: Flutter SDK only
- **State**: Provider ^6.1.2
- **Hooks**: flutter_hooks ^0.20.5
- **I18n**: intl ^0.19.0
- **Storage**: shared_preferences ^2.5.3

## Development Workflow

### Code Review Requirements

- All PRs must pass flutter analyze (0 issues)
- All tests must pass (flutter test)
- Performance benchmarks must be maintained
- Accessibility audit required for UI changes

### Testing Gates

- Unit tests for all models and utilities
- Contract tests for all widgets
- Integration tests for user scenarios
- Performance tests for rendering and interactions

### Deployment Approval

- Version bump following semantic versioning
- CHANGELOG.md updated with all changes
- README.md verified for accuracy
- Example app tested on all platforms

## Governance

Constitution supersedes all other practices; Amendments require documentation, approval, migration plan

All PRs/reviews must verify compliance; Complexity must be justified; Use project documentation for runtime development guidance

**Version**: 1.0.0 | **Ratified**: 2025-09-08 | **Last Amended**: 2025-09-08
