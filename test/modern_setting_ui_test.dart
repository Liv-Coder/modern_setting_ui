import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  test('package can be imported', () {
    // Test that the package can be imported without errors
    expect(true, isTrue);
  });

  test('SettingsItem can be created', () {
    final item = SettingsItem(
      id: 'test_item',
      type: SettingsItemType.switch_,
      title: 'Test Item',
      value: true,
      onChanged: (value) {},
    );

    expect(item.id, equals('test_item'));
    expect(item.type, equals(SettingsItemType.switch_));
    expect(item.title, equals('Test Item'));
    expect(item.value, isTrue);
  });

  test('SettingsSection can be created', () {
    final section = SettingsSection(
      title: 'Test Section',
      items: [
        SettingsItem(
          id: 'item1',
          type: SettingsItemType.switch_,
          title: 'Item 1',
          value: false,
          onChanged: (value) {},
        ),
      ],
    );

    expect(section.title, equals('Test Section'));
    expect(section.items.length, equals(1));
  });

  test('SettingsTheme can be created', () {
    final theme = SettingsTheme(
      primaryColor: Colors.blue,
      backgroundColor: Colors.white,
    );

    expect(theme.primaryColor, equals(Colors.blue));
    expect(theme.backgroundColor, equals(Colors.white));
  });
}
