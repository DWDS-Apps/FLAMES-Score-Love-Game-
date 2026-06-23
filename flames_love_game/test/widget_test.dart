import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flames_love_game/models/flames_game.dart';
import 'package:flames_love_game/screens/home_screen.dart';
import 'package:flames_love_game/widgets/result_card.dart';

Widget createHomeScreen() {
  return MaterialApp(
    home: HomeScreen(
      onToggleDarkMode: () {},
    ),
  );
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('renders the FLAMES header and legend', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Header should be present
      expect(find.text('FLAMES'), findsOneWidget);
      expect(find.text('Love Score Game'), findsOneWidget);

      // Legend items should be present
      expect(find.text('F'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);

      // Legend labels
      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Lovers'), findsOneWidget);
      expect(find.text('Siblings'), findsOneWidget);
    });

    testWidgets('shows two text fields and calculate button initially',
        (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Input fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text("Crush's Name"), findsOneWidget);

      // Calculate button
      expect(find.text('Calculate FLAMES'), findsOneWidget);
    });

    testWidgets('validates empty fields', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Tap calculate without entering anything
      await tester.tap(find.text('Calculate FLAMES'));
      await tester.pumpAndSettle();

      // Validation error should appear
      expect(find.text('Please enter a name'), findsNWidgets(2));
    });

    testWidgets('shows result after entering names', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Enter names
      await tester.enterText(
        find.byType(TextFormField).first,
        'Alice',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Bob',
      );

      // Tap calculate
      await tester.tap(find.text('Calculate FLAMES'));
      await tester.pumpAndSettle();

      // Result card should appear
      expect(find.byType(ResultCard), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      // Try again button should appear
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('try again resets to form', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Enter names and calculate
      await tester.enterText(
        find.byType(TextFormField).first,
        'Alice',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Bob',
      );
      await tester.tap(find.text('Calculate FLAMES'));
      await tester.pumpAndSettle();

      // Result should be visible
      expect(find.byType(ResultCard), findsOneWidget);

      // Scroll down to reveal the Try Again button
      await tester.scrollUntilVisible(
        find.text('Try Again'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      // Tap try again
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      // Form should be back
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Calculate FLAMES'), findsOneWidget);
      expect(find.byType(ResultCard), findsNothing);
    });

    testWidgets('clear buttons appear when text is entered', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // No clear buttons initially
      expect(find.byIcon(Icons.close), findsNothing);

      // Enter text in first field
      await tester.enterText(
        find.byType(TextFormField).first,
        'Alice',
      );
      await tester.pump();

      // Clear button should appear for first field
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('dark mode toggle button is present', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Dark mode toggle should be present
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('tapping dark mode toggles icon', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(
          isDarkMode: false,
          onToggleDarkMode: () {
            toggled = true;
          },
        ),
      ));

      // Dark mode icon is shown
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Tap the toggle
      await tester.tap(find.byIcon(Icons.dark_mode));
      expect(toggled, isTrue);
    });

    testWidgets('shuffle random name buttons are present on both fields',
        (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Both fields should have shuffle buttons
      expect(find.byIcon(Icons.shuffle), findsNWidgets(2));
    });

    testWidgets('tapping shuffle fills first field with a name',
        (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Tap shuffle on first field
      await tester.tap(find.byIcon(Icons.shuffle).first);
      await tester.pump();

      // First field should now have text
      final field1 = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(field1.controller!.text, isNotEmpty);
    });

    testWidgets('tapping shuffle fills second field with a name',
        (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Tap shuffle on second field
      await tester.tap(find.byIcon(Icons.shuffle).last);
      await tester.pump();

      // Second field should now have text
      final field2 = tester.widget<TextFormField>(
        find.byType(TextFormField).last,
      );
      expect(field2.controller!.text, isNotEmpty);
    });
  });

  group('ResultCard Widget Tests', () {
    testWidgets('renders result card with given letter and names',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ResultCard(
            letter: 'L',
            name1: 'Alice',
            name2: 'Bob',
          ),
        ),
      ));

      // Should display the letter
      expect(find.text('L'), findsOneWidget);

      // Should display the names
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      // Should display the meaning
      expect(find.textContaining('Lovers'), findsOneWidget);
      expect(find.textContaining('Romantic'), findsOneWidget);
    });

    testWidgets('renders all six possible result letters', (tester) async {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ResultCard(
              letter: letter,
              name1: 'Test1',
              name2: 'Test2',
            ),
          ),
        ));

        // The meaning should exist (not an empty SizedBox)
        final meaning = FlamesGame.getMeaning(letter);
        expect(meaning, isNotNull);
        expect(find.textContaining(meaning!['label']!), findsOneWidget);
      }
    });

    testWidgets('invalid letter returns empty SizedBox', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ResultCard(
            letter: 'X',
            name1: 'A',
            name2: 'B',
          ),
        ),
      ));

      // Nothing should be rendered
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });
  });
}
