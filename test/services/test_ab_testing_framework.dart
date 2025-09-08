import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_setting_ui/src/services/ab_testing_framework.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ABTestingFramework Tests', () {
    late MockSharedPreferences mockPrefs;
    late ABTestingFramework framework;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      framework = ABTestingFramework(mockPrefs);
    });

    test('should register experiment', () async {
      // Arrange
      final experiment = Experiment(
        id: 'test_experiment',
        name: 'Test Experiment',
        description: 'A test experiment',
        variants: [
          Variant(
            id: 'variant_a',
            name: 'Variant A',
            description: 'First variant',
            trafficAllocation: 0.5,
          ),
          Variant(
            id: 'variant_b',
            name: 'Variant B',
            description: 'Second variant',
            trafficAllocation: 0.5,
          ),
        ],
        conversionEvents: ['click', 'purchase'],
        startDate: DateTime.now(),
      );

      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await framework.registerExperiment(experiment);

      // Assert
      verify(() => mockPrefs.setString(any(), any())).called(1);
    });

    test('should get user variant', () async {
      // Arrange
      final experiment = Experiment(
        id: 'test_experiment',
        name: 'Test Experiment',
        description: 'A test experiment',
        variants: [
          Variant(
            id: 'variant_a',
            name: 'Variant A',
            description: 'First variant',
            trafficAllocation: 1.0, // 100% to ensure deterministic result
          ),
        ],
        conversionEvents: ['click'],
        startDate: DateTime.now(),
      );

      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockPrefs.getStringList(any())).thenReturn(null);

      await framework.registerExperiment(experiment);

      // Act
      final variant = await framework.getUserVariant('test_experiment');

      // Assert
      expect(variant, isNotNull);
      expect(variant, equals('variant_a'));
    });

    test('should return null for non-existent experiment', () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final variant = await framework.getUserVariant('non_existent');

      // Assert
      expect(variant, isNull);
    });

    test('should record event', () async {
      // Arrange
      when(() => mockPrefs.getStringList(any())).thenReturn(null);
      when(() => mockPrefs.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await framework
          .recordEvent('test_experiment', 'click', {'button': 'primary'});

      // Assert
      verify(() => mockPrefs.setStringList(any(), any())).called(1);
    });

    test('should get experiment results', () async {
      // Arrange
      final experiment = Experiment(
        id: 'test_experiment',
        name: 'Test Experiment',
        description: 'A test experiment',
        variants: [
          Variant(
            id: 'variant_a',
            name: 'Variant A',
            description: 'First variant',
            trafficAllocation: 1.0,
          ),
        ],
        conversionEvents: ['click'],
        startDate: DateTime.now(),
      );

      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockPrefs.getStringList(any())).thenReturn([]);

      await framework.registerExperiment(experiment);

      // Act
      final results = await framework.getExperimentResults('test_experiment');

      // Assert
      expect(results, isNotNull);
      expect(results!.experimentId, equals('test_experiment'));
      expect(results.variantResults.length, equals(1));
    });

    test('should return null results for non-existent experiment', () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final results = await framework.getExperimentResults('non_existent');

      // Assert
      expect(results, isNull);
    });
  });
}
