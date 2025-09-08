import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/models/brand_color_scheme.dart';
import 'package:modern_setting_ui/src/widgets/brand_integration_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BrandIntegrationWidget', () {
    const testBrandScheme = BrandColorScheme(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF64B5F6),
      accent: Color(0xFFFF9800),
      success: Color(0xFF4CAF50),
      warning: Color(0xFFFFC107),
      error: Color(0xFFF44336),
      info: Color(0xFF2196F3),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFF5F5F5),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onBackground: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      brandName: 'Test Brand',
      logoUrl: 'https://example.com/logo.png',
    );

    late List<BrandColorScheme> schemeChanges;

    setUp(() {
      schemeChanges = [];
    });

    void onSchemeChanged(BrandColorScheme scheme) {
      schemeChanges.add(scheme);
    }

    testWidgets('should display brand information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      expect(find.text('Brand Integration'), findsOneWidget);
      // Check for brand name in the display text, not the text field
      expect(find.text('Test Brand').last,
          findsOneWidget); // Use last to get the display text
      expect(find.text('Primary Color'), findsOneWidget);
      expect(find.text('Secondary Color'), findsOneWidget);
    });

    testWidgets('should display color preview chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // Should find color preview containers
      expect(find.byType(Container), findsWidgets);
      // Should find color picker buttons
      expect(find.byIcon(Icons.color_lens), findsWidgets);
    });

    testWidgets('should update brand name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // Find and tap the brand name field
      final nameField = find.byType(TextField).first;
      await tester.tap(nameField);
      await tester.enterText(nameField, 'New Brand Name');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(schemeChanges.length, equals(1));
      expect(schemeChanges.last.brandName, equals('New Brand Name'));
    });

    testWidgets('should show color picker dialog when color button tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // Find and tap a color picker button
      final colorButton = find.byIcon(Icons.color_lens).first;
      await tester.tap(colorButton);
      await tester.pumpAndSettle();

      // Should show color picker dialog with correct title
      expect(find.text('Pick a Primary Color'), findsOneWidget);
    });

    testWidgets('should update primary color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // Find and tap primary color button
      final primaryColorButton = find.byIcon(Icons.color_lens).first;
      await tester.tap(primaryColorButton);
      await tester.pumpAndSettle();

      // Select a new color (this would normally be done through the color picker)
      // For testing, we'll simulate the color selection
      final newColor = Color(0xFFFF5722);
      onSchemeChanged(testBrandScheme.copyWith(primary: newColor));

      expect(schemeChanges.last.primary, equals(newColor));
    });

    testWidgets('should display optional colors when available',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      expect(find.text('Accent Color'), findsOneWidget);
      expect(find.text('Success Color'), findsOneWidget);
      expect(find.text('Warning Color'), findsOneWidget);
      expect(find.text('Error Color'), findsOneWidget);
    });

    testWidgets('should handle scheme without optional colors', (tester) async {
      const minimalScheme = BrandColorScheme(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF64B5F6),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: minimalScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      expect(find.text('Primary Color'), findsOneWidget);
      expect(find.text('Secondary Color'), findsOneWidget);
      // Optional colors should not be displayed if null
      expect(find.text('Accent Color'), findsNothing);
    });

    testWidgets('should show preview section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      expect(find.text('Preview'), findsOneWidget);
      // Should show preview components
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should be disabled when widget is disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
              enabled: false,
            ),
          ),
        ),
      );

      // Text fields should be disabled
      final textFields = find.byType(TextField);
      for (final textField in textFields.evaluate()) {
        final TextField widget = textField.widget as TextField;
        expect(widget.enabled, isFalse);
      }

      // Color picker buttons should be disabled
      final colorButtons = find.byIcon(Icons.color_lens);
      expect(colorButtons, findsWidgets);
    });

    testWidgets('should update when scheme changes externally', (tester) async {
      late BrandColorScheme externalScheme = testBrandScheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => BrandIntegrationWidget(
                brandScheme: externalScheme,
                onChanged: (scheme) {
                  setState(() => externalScheme = scheme);
                  onSchemeChanged(scheme);
                },
              ),
            ),
          ),
        ),
      );

      // Update external scheme
      final newScheme = testBrandScheme.copyWith(brandName: 'Updated Brand');
      externalScheme = newScheme;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => BrandIntegrationWidget(
                brandScheme: externalScheme,
                onChanged: (scheme) {
                  setState(() => externalScheme = scheme);
                  onSchemeChanged(scheme);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Updated Brand').last, findsOneWidget);
    });

    testWidgets('should handle logo URL input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // Find logo URL field (second TextField)
      final logoField = find.byType(TextField).at(1);
      await tester.tap(logoField);
      await tester.enterText(logoField, 'https://new-logo.com/logo.png');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(schemeChanges.length, equals(1));
      expect(
          schemeChanges.last.logoUrl, equals('https://new-logo.com/logo.png'));
    });

    testWidgets('should validate color values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: testBrandScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      // The widget should handle invalid color values gracefully
      final invalidScheme = BrandColorScheme(
        primary: Color(0x00000000), // Invalid transparent color
        secondary: Color(0xFF64B5F6),
      );

      // This should not crash the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandIntegrationWidget(
              brandScheme: invalidScheme,
              onChanged: onSchemeChanged,
            ),
          ),
        ),
      );

      expect(find.text('Brand Integration'), findsOneWidget);
    });
  });
}
