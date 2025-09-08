import 'package:flutter/material.dart';

/// Types of settings items available.
enum SettingsItemType {
  /// A toggle switch.
  switch_,

  /// A dropdown selection.
  dropdown,

  /// A navigation item.
  navigation,

  /// A custom item.
  custom,
}

/// Represents a dropdown item option.
class DropdownItem<T> {
  /// The value of the dropdown item.
  final T value;

  /// The display label for the dropdown item.
  final String label;

  /// Optional icon for the dropdown item.
  final IconData? icon;

  /// Creates a new DropdownItem.
  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Represents an individual setting item in a settings section.
class SettingsItem {
  /// Unique identifier for the item.
  final String id;

  /// Type of the settings item.
  final SettingsItemType type;

  /// Display title.
  final String title;

  /// Optional subtitle or description.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// Current value of the item.
  final dynamic value;

  /// Whether the item is enabled for interaction.
  final bool enabled;

  /// Callback when the value changes.
  final ValueChanged<dynamic>? onChanged;

  /// Options for dropdown items (only used when type is dropdown).
  final List<DropdownItem<dynamic>>? dropdownOptions;

  /// Creates a new SettingsItem.
  SettingsItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.enabled = true,
    this.onChanged,
    this.dropdownOptions,
  })  : assert(id.isNotEmpty, 'SettingsItem id cannot be empty'),
        assert(title.isNotEmpty, 'SettingsItem title cannot be empty'),
        assert(type != SettingsItemType.dropdown || dropdownOptions != null,
            'dropdownOptions must be provided for dropdown items');
}
