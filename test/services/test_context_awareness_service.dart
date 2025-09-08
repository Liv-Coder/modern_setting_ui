import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_setting_ui/src/services/context_awareness_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContextAwarenessService Tests', () {
    late MockSharedPreferences mockPrefs;
    late ContextAwarenessService service;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      service = ContextAwarenessService(mockPrefs);
    });

    tearDown(() {
      service.dispose();
    });

    test('should record user interaction', () async {
      // Arrange
      const settingId = 'test_setting';
      const value = true;
      final timestamp = DateTime.now();

      when(() => mockPrefs.getStringList(any())).thenReturn(null);
      when(() => mockPrefs.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await service.recordInteraction(settingId, value, timestamp);

      // Assert
      verify(() => mockPrefs.setStringList(any(), any())).called(1);
    });

    test('should get suggestions when no interactions exist', () async {
      // Arrange
      when(() => mockPrefs.getStringList(any())).thenReturn(null);

      // Act
      final suggestions = await service.getSuggestions();

      // Assert
      expect(suggestions, isEmpty);
    });

    test('should handle empty interaction history', () async {
      // Arrange
      when(() => mockPrefs.getStringList(any())).thenReturn([]);

      // Act
      final suggestions = await service.getSuggestions();

      // Assert
      expect(suggestions, isEmpty);
    });
  });
}
