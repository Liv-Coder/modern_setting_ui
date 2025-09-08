import 'package:flutter/material.dart';
import '../models/settings_section.dart';
import '../themes/settings_theme.dart';
import 'settings_section.dart';

/// Main widget for displaying modern settings screens.
class ModernSettingsUI extends StatelessWidget {
  /// List of settings sections to display.
  final List<SettingsSection> sections;

  /// Optional custom theme for the settings.
  final SettingsTheme? theme;

  /// Scroll physics for the settings list.
  final ScrollPhysics? physics;

  /// Padding around the settings list.
  final EdgeInsets? padding;

  /// Creates a ModernSettingsUI widget.
  const ModernSettingsUI({
    super.key,
    required this.sections,
    this.theme,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const SettingsTheme();

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: effectiveTheme.primaryColor,
        scaffoldBackgroundColor: effectiveTheme.backgroundColor,
      ),
      child: ListView(
        physics: physics,
        padding: padding ?? const EdgeInsets.all(16.0),
        children: sections.map((section) {
          return SettingsSectionWidget(
            section: section,
            theme: effectiveTheme,
          );
        }).toList(),
      ),
    );
  }
}
