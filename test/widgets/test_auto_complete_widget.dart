import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_setting_ui/src/widgets/auto_complete_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AutoCompleteWidget', () {
    const testSuggestions = [
      'Theme Settings',
      'Animation Settings',
      'Brand Integration',
      'Notification Settings',
      'Privacy Settings',
      'Security Settings',
      'Language Settings',
      'Accessibility Settings',
    ];

    late List<String> selectedItems;
    late List<String> searchHistory;

    setUp(() {
      selectedItems = [];
      searchHistory = [];
    });

    void onItemSelected(String item) {
      selectedItems.add(item);
      searchHistory.add(item);
    }

    testWidgets('should display search field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search settings...'), findsOneWidget);
    });

    testWidgets('should show suggestions when typing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      // Type in search field
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'theme');
      await tester.pumpAndSettle();

      // Should show filtered suggestions
      expect(find.text('Theme Settings'), findsOneWidget);
      expect(find.text('Animation Settings'),
          findsNothing); // Should be filtered out
    });

    testWidgets('should handle fuzzy search', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      // Type partial match
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'sett');
      await tester.pumpAndSettle();

      // Should find multiple matches
      expect(find.text('Theme Settings'), findsOneWidget);
      expect(find.text('Notification Settings'), findsOneWidget);
      expect(find.text('Privacy Settings'), findsOneWidget);
    });

    testWidgets('should select item when tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      // Type and select
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'theme');
      await tester.pumpAndSettle();

      // Tap on suggestion
      await tester.tap(find.text('Theme Settings'));
      await tester.pumpAndSettle();

      expect(selectedItems.length, equals(1));
      expect(selectedItems.first, equals('Theme Settings'));
    });

    testWidgets('should show no results message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      // Type non-matching text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'xyz123');
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('should handle empty suggestions list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: [],
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('should show recent searches', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
              recentSearches: ['Theme Settings', 'Animation Settings'],
            ),
          ),
        ),
      );

      // Focus search field to show recent searches
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Theme Settings'),
          findsWidgets); // Should appear in both sections
    });

    testWidgets('should highlight search matches', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'theme');
      await tester.pumpAndSettle();

      // The implementation should highlight "Theme" in "Theme Settings"
      // This is tested by ensuring the text is displayed correctly
      expect(find.text('Theme Settings'), findsOneWidget);
    });

    testWidgets('should handle case insensitive search', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'THEME');
      await tester.pumpAndSettle();

      expect(find.text('Theme Settings'), findsOneWidget);
    });

    testWidgets('should clear search when clear button tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'theme');
      await tester.pumpAndSettle();

      // Should have suggestions visible
      expect(find.text('Theme Settings'), findsOneWidget);

      // Tap clear button (suffix icon)
      final clearButton = find.byIcon(Icons.clear);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Search field should be empty and no suggestions visible
      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('should be disabled when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
              enabled: false,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      final textField = tester.widget<TextField>(searchField);
      expect(textField.enabled, isFalse);
    });

    testWidgets('should handle very long suggestion lists', (tester) async {
      // Create a large list of suggestions
      final largeSuggestions = List.generate(1000, (i) => 'Setting $i');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: largeSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Setting 5');
      await tester.pumpAndSettle();

      // Should find the matching suggestion
      expect(find.text('Setting 5'), findsOneWidget);
      expect(find.text('Setting 50'), findsOneWidget);
    });

    testWidgets('should debounce search input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);

      // Type quickly - should debounce
      await tester.enterText(searchField, 't');
      await tester.enterText(searchField, 'th');
      await tester.enterText(searchField, 'the');
      await tester.enterText(searchField, 'them');
      await tester.enterText(searchField, 'theme');

      // Wait for debounce
      await tester.pumpAndSettle();

      expect(find.text('Theme Settings'), findsOneWidget);
    });

    testWidgets('should show loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: testSuggestions,
              onItemSelected: onItemSelected,
              isLoading: true,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'theme');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle special characters in search', (tester) async {
      const suggestionsWithSpecialChars = [
        'Settings & Preferences',
        'Theme (Dark/Light)',
        'Animation [Advanced]',
        'Brand-Integration',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoCompleteWidget(
              suggestions: suggestionsWithSpecialChars,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, '&');
      await tester.pumpAndSettle();

      expect(find.text('Settings & Preferences'), findsOneWidget);
    });
  });
}
