import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';

void main() {
  group('AnimationConfig', () {
    const testDuration = Duration(milliseconds: 500);
    const testCurve = Curves.easeInOutCubic;

    late AnimationConfig config;

    setUp(() {
      config = const AnimationConfig(
        duration: testDuration,
        curve: testCurve,
        enabled: true,
      );
    });

    test('should create AnimationConfig with custom values', () {
      expect(config.duration, testDuration);
      expect(config.curve, testCurve);
      expect(config.enabled, true);
    });

    test('should create AnimationConfig with defaults', () {
      const defaultConfig = AnimationConfig();
      expect(defaultConfig.duration, const Duration(milliseconds: 300));
      expect(defaultConfig.curve, Curves.easeInOut);
      expect(defaultConfig.enabled, true);
    });

    test('should serialize to JSON correctly', () {
      final json = config.toJson();

      expect(json['durationMs'], 500);
      expect(json['curve'], 'easeInOutCubic');
      expect(json['enabled'], true);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'durationMs': 750,
        'curve': 'bounceOut',
        'enabled': false,
      };

      final deserialized = AnimationConfig.fromJson(json);

      expect(deserialized.duration, const Duration(milliseconds: 750));
      expect(deserialized.curve, Curves.bounceOut);
      expect(deserialized.enabled, false);
    });

    test('should handle missing JSON values with defaults', () {
      final json = <String, dynamic>{};

      final deserialized = AnimationConfig.fromJson(json);

      expect(deserialized.duration, const Duration(milliseconds: 300));
      expect(deserialized.curve, Curves.easeInOut);
      expect(deserialized.enabled, true);
    });

    test('should create copy with modified fields', () {
      const newDuration = Duration(milliseconds: 1000);
      const newCurve = Curves.linear;

      final copied = config.copyWith(
        duration: newDuration,
        curve: newCurve,
        enabled: false,
      );

      expect(copied.duration, newDuration);
      expect(copied.curve, newCurve);
      expect(copied.enabled, false);

      // Original should be unchanged
      expect(config.duration, testDuration);
      expect(config.curve, testCurve);
      expect(config.enabled, true);
    });

    test('should copy with null values (no change)', () {
      final copied = config.copyWith();

      expect(copied.duration, testDuration);
      expect(copied.curve, testCurve);
      expect(copied.enabled, true);
    });

    test('should have correct preset configurations', () {
      expect(AnimationConfig.instant.duration, Duration.zero);
      expect(AnimationConfig.instant.curve, Curves.linear);
      expect(AnimationConfig.instant.enabled, false);

      expect(AnimationConfig.fast.duration, const Duration(milliseconds: 150));
      expect(AnimationConfig.fast.curve, Curves.easeOut);
      expect(AnimationConfig.fast.enabled, true);

      expect(
          AnimationConfig.normal.duration, const Duration(milliseconds: 300));
      expect(AnimationConfig.normal.curve, Curves.easeInOut);
      expect(AnimationConfig.normal.enabled, true);

      expect(AnimationConfig.slow.duration, const Duration(milliseconds: 500));
      expect(AnimationConfig.slow.curve, Curves.easeInOut);
      expect(AnimationConfig.slow.enabled, true);

      expect(
          AnimationConfig.smooth.duration, const Duration(milliseconds: 400));
      expect(AnimationConfig.smooth.curve, Curves.easeInOutCubic);
      expect(AnimationConfig.smooth.enabled, true);
    });

    test('should implement equality correctly', () {
      const identicalConfig = AnimationConfig(
        duration: testDuration,
        curve: testCurve,
        enabled: true,
      );

      expect(config, equals(identicalConfig));
      expect(
          config,
          isNot(
              equals(AnimationConfig(duration: Duration(milliseconds: 400)))));
      expect(config, isNot(equals(AnimationConfig(curve: Curves.linear))));
      expect(config, isNot(equals(AnimationConfig(enabled: false))));
    });

    test('should have consistent hashCode', () {
      const identicalConfig = AnimationConfig(
        duration: testDuration,
        curve: testCurve,
        enabled: true,
      );

      expect(config.hashCode, equals(identicalConfig.hashCode));
    });

    test('should have meaningful toString output', () {
      final string = config.toString();

      expect(string, contains('AnimationConfig'));
      expect(string, contains('500'));
      expect(string, contains('true'));
    });
  });
}
