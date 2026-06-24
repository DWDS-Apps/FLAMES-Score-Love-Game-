/// Filipino (Philippines) localization for the FLAMES Love Game.
library;

import 'app_localizations.dart';

/// Filipino localization implementation.
class AppLocalizationsFil extends AppLocalizations {
  @override
  String get appTitle => 'FLAMES Larong Pag-ibig';

  @override
  String get headerSubtitle => 'Laro ng Puntos ng Pag-ibig';

  @override
  String get languageCode => 'fil';

  @override
  String get labelName1 => 'Iyong Pangalan';

  @override
  String get hintName1 => 'Ilagay ang unang pangalan';

  @override
  String get labelName2 => 'Pangalan ng Crush';

  @override
  String get hintName2 => 'Ilagay ang pangalawang pangalan';

  @override
  String get validationEmpty => 'Mangyaring maglagay ng pangalan';

  @override
  String get buttonCalculate => 'Kalkulahin ang FLAMES';

  @override
  String get buttonTryAgain => 'Subukan Muli';

  @override
  String get buttonShare => 'Ibahagi';

  @override
  String get historyTitle => 'Kasaysayan ng Resulta';

  @override
  String get historyClearAll => 'Linisin lahat';

  @override
  String get historyEmptyTitle => 'Wala pang resulta!';

  @override
  String get historyEmptySubtitle =>
      'Kalkulahin ang iyong unang FLAMES result.';

  @override
  String get shareTooltip => 'Ibahagi ang resulta';

  @override
  String get timestampJustNow => 'Ngayon lang';

  @override
  String timestampMinutesAgo(int minutes) => '$minutes minuto ang nakalipas';

  @override
  String timestampHoursAgo(int hours) => '$hours oras ang nakalipas';

  @override
  String timestampDaysAgo(int days) => '$days araw ang nakalipas';

  @override
  String get randomNameTooltip => 'Random na pangalan';

  @override
  String get historyTooltip => 'Kasaysayan ng resulta';

  @override
  String get lightModeTooltip => 'Lumipat sa light mode';

  @override
  String get darkModeTooltip => 'Lumipat sa dark mode';

  @override
  Map<String, String> get legendLabels => {
        'F': 'Magkaibigan',
        'L': 'Magkasintahan',
        'A': 'Pagmamahal',
        'M': 'Kasal',
        'E': 'Kaaway',
        'S': 'Magkapatid',
      };

  @override
  Map<String, Map<String, String>> get flamesMeanings => {
        'F': {
          'label': 'Magkaibigan',
          'emoji': '🤝',
          'description':
              'Magandang pagkakaibigan — magkasundo kayo bilang magkaibigan.',
          'color': '0xFF4CAF50',
        },
        'L': {
          'label': 'Magkasintahan',
          'emoji': '💕',
          'description':
              'Romantikong koneksyon — may kuryente sa pagitan ninyo!',
          'color': '0xFFE91E63',
        },
        'A': {
          'label': 'Pagmamahal',
          'emoji': '🥰',
          'description': 'Pag-aalaga at matatamis na damdamin — puro init.',
          'color': '0xFFFF9800',
        },
        'M': {
          'label': 'Kasal',
          'emoji': '💍',
          'description':
              'Matibay na pangmatagalang tugma — may potensyal na soulmate!',
          'color': '0xFF9C27B0',
        },
        'E': {
          'label': 'Kaaway',
          'emoji': '⚔️',
          'description': 'Alitan at pagtatalo — mas mabuting lumayo.',
          'color': '0xFFF44336',
        },
        'S': {
          'label': 'Magkapatid',
          'emoji': '👫',
          'description': 'Platonic na ugnayan — para bang magkapatid.',
          'color': '0xFF2196F3',
        },
      };

  @override
  String shareResultText(String name1, String name2, String letter,
      String label, String emoji, String description) {
    return '''💕 FLAMES Resulta ng Laro ng Pag-ibig 💕

$name1 ♥ $name2

Resulta: $letter — $label $emoji

$description

━━━━━━━━━━━━━━━━━━━━━━━
Gawa gamit ang FLAMES Larong Pag-ibig ❤️''';
  }

  @override
  String get switchToFilipino => 'Filipino';

  @override
  String get switchToEnglish => 'English';
}
