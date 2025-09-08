import 'package:flutter/material.dart';

/// Customization options for the appearance of settings components.
class SettingsTheme {
  /// Primary color for switches and highlights.
  final Color? primaryColor;

  /// Background color for list items.
  final Color? backgroundColor;

  /// Text style for titles.
  final TextStyle? titleStyle;

  /// Text style for subtitles.
  final TextStyle? subtitleStyle;

  /// Theme for icons.
  final IconThemeData? iconTheme;

  /// Height of list items.
  final double? itemHeight;

  /// Creates a new SettingsTheme.
  const SettingsTheme({
    this.primaryColor,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconTheme,
    this.itemHeight,
  });
}
