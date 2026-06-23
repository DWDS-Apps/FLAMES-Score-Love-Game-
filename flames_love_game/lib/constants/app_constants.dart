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
  static const String name1FieldKey = 'name1-field';
  static const String name2FieldKey = 'name2-field';
}

/// Color-related constants for the app theme.
class AppColors {
  AppColors._();

  /// The seed color used for the Material 3 color scheme.
  static const int seedPink = 0xFFE91E63;
}
