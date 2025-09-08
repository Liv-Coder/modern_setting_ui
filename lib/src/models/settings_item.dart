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
  }) : assert(id.isNotEmpty, 'SettingsItem id cannot be empty'),
       assert(title.isNotEmpty, 'SettingsItem title cannot be empty');
}
