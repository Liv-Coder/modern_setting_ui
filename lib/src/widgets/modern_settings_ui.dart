import 'package:flutter/material.dart';
import '../models/settings_section.dart';
import '../models/settings_theme.dart';
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

  /// Whether to use a scrollable container or just a column.
  final bool scrollable;

  /// Creates a ModernSettingsUI widget.
  const ModernSettingsUI({
    super.key,
    required this.sections,
    this.theme,
    this.physics,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const SettingsTheme();

    final content = Theme(
      data: Theme.of(context).copyWith(
        primaryColor: effectiveTheme.primaryColor,
        scaffoldBackgroundColor: effectiveTheme.backgroundColor,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          children: sections.map((section) {
            return SettingsSectionWidget(
              section: section,
              theme: effectiveTheme,
            );
          }).toList(),
        ),
      ),
    );

    if (scrollable) {
      return ListView(
        physics: physics,
        children: [content],
      );
    } else {
      return content;
    }
  }
}
