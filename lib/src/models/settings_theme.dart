import 'package:flutter/material.dart';

/// Customization options for the appearance of settings components.
class SettingsTheme {
  /// Brightness of the theme (light or dark).
  final Brightness brightness;

  /// Primary color for switches and highlights.
  final Color primaryColor;

  /// Secondary color for accents.
  final Color secondaryColor;

  /// Background color for list items.
  final Color? backgroundColor;

  /// Surface color for cards and elevated elements.
  final Color? surfaceColor;

  /// Text style for titles.
  final TextStyle? titleStyle;

  /// Text style for subtitles.
  final TextStyle? subtitleStyle;

  /// Theme for icons.
  final IconThemeData? iconTheme;

  /// Height of list items.
  final double? itemHeight;

  /// Border radius for components.
  final double? borderRadius;

  /// Animation duration for theme transitions.
  final Duration? transitionDuration;

  /// Creates a new SettingsTheme.
  const SettingsTheme({
    this.brightness = Brightness.light,
    this.primaryColor = const Color(0xFF2196F3),
    this.secondaryColor = const Color(0xFF64B5F6),
    this.backgroundColor,
    this.surfaceColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconTheme,
    this.itemHeight,
    this.borderRadius,
    this.transitionDuration,
  });

  /// Creates a copy of this SettingsTheme with the given fields replaced.
  SettingsTheme copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    IconThemeData? iconTheme,
    double? itemHeight,
    double? borderRadius,
    Duration? transitionDuration,
  }) {
    return SettingsTheme(
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      itemHeight: itemHeight ?? this.itemHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      transitionDuration: transitionDuration ?? this.transitionDuration,
    );
  }

  /// Converts the SettingsTheme to a JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {
      'brightness': brightness.index,
      'primaryColor': primaryColor.toARGB32(),
      'secondaryColor': secondaryColor.toARGB32(),
      'backgroundColor': backgroundColor?.toARGB32(),
      'surfaceColor': surfaceColor?.toARGB32(),
      'itemHeight': itemHeight,
      'borderRadius': borderRadius,
      'transitionDurationMs': transitionDuration?.inMilliseconds,
    };
  }

  /// Creates a SettingsTheme from a JSON map.
  factory SettingsTheme.fromJson(Map<String, dynamic> json) {
    return SettingsTheme(
      brightness: Brightness.values[json['brightness'] ?? 0],
      primaryColor: Color(json['primaryColor'] ?? 0xFF2196F3),
      secondaryColor: Color(json['secondaryColor'] ?? 0xFF64B5F6),
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'])
          : null,
      surfaceColor:
          json['surfaceColor'] != null ? Color(json['surfaceColor']) : null,
      itemHeight: json['itemHeight']?.toDouble(),
      borderRadius: json['borderRadius']?.toDouble(),
      transitionDuration: json['transitionDurationMs'] != null
          ? Duration(milliseconds: json['transitionDurationMs'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsTheme &&
        other.brightness == brightness &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.backgroundColor == backgroundColor &&
        other.surfaceColor == surfaceColor &&
        other.itemHeight == itemHeight &&
        other.borderRadius == borderRadius &&
        other.transitionDuration == transitionDuration;
  }

  @override
  int get hashCode {
    return Object.hash(
      brightness,
      primaryColor,
      secondaryColor,
      backgroundColor,
      surfaceColor,
      itemHeight,
      borderRadius,
      transitionDuration,
    );
  }
}
