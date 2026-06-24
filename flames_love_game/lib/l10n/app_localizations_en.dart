/// English (US) localization for the FLAMES Love Game.
library;

import 'app_localizations.dart';

/// English localization implementation.
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'FLAMES Love Game';

  @override
  String get headerSubtitle => 'Love Score Game';

  @override
  String get languageCode => 'en';

  @override
  String get labelName1 => 'Your Name';

  @override
  String get hintName1 => 'Enter first name';

  @override
  String get labelName2 => "Crush's Name";

  @override
  String get hintName2 => 'Enter second name';

  @override
  String get validationEmpty => 'Please enter a name';

  @override
  String get buttonCalculate => 'Calculate FLAMES';

  @override
  String get buttonTryAgain => 'Try Again';

  @override
  String get buttonShare => 'Share';

  @override
  String get historyTitle => 'Result History';

  @override
  String get historyClearAll => 'Clear all';

  @override
  String get historyEmptyTitle => 'No results yet!';

  @override
  String get historyEmptySubtitle => 'Calculate your first FLAMES result.';

  @override
  String get shareTooltip => 'Share result';

  @override
  String get timestampJustNow => 'Just now';

  @override
  String timestampMinutesAgo(int minutes) => '${minutes}m ago';

  @override
  String timestampHoursAgo(int hours) => '${hours}h ago';

  @override
  String timestampDaysAgo(int days) => '${days}d ago';

  @override
  String get randomNameTooltip => 'Random name';

  @override
  String get historyTooltip => 'Result history';

  @override
  String get lightModeTooltip => 'Switch to light mode';

  @override
  String get darkModeTooltip => 'Switch to dark mode';

  @override
  Map<String, String> get legendLabels => {
        'F': 'Friends',
        'L': 'Lovers',
        'A': 'Affection',
        'M': 'Marriage',
        'E': 'Enemy',
        'S': 'Siblings',
      };

  @override
  Map<String, Map<String, String>> get flamesMeanings => {
        'F': {
          'label': 'Friends',
          'emoji': '🤝',
          'description': 'Good friendship bond — you two vibe as friends.',
          'color': '0xFF4CAF50',
        },
        'L': {
          'label': 'Lovers',
          'emoji': '💕',
          'description': 'Romantic connection — sparks fly between you!',
          'color': '0xFFE91E63',
        },
        'A': {
          'label': 'Affection',
          'emoji': '🥰',
          'description': 'Care and sweet feelings — pure warmth.',
          'color': '0xFFFF9800',
        },
        'M': {
          'label': 'Marriage',
          'emoji': '💍',
          'description': 'Strong long-term match — soulmate potential!',
          'color': '0xFF9C27B0',
        },
        'E': {
          'label': 'Enemy',
          'emoji': '⚔️',
          'description': 'Conflict and arguments — better keep distance.',
          'color': '0xFFF44336',
        },
        'S': {
          'label': 'Siblings',
          'emoji': '👫',
          'description': 'Platonic bond — like brother and sister.',
          'color': '0xFF2196F3',
        },
      };

  @override
  String shareResultText(String name1, String name2, String letter,
      String label, String emoji, String description) {
    return '''💕 FLAMES Love Game Result 💕

$name1 ♥ $name2

Result: $letter — $label $emoji

$description

━━━━━━━━━━━━━━━━━━━━━━━
Made with FLAMES Love Game ❤️''';
  }

  @override
  String get switchToFilipino => 'Filipino';

  @override
  String get switchToEnglish => 'English';
}
