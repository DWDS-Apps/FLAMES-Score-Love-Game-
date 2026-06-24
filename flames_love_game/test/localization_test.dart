import 'package:flutter_test/flutter_test.dart';
import 'package:flames_love_game/l10n/app_localizations_en.dart';
import 'package:flames_love_game/l10n/app_localizations_fil.dart';

void main() {
  group('AppLocalizationsEn', () {
    late AppLocalizationsEn l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    test('all string getters return non-empty strings', () {
      expect(l10n.appTitle, isNotEmpty);
      expect(l10n.headerSubtitle, isNotEmpty);
      expect(l10n.languageCode, 'en');
      expect(l10n.labelName1, isNotEmpty);
      expect(l10n.hintName1, isNotEmpty);
      expect(l10n.labelName2, isNotEmpty);
      expect(l10n.hintName2, isNotEmpty);
      expect(l10n.validationEmpty, isNotEmpty);
      expect(l10n.buttonCalculate, isNotEmpty);
      expect(l10n.buttonTryAgain, isNotEmpty);
      expect(l10n.buttonShare, isNotEmpty);
      expect(l10n.historyTitle, isNotEmpty);
      expect(l10n.historyClearAll, isNotEmpty);
      expect(l10n.historyEmptyTitle, isNotEmpty);
      expect(l10n.historyEmptySubtitle, isNotEmpty);
      expect(l10n.shareTooltip, isNotEmpty);
      expect(l10n.timestampJustNow, isNotEmpty);
      expect(l10n.randomNameTooltip, isNotEmpty);
      expect(l10n.historyTooltip, isNotEmpty);
      expect(l10n.lightModeTooltip, isNotEmpty);
      expect(l10n.darkModeTooltip, isNotEmpty);
      expect(l10n.switchToFilipino, isNotEmpty);
      expect(l10n.switchToEnglish, isNotEmpty);
    });

    test('timestamp formatting functions return non-empty strings', () {
      expect(l10n.timestampMinutesAgo(5), contains('5'));
      expect(l10n.timestampHoursAgo(3), contains('3'));
      expect(l10n.timestampDaysAgo(2), contains('2'));
    });

    test('legendLabels covers all six letters', () {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        expect(l10n.legendLabels, containsPair(letter, isNotEmpty));
      }
    });

    test('flamesMeanings covers all six letters', () {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        final meaning = l10n.flamesMeanings[letter];
        expect(meaning, isNotNull);
        expect(meaning!['label'], isNotEmpty);
        expect(meaning['emoji'], isNotEmpty);
        expect(meaning['description'], isNotEmpty);
        expect(meaning['color'], startsWith('0xFF'));
      }
    });

    test('shareResultText contains the key components', () {
      final text = l10n.shareResultText(
          'Alice', 'Bob', 'L', 'Lovers', '💕', 'Romantic connection');
      expect(text, contains('Alice'));
      expect(text, contains('Bob'));
      expect(text, contains('L'));
      expect(text, contains('Lovers'));
      expect(text, contains('FLAMES'));
    });
  });

  group('AppLocalizationsFil', () {
    late AppLocalizationsFil l10n;

    setUp(() {
      l10n = AppLocalizationsFil();
    });

    test('all string getters return non-empty strings', () {
      expect(l10n.appTitle, isNotEmpty);
      expect(l10n.headerSubtitle, isNotEmpty);
      expect(l10n.languageCode, 'fil');
      expect(l10n.labelName1, isNotEmpty);
      expect(l10n.hintName1, isNotEmpty);
      expect(l10n.labelName2, isNotEmpty);
      expect(l10n.hintName2, isNotEmpty);
      expect(l10n.validationEmpty, isNotEmpty);
      expect(l10n.buttonCalculate, isNotEmpty);
      expect(l10n.buttonTryAgain, isNotEmpty);
      expect(l10n.buttonShare, isNotEmpty);
      expect(l10n.historyTitle, isNotEmpty);
      expect(l10n.historyClearAll, isNotEmpty);
      expect(l10n.historyEmptyTitle, isNotEmpty);
      expect(l10n.historyEmptySubtitle, isNotEmpty);
      expect(l10n.shareTooltip, isNotEmpty);
      expect(l10n.timestampJustNow, isNotEmpty);
      expect(l10n.randomNameTooltip, isNotEmpty);
      expect(l10n.historyTooltip, isNotEmpty);
      expect(l10n.lightModeTooltip, isNotEmpty);
      expect(l10n.darkModeTooltip, isNotEmpty);
      expect(l10n.switchToFilipino, isNotEmpty);
      expect(l10n.switchToEnglish, isNotEmpty);
    });

    test('timestamp formatting functions return non-empty strings', () {
      expect(l10n.timestampMinutesAgo(5), contains('5'));
      expect(l10n.timestampHoursAgo(3), contains('3'));
      expect(l10n.timestampDaysAgo(2), contains('2'));
    });

    test('legendLabels covers all six letters with Filipino translations', () {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        expect(l10n.legendLabels, containsPair(letter, isNotEmpty));
      }
      // Verify they're actually different from English
      expect(l10n.legendLabels['F'], isNot('Friends'));
      expect(l10n.legendLabels['L'], isNot('Lovers'));
    });

    test('flamesMeanings covers all six letters with Filipino translations',
        () {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        final meaning = l10n.flamesMeanings[letter];
        expect(meaning, isNotNull);
        expect(meaning!['label'], isNotEmpty);
        expect(meaning['emoji'], isNotEmpty);
        expect(meaning['description'], isNotEmpty);
        expect(meaning['color'], startsWith('0xFF'));
      }
      // Verify descriptions are in Filipino
      final friendsMeaning = l10n.flamesMeanings['F']!;
      expect(friendsMeaning['label'], 'Magkaibigan');
    });

    test('shareResultText uses Filipino format', () {
      final text = l10n.shareResultText(
          'Alice', 'Bob', 'L', 'Magkasintahan', '💕', 'Romantikong koneksyon');
      expect(text, contains('Alice'));
      expect(text, contains('Bob'));
      expect(text, contains('Resulta'));
      expect(text, contains('Larong Pag-ibig'));
    });
  });
}
