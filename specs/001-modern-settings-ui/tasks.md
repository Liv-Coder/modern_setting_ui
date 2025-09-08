# Tasks: Modern Settings UI

**Input**: Design documents from `/specs/001-modern-settings-ui/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)

```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `test/` at repository root
- Paths shown below assume single project - adjust based on plan.md structure

## Phase 3.1: Setup

- [ ] T001 Create Flutter package structure per implementation plan
- [ ] T002 Initialize Dart project with Flutter dependencies
- [ ] T003 [P] Configure linting and formatting tools

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3

**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**

- [ ] T004 [P] Contract test for ModernSettingsUI widget in test/contract/test_modern_settings_ui.dart
- [ ] T005 [P] Contract test for SettingsSection widget in test/contract/test_settings_section.dart
- [ ] T006 [P] Contract test for SettingsSwitch widget in test/contract/test_settings_switch.dart
- [ ] T007 [P] Contract test for SettingsDropdown widget in test/contract/test_settings_dropdown.dart
- [ ] T008 [P] Integration test for developer usage scenario in test/integration/test_developer_usage.dart
- [ ] T009 [P] Integration test for end user interaction in test/integration/test_end_user_interaction.dart

## Phase 3.3: Core Implementation (ONLY after tests are failing)

- [ ] T010 [P] SettingsScreen model in lib/src/models/settings_screen.dart
- [ ] T011 [P] SettingsSection model in lib/src/models/settings_section.dart
- [ ] T012 [P] SettingsItem model in lib/src/models/settings_item.dart
- [ ] T013 [P] SettingsTheme model in lib/src/models/settings_theme.dart
- [ ] T014 [P] UserPreference model in lib/src/models/user_preference.dart
- [ ] T015 ModernSettingsUI widget in lib/src/widgets/modern_settings_ui.dart
- [ ] T016 SettingsSection widget in lib/src/widgets/settings_section.dart
- [ ] T017 SettingsSwitch widget in lib/src/widgets/settings_switch.dart
- [ ] T018 SettingsDropdown widget in lib/src/widgets/settings_dropdown.dart
- [ ] T019 SettingsTheme class in lib/src/themes/settings_theme.dart

## Phase 3.4: Integration

- [ ] T020 SharedPreferences integration in lib/src/services/preferences_service.dart
- [ ] T021 Localization support with intl in lib/src/localization/

## Phase 3.5: Polish

- [x] T022 [P] Unit tests for models in test/unit/test_models.dart
- [x] T023 Performance tests
- [x] T024 [P] Update README.md
- [x] T025 Create example app in example/

## Dependencies

- Tests (T004-T009) before implementation (T010-T019)
- Models (T010-T014) before widgets (T015-T019)
- Widgets before integration (T020-T021)
- Implementation before polish (T022-T025)

## Parallel Example

```
# Launch T004-T009 together:
Task: "Contract test for ModernSettingsUI widget in test/contract/test_modern_settings_ui.dart"
Task: "Contract test for SettingsSection widget in test/contract/test_settings_section.dart"
Task: "Contract test for SettingsSwitch widget in test/contract/test_settings_switch.dart"
Task: "Contract test for SettingsDropdown widget in test/contract/test_settings_dropdown.dart"
Task: "Integration test for developer usage scenario in test/integration/test_developer_usage.dart"
Task: "Integration test for end user interaction in test/integration/test_end_user_interaction.dart"
```

## Notes

- [P] tasks = different files, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same file conflicts

## Task Generation Rules

_Applied during main() execution_

1. **From Contracts**:

   - Each contract file → contract test task [P]
   - Each endpoint → implementation task

2. **From Data Model**:

   - Each entity → model creation task [P]
   - Relationships → service layer tasks

3. **From User Stories**:

   - Each story → integration test [P]
   - Quickstart scenarios → validation tasks

4. **Ordering**:
   - Setup → Tests → Models → Services → Endpoints → Polish
   - Dependencies block parallel execution

## Validation Checklist

_GATE: Checked by main() before returning_

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task
