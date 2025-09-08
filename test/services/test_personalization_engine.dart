import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_setting_ui/src/services/personalization_engine.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalizationEngine Tests', () {
    late MockSharedPreferences mockPrefs;
    late PersonalizationEngine engine;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      engine = PersonalizationEngine(mockPrefs);
    });

    test('should update user profile with interaction', () async {
      // Arrange
      const settingId = 'theme_setting';
      const value = 'dark';
      final timestamp = DateTime.now();

      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await engine.updateUserProfile(settingId, value, timestamp);

      // Assert
      verify(() => mockPrefs.setString(any(), any())).called(1);
    });

    test('should get recommendations', () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final recommendations = await engine.getRecommendations();

      // Assert
      expect(recommendations, isEmpty);
    });

    test('should apply recommendation', () async {
      // Arrange
      const recommendationId = 'test_rec';
      const settingId = 'theme_setting';
      const value = 'dark';

      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // First update to create profile
      await engine.updateUserProfile(settingId, value, DateTime.now());

      // Mock the profile loading
      when(() => mockPrefs.getString(any())).thenReturn(
          '{"interactions":[],"recommendations":[{"id":"test_rec","settingId":"theme_setting","recommendedValue":"dark","reason":"Test recommendation","confidence":0.8,"type":"preference","appliedCount":0,"createdAt":"2025-09-08T00:00:00.000","lastApplied":null}],"createdAt":"2025-09-08T00:00:00.000","lastUpdated":"2025-09-08T00:00:00.000"}');

      // Act
      await engine.applyRecommendation(recommendationId);

      // Assert
      verify(() => mockPrefs.setString(any(), any())).called(greaterThan(1));
    });

    test('should get profile insights', () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final insights = await engine.getProfileInsights();

      // Assert
      expect(insights, isNotNull);
      expect(insights.totalInteractions, equals(0));
      expect(insights.favoriteSettings, isEmpty);
      expect(insights.usagePatterns, isEmpty);
      expect(insights.preferences, isEmpty);
    });

    test('should handle profile with interactions', () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // First update to create profile
      await engine.updateUserProfile('theme_setting', 'dark', DateTime.now());

      // Mock profile with interactions
      when(() => mockPrefs.getString(any())).thenReturn(
          '{"interactions":[{"settingId":"theme_setting","value":"dark","timestamp":"2025-09-08T10:00:00.000","context":{"timeContext":"morning","dayOfWeek":1,"isWeekend":false,"timestamp":"2025-09-08T10:00:00.000"}}],"recommendations":[],"createdAt":"2025-09-08T00:00:00.000","lastUpdated":"2025-09-08T00:00:00.000"}');

      // Act
      final insights = await engine.getProfileInsights();

      // Assert
      expect(insights.totalInteractions, equals(1));
      expect(insights.favoriteSettings.containsKey('theme_setting'), isTrue);
    });
  });
}
