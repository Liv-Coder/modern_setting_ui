import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/brand_color_scheme.dart';

void main() {
  group('BrandColorScheme', () {
    const testPrimary = Color(0xFF2196F3);
    const testSecondary = Color(0xFF64B5F6);
    const testAccent = Color(0xFFFF9800);
    const testSuccess = Color(0xFF4CAF50);
    const testWarning = Color(0xFFFFC107);
    const testError = Color(0xFFF44336);
    const testInfo = Color(0xFF2196F3);
    const testBackground = Color(0xFFFFFFFF);
    const testSurface = Color(0xFFF5F5F5);
    const testOnPrimary = Color(0xFFFFFFFF);
    const testOnSecondary = Color(0xFF000000);
    const testOnBackground = Color(0xFF000000);
    const testOnSurface = Color(0xFF000000);
    const testBrandName = 'Test Brand';
    const testLogoUrl = 'https://example.com/logo.png';

    late BrandColorScheme brandColorScheme;

    setUp(() {
      brandColorScheme = const BrandColorScheme(
        primary: testPrimary,
        secondary: testSecondary,
        accent: testAccent,
        success: testSuccess,
        warning: testWarning,
        error: testError,
        info: testInfo,
        background: testBackground,
        surface: testSurface,
        onPrimary: testOnPrimary,
        onSecondary: testOnSecondary,
        onBackground: testOnBackground,
        onSurface: testOnSurface,
        brandName: testBrandName,
        logoUrl: testLogoUrl,
      );
    });

    test('should create BrandColorScheme with required parameters', () {
      const minimalScheme = BrandColorScheme(
        primary: testPrimary,
        secondary: testSecondary,
      );

      expect(minimalScheme.primary, testPrimary);
      expect(minimalScheme.secondary, testSecondary);
      expect(minimalScheme.accent, isNull);
      expect(minimalScheme.brandName, isNull);
    });

    test('should create BrandColorScheme with all parameters', () {
      expect(brandColorScheme.primary, testPrimary);
      expect(brandColorScheme.secondary, testSecondary);
      expect(brandColorScheme.accent, testAccent);
      expect(brandColorScheme.success, testSuccess);
      expect(brandColorScheme.warning, testWarning);
      expect(brandColorScheme.error, testError);
      expect(brandColorScheme.info, testInfo);
      expect(brandColorScheme.background, testBackground);
      expect(brandColorScheme.surface, testSurface);
      expect(brandColorScheme.onPrimary, testOnPrimary);
      expect(brandColorScheme.onSecondary, testOnSecondary);
      expect(brandColorScheme.onBackground, testOnBackground);
      expect(brandColorScheme.onSurface, testOnSurface);
      expect(brandColorScheme.brandName, testBrandName);
      expect(brandColorScheme.logoUrl, testLogoUrl);
    });

    test('should serialize to JSON correctly', () {
      final json = brandColorScheme.toJson();

      expect(json['primary'], testPrimary.toARGB32());
      expect(json['secondary'], testSecondary.toARGB32());
      expect(json['accent'], testAccent.toARGB32());
      expect(json['success'], testSuccess.toARGB32());
      expect(json['warning'], testWarning.toARGB32());
      expect(json['error'], testError.toARGB32());
      expect(json['info'], testInfo.toARGB32());
      expect(json['background'], testBackground.toARGB32());
      expect(json['surface'], testSurface.toARGB32());
      expect(json['onPrimary'], testOnPrimary.toARGB32());
      expect(json['onSecondary'], testOnSecondary.toARGB32());
      expect(json['onBackground'], testOnBackground.toARGB32());
      expect(json['onSurface'], testOnSurface.toARGB32());
      expect(json['brandName'], testBrandName);
      expect(json['logoUrl'], testLogoUrl);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'primary': testPrimary.toARGB32(),
        'secondary': testSecondary.toARGB32(),
        'accent': testAccent.toARGB32(),
        'success': testSuccess.toARGB32(),
        'warning': testWarning.toARGB32(),
        'error': testError.toARGB32(),
        'info': testInfo.toARGB32(),
        'background': testBackground.toARGB32(),
        'surface': testSurface.toARGB32(),
        'onPrimary': testOnPrimary.toARGB32(),
        'onSecondary': testOnSecondary.toARGB32(),
        'onBackground': testOnBackground.toARGB32(),
        'onSurface': testOnSurface.toARGB32(),
        'brandName': testBrandName,
        'logoUrl': testLogoUrl,
      };

      final deserialized = BrandColorScheme.fromJson(json);

      expect(deserialized.primary, testPrimary);
      expect(deserialized.secondary, testSecondary);
      expect(deserialized.accent, testAccent);
      expect(deserialized.success, testSuccess);
      expect(deserialized.warning, testWarning);
      expect(deserialized.error, testError);
      expect(deserialized.info, testInfo);
      expect(deserialized.background, testBackground);
      expect(deserialized.surface, testSurface);
      expect(deserialized.onPrimary, testOnPrimary);
      expect(deserialized.onSecondary, testOnSecondary);
      expect(deserialized.onBackground, testOnBackground);
      expect(deserialized.onSurface, testOnSurface);
      expect(deserialized.brandName, testBrandName);
      expect(deserialized.logoUrl, testLogoUrl);
    });

    test('should handle null values in JSON deserialization', () {
      final json = {
        'primary': testPrimary.toARGB32(),
        'secondary': testSecondary.toARGB32(),
        // All optional fields are null
      };

      final deserialized = BrandColorScheme.fromJson(json);

      expect(deserialized.primary, testPrimary);
      expect(deserialized.secondary, testSecondary);
      expect(deserialized.accent, isNull);
      expect(deserialized.success, isNull);
      expect(deserialized.warning, isNull);
      expect(deserialized.error, isNull);
      expect(deserialized.info, isNull);
      expect(deserialized.background, isNull);
      expect(deserialized.surface, isNull);
      expect(deserialized.onPrimary, isNull);
      expect(deserialized.onSecondary, isNull);
      expect(deserialized.onBackground, isNull);
      expect(deserialized.onSurface, isNull);
      expect(deserialized.brandName, isNull);
      expect(deserialized.logoUrl, isNull);
    });

    test('should create copy with modified fields', () {
      const newPrimary = Color(0xFF9C27B0);
      const newBrandName = 'New Brand';

      final copied = brandColorScheme.copyWith(
        primary: newPrimary,
        brandName: newBrandName,
      );

      expect(copied.primary, newPrimary);
      expect(copied.brandName, newBrandName);
      expect(copied.secondary, testSecondary); // Unchanged
      expect(copied.accent, testAccent); // Unchanged
    });

    test('should convert to ColorScheme for light theme', () {
      final colorScheme =
          brandColorScheme.toColorScheme(brightness: Brightness.light);

      expect(colorScheme.brightness, Brightness.light);
      expect(colorScheme.primary, testPrimary);
      expect(colorScheme.secondary, testSecondary);
      expect(colorScheme.surface, testBackground);
      expect(colorScheme.surface, testSurface);
      expect(colorScheme.onPrimary, testOnPrimary);
      expect(colorScheme.onSecondary, testOnSecondary);
      expect(colorScheme.onSurface, testOnBackground);
      expect(colorScheme.onSurface, testOnSurface);
    });

    test('should convert to ColorScheme for dark theme', () {
      final colorScheme =
          brandColorScheme.toColorScheme(brightness: Brightness.dark);

      expect(colorScheme.brightness, Brightness.dark);
      expect(colorScheme.primary, testPrimary);
      expect(colorScheme.secondary, testSecondary);
      // Since onPrimary and onSecondary are set in the test scheme, they use those values
      expect(colorScheme.onPrimary,
          testOnPrimary); // Uses the set value, not default
      expect(colorScheme.onSecondary,
          testOnSecondary); // Uses the set value, not default
    });

    test('should be valid when required colors are present', () {
      expect(brandColorScheme.isValid, isTrue);
    });

    test('should implement equality correctly', () {
      const identicalScheme = BrandColorScheme(
        primary: testPrimary,
        secondary: testSecondary,
        accent: testAccent,
        success: testSuccess,
        warning: testWarning,
        error: testError,
        info: testInfo,
        background: testBackground,
        surface: testSurface,
        onPrimary: testOnPrimary,
        onSecondary: testOnSecondary,
        onBackground: testOnBackground,
        onSurface: testOnSurface,
        brandName: testBrandName,
        logoUrl: testLogoUrl,
      );

      expect(brandColorScheme, equals(identicalScheme));
      expect(
          brandColorScheme,
          isNot(equals(BrandColorScheme(
              primary: testPrimary, secondary: Color(0xFFFF0000)))));
    });

    test('should have consistent hashCode', () {
      const identicalScheme = BrandColorScheme(
        primary: testPrimary,
        secondary: testSecondary,
        accent: testAccent,
        success: testSuccess,
        warning: testWarning,
        error: testError,
        info: testInfo,
        background: testBackground,
        surface: testSurface,
        onPrimary: testOnPrimary,
        onSecondary: testOnSecondary,
        onBackground: testOnBackground,
        onSurface: testOnSurface,
        brandName: testBrandName,
        logoUrl: testLogoUrl,
      );

      expect(brandColorScheme.hashCode, equals(identicalScheme.hashCode));
    });

    test('should have meaningful toString output', () {
      final string = brandColorScheme.toString();

      expect(string, contains('BrandColorScheme'));
      expect(string, contains(testBrandName));
      expect(string, contains(testPrimary.toString()));
      expect(string, contains(testSecondary.toString()));
    });
  });
}
