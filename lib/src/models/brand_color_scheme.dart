import 'package:flutter/material.dart';

/// Represents a company's brand color scheme for integration with settings themes.
class BrandColorScheme {
  /// Primary brand color - main brand color used for primary actions and highlights.
  final Color primary;

  /// Secondary brand color - complementary color for secondary elements.
  final Color secondary;

  /// Accent color - used for special highlights and call-to-action elements.
  final Color? accent;

  /// Success color - used for positive actions and confirmations.
  final Color? success;

  /// Warning color - used for cautionary messages and warnings.
  final Color? warning;

  /// Error color - used for error states and destructive actions.
  final Color? error;

  /// Info color - used for informational messages.
  final Color? info;

  /// Background color - main background color for the brand.
  final Color? background;

  /// Surface color - color for elevated surfaces and cards.
  final Color? surface;

  /// Text color - primary text color on brand backgrounds.
  final Color? onPrimary;

  /// Secondary text color - for less prominent text.
  final Color? onSecondary;

  /// Background text color - text color on background.
  final Color? onBackground;

  /// Surface text color - text color on surfaces.
  final Color? onSurface;

  /// Brand name for identification.
  final String? brandName;

  /// Brand logo URL or asset path.
  final String? logoUrl;

  /// Creates a new BrandColorScheme.
  const BrandColorScheme({
    required this.primary,
    required this.secondary,
    this.accent,
    this.success,
    this.warning,
    this.error,
    this.info,
    this.background,
    this.surface,
    this.onPrimary,
    this.onSecondary,
    this.onBackground,
    this.onSurface,
    this.brandName,
    this.logoUrl,
  });

  /// Creates a BrandColorScheme from a JSON map.
  factory BrandColorScheme.fromJson(Map<String, dynamic> json) {
    return BrandColorScheme(
      primary: Color(json['primary'] ?? 0xFF2196F3),
      secondary: Color(json['secondary'] ?? 0xFF64B5F6),
      accent: json['accent'] != null ? Color(json['accent']) : null,
      success: json['success'] != null ? Color(json['success']) : null,
      warning: json['warning'] != null ? Color(json['warning']) : null,
      error: json['error'] != null ? Color(json['error']) : null,
      info: json['info'] != null ? Color(json['info']) : null,
      background: json['background'] != null ? Color(json['background']) : null,
      surface: json['surface'] != null ? Color(json['surface']) : null,
      onPrimary: json['onPrimary'] != null ? Color(json['onPrimary']) : null,
      onSecondary:
          json['onSecondary'] != null ? Color(json['onSecondary']) : null,
      onBackground:
          json['onBackground'] != null ? Color(json['onBackground']) : null,
      onSurface: json['onSurface'] != null ? Color(json['onSurface']) : null,
      brandName: json['brandName'],
      logoUrl: json['logoUrl'],
    );
  }

  /// Converts the BrandColorScheme to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'primary': primary.toARGB32(),
      'secondary': secondary.toARGB32(),
      'accent': accent?.toARGB32(),
      'success': success?.toARGB32(),
      'warning': warning?.toARGB32(),
      'error': error?.toARGB32(),
      'info': info?.toARGB32(),
      'background': background?.toARGB32(),
      'surface': surface?.toARGB32(),
      'onPrimary': onPrimary?.toARGB32(),
      'onSecondary': onSecondary?.toARGB32(),
      'onBackground': onBackground?.toARGB32(),
      'onSurface': onSurface?.toARGB32(),
      'brandName': brandName,
      'logoUrl': logoUrl,
    };
  }

  /// Creates a copy of this BrandColorScheme with the given fields replaced.
  BrandColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? background,
    Color? surface,
    Color? onPrimary,
    Color? onSecondary,
    Color? onBackground,
    Color? onSurface,
    String? brandName,
    String? logoUrl,
  }) {
    return BrandColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      brandName: brandName ?? this.brandName,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  /// Creates a Material ColorScheme from this brand color scheme.
  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary ??
          (brightness == Brightness.light ? Colors.white : Colors.black),
      secondary: secondary,
      onSecondary: onSecondary ??
          (brightness == Brightness.light ? Colors.white : Colors.black),
      error: error ?? Colors.red,
      onError: Colors.white,
      surface: surface ??
          (brightness == Brightness.light
              ? Colors.white
              : Colors.grey.shade100),
      onSurface: onSurface ??
          (brightness == Brightness.light ? Colors.black : Colors.white),
    );
  }

  /// Validates that the brand color scheme has required colors.
  bool get isValid {
    return true; // primary and secondary are always non-null as required parameters
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrandColorScheme &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.accent == accent &&
        other.success == success &&
        other.warning == warning &&
        other.error == error &&
        other.info == info &&
        other.background == background &&
        other.surface == surface &&
        other.onPrimary == onPrimary &&
        other.onSecondary == onSecondary &&
        other.onBackground == onBackground &&
        other.onSurface == onSurface &&
        other.brandName == brandName &&
        other.logoUrl == logoUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      primary,
      secondary,
      accent,
      success,
      warning,
      error,
      info,
      background,
      surface,
      onPrimary,
      onSecondary,
      onBackground,
      onSurface,
      brandName,
      logoUrl,
    );
  }

  @override
  String toString() {
    return 'BrandColorScheme(brandName: $brandName, primary: $primary, secondary: $secondary)';
  }
}
