import 'package:flutter/material.dart';

/// Configuration for theme transition animations.
class AnimationConfig {
  /// Duration of the animation.
  final Duration duration;

  /// Animation curve to use.
  final Curve curve;

  /// Whether animations are enabled.
  final bool enabled;

  /// Creates a new AnimationConfig.
  const AnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.enabled = true,
  });

  /// Creates an AnimationConfig from a JSON map.
  factory AnimationConfig.fromJson(Map<String, dynamic> json) {
    return AnimationConfig(
      duration: Duration(milliseconds: json['durationMs'] ?? 300),
      curve: _curveFromString(json['curve'] ?? 'easeInOut'),
      enabled: json['enabled'] ?? true,
    );
  }

  /// Converts the AnimationConfig to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'durationMs': duration.inMilliseconds,
      'curve': _curveToString(curve),
      'enabled': enabled,
    };
  }

  /// Creates a copy of this AnimationConfig with the given fields replaced.
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    bool? enabled,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Predefined animation configurations.
  static const AnimationConfig instant = AnimationConfig(
    duration: Duration.zero,
    curve: Curves.linear,
    enabled: false,
  );

  static const AnimationConfig fast = AnimationConfig(
    duration: Duration(milliseconds: 150),
    curve: Curves.easeOut,
    enabled: true,
  );

  static const AnimationConfig normal = AnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    enabled: true,
  );

  static const AnimationConfig slow = AnimationConfig(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    enabled: true,
  );

  static const AnimationConfig smooth = AnimationConfig(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeInOutCubic,
    enabled: true,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimationConfig &&
        other.duration == duration &&
        other.curve == curve &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(duration, curve, enabled);

  @override
  String toString() {
    return 'AnimationConfig(duration: $duration, curve: $curve, enabled: $enabled)';
  }

  /// Converts a curve to its string representation.
  static String _curveToString(Curve curve) {
    if (curve == Curves.linear) return 'linear';
    if (curve == Curves.ease) return 'ease';
    if (curve == Curves.easeIn) return 'easeIn';
    if (curve == Curves.easeOut) return 'easeOut';
    if (curve == Curves.easeInOut) return 'easeInOut';
    if (curve == Curves.easeInOutCubic) return 'easeInOutCubic';
    if (curve == Curves.easeInOutSine) return 'easeInOutSine';
    if (curve == Curves.easeInOutQuad) return 'easeInOutQuad';
    if (curve == Curves.easeInOutQuart) return 'easeInOutQuart';
    if (curve == Curves.easeInOutQuint) return 'easeInOutQuint';
    if (curve == Curves.easeInCubic) return 'easeInCubic';
    if (curve == Curves.easeOutCubic) return 'easeOutCubic';
    if (curve == Curves.easeInOutCirc) return 'easeInOutCirc';
    if (curve == Curves.easeOutCirc) return 'easeOutCirc';
    if (curve == Curves.bounceOut) return 'bounceOut';
    if (curve == Curves.elasticOut) return 'elasticOut';
    return 'easeInOut'; // Default
  }

  /// Converts a string to its corresponding curve.
  static Curve _curveFromString(String curveString) {
    switch (curveString) {
      case 'linear':
        return Curves.linear;
      case 'ease':
        return Curves.ease;
      case 'easeIn':
        return Curves.easeIn;
      case 'easeOut':
        return Curves.easeOut;
      case 'easeInOut':
        return Curves.easeInOut;
      case 'easeInOutCubic':
        return Curves.easeInOutCubic;
      case 'easeInOutSine':
        return Curves.easeInOutSine;
      case 'easeInOutQuad':
        return Curves.easeInOutQuad;
      case 'easeInOutQuart':
        return Curves.easeInOutQuart;
      case 'easeInOutQuint':
        return Curves.easeInOutQuint;
      case 'easeInCubic':
        return Curves.easeInCubic;
      case 'easeOutCubic':
        return Curves.easeOutCubic;
      case 'easeInOutCirc':
        return Curves.easeInOutCirc;
      case 'easeOutCirc':
        return Curves.easeOutCirc;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'elasticOut':
        return Curves.elasticOut;
      default:
        return Curves.easeInOut;
    }
  }
}
