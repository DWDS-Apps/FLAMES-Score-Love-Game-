/// Application-wide constants for the FLAMES Love Game.
library;

/// App display configuration constants.
class AppConstants {
  AppConstants._();

  /// The application title shown in the window/tab.
  static const String appTitle = 'FLAMES Love Game';

  /// The main header text.
  static const String headerTitle = 'FLAMES';

  /// The subtitle below the header.
  static const String headerSubtitle = 'Love Score Game';

  // -- Input field labels & hints --
  static const String labelName1 = 'Your Name';
  static const String hintName1 = 'Enter first name';
  static const String labelName2 = "Crush's Name";
  static const String hintName2 = 'Enter second name';

  // -- Validation --
  static const String validationEmpty = 'Please enter a name';

  // -- Buttons --
  static const String buttonCalculate = 'Calculate FLAMES';
  static const String buttonTryAgain = 'Try Again';
  static const String buttonShare = 'Share';

  // -- Limits --
  static const int maxNameLength = 50;

  // -- Animation durations (milliseconds) --
  static const int resultFadeInMs = 500;
  static const int particleDurationMs = 2000;

  // -- Legend items (letter, label, emoji) --
  static const List<(String, String, String)> legendItems = [
    ('F', 'Friends', '🤝'),
    ('L', 'Lovers', '💕'),
    ('A', 'Affection', '🥰'),
    ('M', 'Marriage', '💍'),
    ('E', 'Enemy', '⚔️'),
    ('S', 'Siblings', '👫'),
  ];

  // -- Heart icon keys (for testing) --
  static const String heartIconKey = 'heart-icon';
  static const String resultCardKey = 'result-card';
  static const String calculateButtonKey = 'calculate-button';
  static const String tryAgainButtonKey = 'try-again-button';
  static const String shareButtonKey = 'share-button';
  static const String name1FieldKey = 'name1-field';
  static const String name2FieldKey = 'name2-field';
  static const String name1RandomKey = 'name1-random';
  static const String name2RandomKey = 'name2-random';
  static const String historyButtonKey = 'history-button';
  static const String historySheetKey = 'history-sheet';
  static const String clearHistoryButtonKey = 'clear-history-button';
  static const String emptyHistoryKey = 'empty-history';

  // -- Random name generator --
  static const List<String> sampleNames = [
    'Alice', 'Bob', 'Charlie', 'Diana', 'Ethan',
    'Fiona', 'George', 'Hannah', 'Ivan', 'Julia',
    'Kevin', 'Linda', 'Maria', 'Noah', 'Olivia',
    'Pedro', 'Queenie', 'Ramon', 'Sofia', 'Thomas',
    'Uma', 'Victor', 'Wendy', 'Xander', 'Yuki',
    'Zoe', 'Jose', 'Elena', 'Miguel', 'Isabella',
    'Lorenzo', 'Rosa', 'Antonio', 'Carmen', 'Diego',
    'Ana', 'Luis', 'Teresa', 'Carlos', 'Angela',
  ];
}

/// SharedPreferences storage keys.
class StorageKeys {
  StorageKeys._();

  /// Key for persisting the dark mode toggle preference.
  static const String darkMode = 'darkMode';

  /// Key for persisting the result history list.
  static const String resultHistory = 'resultHistory';

  /// Key for persisting the locale preference.
  static const String locale = 'locale';
}

/// Color-related constants for the app theme.
class AppColors {
  AppColors._();

  /// The seed color used for the Material 3 color scheme.
  static const int seedPink = 0xFFE91E63;
}
