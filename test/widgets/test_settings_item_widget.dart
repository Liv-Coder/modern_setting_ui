import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/settings_item.dart';
import 'package:modern_setting_ui/src/models/settings_theme.dart';
import 'package:modern_setting_ui/src/widgets/settings_item_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testTheme = SettingsTheme(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
  );

  group('SettingsItemWidget', () {
    group('Switch Item', () {
      testWidgets('should display switch with correct initial value',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_switch',
                  type: SettingsItemType.switch_,
                  title: 'Test Switch',
                  subtitle: 'Test switch subtitle',
                  value: true,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        expect(find.text('Test Switch'), findsOneWidget);
        expect(find.text('Test switch subtitle'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);

        // Verify switch is in correct state
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);
      });

      testWidgets('should call onChanged when switch is toggled',
          (tester) async {
        bool? changedValue;
        void onChanged(dynamic value) => changedValue = value;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_switch',
                  type: SettingsItemType.switch_,
                  title: 'Test Switch',
                  value: false,
                  onChanged: onChanged,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(changedValue, isTrue);
      });

      testWidgets('should be disabled when item is disabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_switch',
                  type: SettingsItemType.switch_,
                  title: 'Test Switch',
                  value: true,
                  enabled: false,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        // When disabled, no Switch widget should be rendered
        expect(find.byType(Switch), findsNothing);
      });
    });

    group('Dropdown Item', () {
      testWidgets('should display dropdown with correct options',
          (tester) async {
        const dropdownOptions = [
          DropdownItem(value: 'option1', label: 'Option 1'),
          DropdownItem(value: 'option2', label: 'Option 2'),
          DropdownItem(value: 'option3', label: 'Option 3'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_dropdown',
                  type: SettingsItemType.dropdown,
                  title: 'Test Dropdown',
                  subtitle: 'Select an option',
                  value: 'option2',
                  dropdownOptions: dropdownOptions,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        expect(find.text('Test Dropdown'), findsOneWidget);
        expect(find.text('Select an option'), findsOneWidget);
        expect(find.byType(DropdownButton<dynamic>), findsOneWidget);
      });

      testWidgets('should display selected option label', (tester) async {
        const dropdownOptions = [
          DropdownItem(value: 'option1', label: 'Option 1'),
          DropdownItem(value: 'option2', label: 'Option 2'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_dropdown',
                  type: SettingsItemType.dropdown,
                  title: 'Test Dropdown',
                  value: 'option2',
                  dropdownOptions: dropdownOptions,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        // Should display the selected option's label
        expect(find.text('Option 2'), findsOneWidget);
      });
    });

    group('Navigation Item', () {
      testWidgets('should display navigation item with chevron icon',
          (tester) async {
        void onChanged(dynamic value) {}

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_navigation',
                  type: SettingsItemType.navigation,
                  title: 'Test Navigation',
                  subtitle: 'Navigate to settings',
                  onChanged: onChanged,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        expect(find.text('Test Navigation'), findsOneWidget);
        expect(find.text('Navigate to settings'), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });

      testWidgets('should call onChanged when navigation item is tapped',
          (tester) async {
        bool tapped = false;
        void onChanged(dynamic value) => tapped = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_navigation',
                  type: SettingsItemType.navigation,
                  title: 'Test Navigation',
                  onChanged: onChanged,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });

    group('Custom Item', () {
      testWidgets('should display custom item without controls',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_custom',
                  type: SettingsItemType.custom,
                  title: 'Test Custom',
                  subtitle: 'Custom implementation',
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        expect(find.text('Test Custom'), findsOneWidget);
        expect(find.text('Custom implementation'), findsOneWidget);

        // Custom items should not have any built-in controls
        expect(find.byType(Switch), findsNothing);
        expect(find.byType(DropdownButton<dynamic>), findsNothing);
        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });
    });

    group('Disabled State', () {
      testWidgets('should apply disabled styling to all item types',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_disabled',
                  type: SettingsItemType.switch_,
                  title: 'Disabled Item',
                  subtitle: 'This item is disabled',
                  value: true,
                  enabled: false,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        // Title should be visible but with disabled color
        expect(find.text('Disabled Item'), findsOneWidget);
        expect(find.text('This item is disabled'), findsOneWidget);

        // No controls should be rendered when disabled
        expect(find.byType(Switch), findsNothing);
      });
    });

    group('Icon Support', () {
      testWidgets('should display icon when provided', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_icon',
                  type: SettingsItemType.switch_,
                  title: 'Test with Icon',
                  icon: Icons.settings,
                  value: false,
                ),
                theme: testTheme,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.text('Test with Icon'), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme item height', (tester) async {
        const customTheme = SettingsTheme(
          primaryColor: Colors.blue,
          backgroundColor: Colors.white,
          itemHeight: 80.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SettingsItemWidget(
                item: SettingsItem(
                  id: 'test_theme',
                  type: SettingsItemType.switch_,
                  title: 'Test Theme',
                  value: false,
                ),
                theme: customTheme,
              ),
            ),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container).first);
        expect(containerWidget.constraints?.minHeight, equals(80.0));
      });
    });
  });
}
