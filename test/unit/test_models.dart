import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/settings_screen.dart';
import 'package:modern_setting_ui/src/models/settings_section.dart';
import 'package:modern_setting_ui/src/models/settings_item.dart';
import 'package:modern_setting_ui/src/themes/settings_theme.dart';
import 'package:modern_setting_ui/src/models/user_preference.dart';

void main() {
  group('SettingsScreen Model Tests', () {
    test('creates SettingsScreen with required fields', () {
      final sections = [
        SettingsSection(
          title: 'Test Section',
          items: [
            SettingsItem(
              id: 'test_item',
              type: SettingsItemType.switch_,
              title: 'Test Item',
            ),
          ],
        ),
      ];

      final screen = SettingsScreen(
        title: 'Test Screen',
        sections: sections,
      );

      expect(screen.title, 'Test Screen');
      expect(screen.sections.length, 1);
      expect(screen.theme, isNull);
    });

    test('throws assertion error with empty sections', () {
      expect(
        () => SettingsScreen(
          title: 'Test Screen',
          sections: [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('SettingsSection Model Tests', () {
    test('creates SettingsSection with required fields', () {
      final items = [
        SettingsItem(
          id: 'test_item',
          type: SettingsItemType.switch_,
          title: 'Test Item',
        ),
      ];

      final section = SettingsSection(
        title: 'Test Section',
        items: items,
      );

      expect(section.title, 'Test Section');
      expect(section.items.length, 1);
      expect(section.expanded, isTrue);
      expect(section.icon, isNull);
    });

    test('throws assertion error with empty title', () {
      expect(
        () => SettingsSection(
          title: '',
          items: [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error with empty items', () {
      expect(
        () => SettingsSection(
          title: 'Test Section',
          items: [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('SettingsItem Model Tests', () {
    test('creates SettingsItem with required fields', () {
      final item = SettingsItem(
        id: 'test_item',
        type: SettingsItemType.switch_,
        title: 'Test Item',
      );

      expect(item.id, 'test_item');
      expect(item.type, SettingsItemType.switch_);
      expect(item.title, 'Test Item');
      expect(item.enabled, isTrue);
      expect(item.onChanged, isNull);
    });

    test('throws assertion error with empty id', () {
      expect(
        () => SettingsItem(
          id: '',
          type: SettingsItemType.switch_,
          title: 'Test Item',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error with empty title', () {
      expect(
        () => SettingsItem(
          id: 'test_item',
          type: SettingsItemType.switch_,
          title: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('SettingsTheme Model Tests', () {
    test('creates SettingsTheme with all null fields', () {
      const theme = SettingsTheme();

      expect(theme.primaryColor, isNull);
      expect(theme.backgroundColor, isNull);
      expect(theme.titleStyle, isNull);
      expect(theme.subtitleStyle, isNull);
      expect(theme.iconTheme, isNull);
      expect(theme.itemHeight, isNull);
    });

    test('creates SettingsTheme with custom values', () {
      const theme = SettingsTheme(
        primaryColor: Colors.blue,
        itemHeight: 60.0,
      );

      expect(theme.primaryColor, Colors.blue);
      expect(theme.itemHeight, 60.0);
    });
  });

  group('UserPreference Model Tests', () {
    test('creates UserPreference with required fields', () {
      final preference = UserPreference(
        key: 'test_key',
        value: 'test_value',
        type: PreferenceType.string,
      );

      expect(preference.key, 'test_key');
      expect(preference.value, 'test_value');
      expect(preference.type, PreferenceType.string);
    });

    test('throws assertion error with empty key', () {
      expect(
        () => UserPreference(
          key: '',
          value: 'test_value',
          type: PreferenceType.string,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('PreferenceType Enum Tests', () {
    test('has all expected values', () {
      expect(PreferenceType.boolean, isNotNull);
      expect(PreferenceType.string, isNotNull);
      expect(PreferenceType.integer, isNotNull);
      expect(PreferenceType.double, isNotNull);
      expect(PreferenceType.stringList, isNotNull);
    });
  });

  group('SettingsItemType Enum Tests', () {
    test('has all expected values', () {
      expect(SettingsItemType.switch_, isNotNull);
      expect(SettingsItemType.dropdown, isNotNull);
      expect(SettingsItemType.navigation, isNotNull);
      expect(SettingsItemType.custom, isNotNull);
    });
  });
}
