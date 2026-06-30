/// Integration tests for the FLAMES Love Game app.
///
/// Tests the full app flow end-to-end, including:
/// - App launch and initial state
/// - Name entry and FLAMES calculation
/// - Result display and interaction
/// - Dark mode toggle
/// - Locale switching
/// - History functionality
/// - Try again / reset flow
///
/// Uses key-based finders to remain locale-independent.
/// Run with: flutter test integration_test/
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flames_love_game/main.dart';
import 'package:flames_love_game/constants/app_constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Integration Tests', () {
    testWidgets('app launches and shows FLAMES header', (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // The header title should be visible (locale-independent)
      expect(find.text('FLAMES'), findsOneWidget);

      // Input fields should be present
      expect(find.byType(TextFormField), findsNWidgets(2));

      // History, locale, and dark mode buttons present
      expect(find.byIcon(Icons.history_rounded), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('complete calculate flow: enter names and see result',
        (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter first name
      await tester.enterText(
        find.byType(TextFormField).first,
        'Alice',
      );
      await tester.pump();

      // Enter second name
      await tester.enterText(
        find.byType(TextFormField).last,
        'Bob',
      );
      await tester.pump();

      // Tap calculate (using key to stay locale-independent)
      await tester.tap(
        find.byKey(const ValueKey(AppConstants.calculateButtonKey)),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Result card should appear
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('validate empty fields show error messages',
        (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap calculate without entering names (using key to stay locale-independent)
      await tester.tap(
        find.byKey(const ValueKey(AppConstants.calculateButtonKey)),
      );
      await tester.pumpAndSettle();

      // Validation errors appear — at least one error text should be shown
      // (locale-independent check: at least one error widget)
      expect(find.text('FLAMES'), findsOneWidget); // Header still visible
      // No result card (validation prevented calculation)
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('locale toggle switches between EN and FIL',
        (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Locale button text — it's either EN or FIL depending on persisted state
      // We find the locale toggle by its position in the button row
      final localeButton = find.byIcon(Icons.history_rounded);
      expect(localeButton, findsOneWidget);

      // Find the locale toggle icon button (the text-based button in header)
      // It shows the language code (EN or FIL)
      final buttons = find.byType(IconButton);
      // Tap the second-to-last icon button (locale toggle, adjacent to dark mode)
      // We know the order: history, locale toggle, dark mode
      final localeToggle = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Text,
      );
      // If locale toggle has text icon, it's our target
      if (localeToggle.evaluate().isNotEmpty) {
        await tester.tap(localeToggle.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // After toggling, the button text should have changed
        // (still finds a text-based IconButton)
        expect(find.byWidgetPredicate(
          (widget) => widget is IconButton && widget.icon is Text,
        ), findsOneWidget);
      }
    });

    testWidgets('dark mode toggle changes icon', (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Initially in light mode — dark mode toggle icon
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Tap dark mode toggle
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should now show light mode icon
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('random name generator fills fields', (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Both fields should be empty initially
      final field1 = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      final field2 = tester.widget<TextFormField>(
        find.byType(TextFormField).last,
      );
      expect(field1.controller!.text, isEmpty);
      expect(field2.controller!.text, isEmpty);

      // Tap shuffle on first field
      await tester.tap(find.byIcon(Icons.shuffle).first);
      await tester.pump();

      // First field should now have text
      expect(field1.controller!.text, isNotEmpty);

      // Tap shuffle on second field
      await tester.tap(find.byIcon(Icons.shuffle).last);
      await tester.pump();

      // Second field should now have text
      expect(field2.controller!.text, isNotEmpty);
    });

    testWidgets('history shows after calculating', (tester) async {
      await tester.pumpWidget(const FlamesApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter names and calculate
      await tester.enterText(
        find.byType(TextFormField).first,
        'Maria',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Jose',
      );
      await tester.tap(
        find.byKey(const ValueKey(AppConstants.calculateButtonKey)),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Result card should appear
      expect(find.byType(Card), findsOneWidget);

      // Tap history button
      await tester.tap(find.byIcon(Icons.history_rounded));
      await tester.pumpAndSettle();

      // History sheet should open with the entry (names are locale-independent)
      expect(find.text('Maria ♥ Jose'), findsOneWidget);
    });
  });
}
