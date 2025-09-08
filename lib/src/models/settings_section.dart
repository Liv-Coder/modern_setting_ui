import 'package:flutter/material.dart';
import 'settings_item.dart';

/// Represents a section of settings items with a title and optional description.
class SettingsSection {
  /// The title of the section.
  final String title;

  /// Optional description for the section.
  final String? description;

  /// List of settings items in this section.
  final List<SettingsItem> items;

  /// Whether the section is expanded by default.
  final bool expanded;

  /// Optional icon for the section.
  final IconData? icon;

  /// Creates a new SettingsSection.
  SettingsSection({
    required this.title,
    this.description,
    required this.items,
    this.expanded = true,
    this.icon,
  }) : assert(title.isNotEmpty, 'SettingsSection title cannot be empty'),
       assert(items.isNotEmpty, 'SettingsSection must have at least one item');
}
