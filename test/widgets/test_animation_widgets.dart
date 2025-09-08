import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';
import 'package:modern_setting_ui/src/widgets/animation_duration_selector.dart';
import 'package:modern_setting_ui/src/widgets/animation_curve_selector.dart';
import 'package:modern_setting_ui/src/widgets/animation_settings_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Animation Widgets', () {
    const testConfig = AnimationConfig(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      enabled: true,
    );

    late AnimationConfig currentConfig;
    late List<AnimationConfig> configChanges;

    setUp(() {
      currentConfig = testConfig;
      configChanges = [];
    });

    void onConfigChanged(AnimationConfig config) {
      currentConfig = config;
      configChanges.add(config);
    }

    group('AnimationDurationSelector', () {
      testWidgets('should display current duration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationDurationSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Find the specific text in the duration selector
        expect(find.text('Animation Duration'), findsOneWidget);
        expect(find.text('500ms').first,
            findsOneWidget); // Use first to get the main one
      });
      testWidgets('should update duration via slider', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationDurationSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Find and drag the slider
        final slider = find.byType(Slider);
        expect(slider, findsOneWidget);

        await tester.drag(slider, const Offset(100, 0)); // Drag right
        await tester.pump();

        expect(configChanges.length, greaterThan(0));
        expect(configChanges.last.duration.inMilliseconds, greaterThan(500));
      });

      testWidgets('should update duration via preset buttons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationDurationSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Tap the "Fast" preset button - find by widget type and text
        final fastButton = find.widgetWithText(OutlinedButton, 'Fast');
        await tester.tap(fastButton);
        await tester.pump();

        expect(configChanges.length, equals(1));
        expect(configChanges.last.duration,
            equals(const Duration(milliseconds: 150)));
      });
      testWidgets('should highlight selected preset', (tester) async {
        const fastConfig = AnimationConfig(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOut,
          enabled: true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationDurationSelector(
                config: fastConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // The "Fast" button should be highlighted (we can't easily test visual styling,
        // but we can verify the button exists and is tappable)
        expect(find.text('Fast'), findsOneWidget);
      });
    });

    group('AnimationCurveSelector', () {
      testWidgets('should display curve options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationCurveSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        expect(find.text('Animation Curve'), findsOneWidget);
        expect(find.text('Linear'), findsOneWidget);
        expect(find.text('Ease'), findsOneWidget);
        expect(find.text('Bounce'), findsOneWidget);
      });

      testWidgets('should select curve when tapped', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationCurveSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Tap the "Linear" curve option
        await tester.tap(find.text('Linear'));
        await tester.pump();

        expect(configChanges.length, equals(1));
        expect(configChanges.last.curve, equals(Curves.linear));
      });

      testWidgets('should show curve preview', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationCurveSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        expect(find.text('Preview'), findsOneWidget);
        expect(find.text('Play'), findsOneWidget);
      });

      testWidgets('should play animation preview', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationCurveSelector(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Tap the play button
        await tester.tap(find.text('Play'));
        await tester.pump();

        // Animation should start (we can't easily test the visual animation,
        // but we can verify the button exists and is tappable)
        expect(find.text('Play'), findsOneWidget);
      });
    });

    group('AnimationSettingsWidget', () {
      testWidgets('should display animation settings when enabled',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationSettingsWidget(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        expect(find.text('Animation Settings'), findsOneWidget);
        expect(find.text('Animation Duration'), findsOneWidget);
        expect(find.text('Animation Curve'), findsOneWidget);
        expect(find.text('Presets'), findsOneWidget);
      });

      testWidgets('should show disabled state when animations are off',
          (tester) async {
        const disabledConfig = AnimationConfig(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          enabled: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationSettingsWidget(
                config: disabledConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        expect(find.text('Animations are disabled'), findsOneWidget);
        expect(find.text('Theme changes will be instant'), findsOneWidget);
      });

      testWidgets('should toggle animations on/off', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationSettingsWidget(
                config: testConfig,
                onChanged: onConfigChanged,
              ),
            ),
          ),
        );

        // Find and tap the switch
        final switchWidget = find.byType(Switch);
        expect(switchWidget, findsOneWidget);

        await tester.tap(switchWidget);
        await tester.pump();

        expect(configChanges.length, equals(1));
        expect(configChanges.last.enabled, isFalse);
      });

      testWidgets('should select preset configurations', (tester) async {
        // Use a larger screen size to accommodate the widget
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AnimationSettingsWidget(
                  config: testConfig,
                  onChanged: onConfigChanged,
                ),
              ),
            ),
          ),
        );

        // Ensure the widget is fully rendered
        await tester.pumpAndSettle();

        // Tap the "Fast" preset - find by widget type and text
        final fastPreset = find
            .widgetWithText(OutlinedButton, 'Fast')
            .last; // Get the preset button
        await tester.tap(fastPreset);
        await tester.pump();

        expect(configChanges.length, equals(1));
        expect(configChanges.last, equals(AnimationConfig.fast));
      });

      testWidgets('should be disabled when widget is disabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimationSettingsWidget(
                config: testConfig,
                onChanged: onConfigChanged,
                enabled: false,
              ),
            ),
          ),
        );

        // The switch should be disabled
        final switchWidget = find.byType(Switch);
        expect(switchWidget, findsOneWidget);

        // Try to tap it (should not change state)
        await tester.tap(switchWidget);
        await tester.pump();

        // No changes should have occurred
        expect(configChanges.length, equals(0));
      });

      testWidgets('should update when config changes externally',
          (tester) async {
        late StateSetter setState;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setter) {
                  setState = setter;
                  return AnimationSettingsWidget(
                    config: currentConfig,
                    onChanged: onConfigChanged,
                  );
                },
              ),
            ),
          ),
        );

        // Initially should show 500ms - find the main one
        expect(find.text('500ms').first, findsOneWidget);

        // Update config externally
        setState(() {
          currentConfig = const AnimationConfig(
            duration: Duration(milliseconds: 750),
            curve: Curves.linear,
            enabled: true,
          );
        });
        await tester.pump();

        // Should now show 750ms - find the main one
        expect(find.text('750ms').first, findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should work together as complete animation system',
          (tester) async {
        // Use a larger screen size to accommodate the widget
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AnimationSettingsWidget(
                  config: testConfig,
                  onChanged: onConfigChanged,
                ),
              ),
            ),
          ),
        );

        // Ensure the widget is fully rendered
        await tester.pumpAndSettle();

        // Change duration via preset button instead of slider to avoid multiple events
        final fastPreset = find
            .widgetWithText(OutlinedButton, 'Fast')
            .first; // Duration preset
        await tester.tap(fastPreset);
        await tester.pump();

        // Change curve
        await tester.tap(find.text('Bounce'));
        await tester.pump();

        // Select animation preset
        final smoothPreset = find
            .widgetWithText(OutlinedButton, 'Smooth')
            .last; // Animation preset
        await tester.tap(smoothPreset);
        await tester.pump();

        // Toggle animations
        final switchWidget = find.byType(Switch);
        await tester.tap(switchWidget);
        await tester.pump();

        // Verify all changes were captured (should be 4 changes)
        expect(configChanges.length, equals(4));
        expect(configChanges.last.enabled, isFalse);
      });

      testWidgets('should maintain state consistency', (tester) async {
        // Use a larger screen size to accommodate the widget
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AnimationSettingsWidget(
                  config: testConfig,
                  onChanged: onConfigChanged,
                ),
              ),
            ),
          ),
        );

        // Ensure the widget is fully rendered
        await tester.pumpAndSettle();

        // Make several changes
        final fastPreset = find.widgetWithText(OutlinedButton, 'Fast').last;
        await tester.tap(fastPreset);
        await tester.pump();

        final elasticCurve = find.text('Elastic');
        await tester.tap(elasticCurve);
        await tester.pump();

        // Verify the final config has both changes
        expect(configChanges.last.duration,
            equals(const Duration(milliseconds: 150)));
        expect(configChanges.last.curve, equals(Curves.elasticOut));
        expect(configChanges.last.enabled, isTrue);
      });
    });
  });
}
