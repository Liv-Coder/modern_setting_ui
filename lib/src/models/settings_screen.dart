import 'settings_section.dart';
import '../themes/settings_theme.dart';

/// Represents the main settings screen containing sections and items.
class SettingsScreen {
  /// The title of the settings screen.
  final String title;

  /// List of settings sections to display.
  final List<SettingsSection> sections;

  /// Optional custom theme for the settings screen.
  final SettingsTheme? theme;

  /// Creates a new SettingsScreen.
  SettingsScreen({
    required this.title,
    required this.sections,
    this.theme,
  }) : assert(sections.isNotEmpty,
            'SettingsScreen must have at least one section');
}
