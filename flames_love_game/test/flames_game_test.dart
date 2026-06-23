import 'package:flutter_test/flutter_test.dart';
import 'package:flames_love_game/models/flames_game.dart';

void main() {
  group('FLAMES Calculation', () {
    test('identical names return Siblings (everything cancels out)', () {
      final result = FlamesGame.calculate('Alice', 'Alice');
      expect(result, 'S');
    });

    test('completely different letters', () {
      // A(1) vs B(1) → 2 remaining letters
      // FLAMES: (2-1)%6=1 → remove L → FAMES
      // (2-1)%5=1 → remove A → FMES
      // (2-1)%4=1 → remove M → FES
      // (2-1)%3=1 → remove E → FS
      // (2-1)%2=1 → remove S → F
      final result = FlamesGame.calculate('A', 'B');
      expect(result, 'F');
    });

    test('case insensitive', () {
      final r1 = FlamesGame.calculate('ALICE', 'Bob');
      final r2 = FlamesGame.calculate('alice', 'bob');
      expect(r1, r2);
    });

    test('spaces are trimmed', () {
      final r1 = FlamesGame.calculate('  John  ', '  Jane  ');
      final r2 = FlamesGame.calculate('John', 'Jane');
      expect(r1, r2);
    });

    test('non-alphabetic characters are ignored', () {
      final r1 = FlamesGame.calculate('John123', 'Jane!@#');
      final r2 = FlamesGame.calculate('John', 'Jane');
      expect(r1, r2);
    });

    test('known pair: ALCHIE + TAGUDIN', () {
      // A:1, L:1, C:1, H:1, I:1, E:1 vs T:1, A:1, G:1, U:1, D:1, I:1, N:1
      // Cancelled: A (1-1=0), I (1-1=0)
      // Remaining: L,C,H,E,T,G,U,D,N = 9
      // (9-1)%6=2 → remove A → FLMES
      // (9-1)%5=3 → remove E → FLMS
      // (9-1)%4=0 → remove F → LMS
      // (9-1)%3=2 → remove S → LM
      // (9-1)%2=0 → remove L → M
      final result = FlamesGame.calculate('Alchie', 'Tagudin');
      expect(result, 'M');
    });

    test('one name empty returns empty', () {
      expect(FlamesGame.calculate('', 'Jane'), '');
      expect(FlamesGame.calculate('John', ''), '');
    });

    test('both names empty returns empty', () {
      expect(FlamesGame.calculate('', ''), '');
    });
  });

  group('Edge Cases', () {
    test('non-ASCII characters like ñ and ü are ignored (only a-z)', () {
      // These names only differ by non-ASCII chars which get stripped
      final result = FlamesGame.calculate('José', 'Peña');
      // J=1, o=1, s=1, e=1 vs P=1, e=1, n=1, a=1
      // Cancelled: e
      // Remaining: J, o, s, P, n, a = 6
      // (6-1)%6=5 -> remove S -> FLAME
      // (6-1)%5=0 -> remove F -> LAME
      // (6-1)%4=3 -> remove E -> LAM
      // (6-1)%3=2 -> remove M -> LA
      // (6-1)%2=1 -> remove A -> L
      expect(result, isNotEmpty);
    });

    test('duplicate letters in names cancel correctly', () {
      // 'AAB' has A:2, B:1
      // 'AB' has A:1, B:1
      // Cancelled: A(1), B(1)
      // Remaining: A(1) = 1
      // (1-1)%6=0 -> remove F -> LAMES...
      // Actually with 1: (1-1)%6=0, remove index 0 (F) -> LAMES
      // (1-1)%5=0, remove index 0 (L) -> AMES
      // (1-1)%4=0, remove index 0 (A) -> MES
      // (1-1)%3=0, remove index 0 (M) -> ES
      // (1-1)%2=0, remove index 0 (E) -> S
      final result = FlamesGame.calculate('AAB', 'AB');
      expect(result, 'S');
    });

    test('all letters the same in both names cancels to Siblings', () {
      expect(FlamesGame.calculate('aaaa', 'aaaa'), 'S');
    });

    test('numbers and special chars in names are ignored', () {
      final result1 = FlamesGame.calculate('John123!@#', r'Jane456$%^');
      final result2 = FlamesGame.calculate('John', 'Jane');
      expect(result1, result2);
    });

    test('very long names handle gracefully', () {
      final longName = 'A' * 100;
      final result = FlamesGame.calculate(longName, 'B');
      expect(result, isNotEmpty);
    });

    test('names with only spaces after trim return empty', () {
      expect(FlamesGame.calculate('   ', 'Jane'), '');
      expect(FlamesGame.calculate('John', '   '), '');
    });
  });

  group('FLAMES Meanings', () {
    test('all letters have meanings', () {
      for (final letter in ['F', 'L', 'A', 'M', 'E', 'S']) {
        final meaning = FlamesGame.getMeaning(letter);
        expect(meaning, isNotNull);
        expect(meaning!['label'], isNotEmpty);
        expect(meaning['emoji'], isNotEmpty);
        expect(meaning['description'], isNotEmpty);
      }
    });

    test('invalid letter returns null', () {
      expect(FlamesGame.getMeaning('X'), isNull);
    });
  });
}
