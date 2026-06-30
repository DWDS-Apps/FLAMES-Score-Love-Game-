import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flames_love_game/models/result_entry.dart';
import 'package:flames_love_game/services/result_history_service.dart';

void main() {
  group('ResultEntry Model', () {
    test('toJson and fromJson round-trip', () {
      final entry = ResultEntry(
        name1: 'Alice',
        name2: 'Bob',
        resultLetter: 'L',
        timestamp: DateTime(2026, 6, 23, 12, 30, 0),
      );

      final json = entry.toJson();
      final restored = ResultEntry.fromJson(json);

      expect(restored.name1, 'Alice');
      expect(restored.name2, 'Bob');
      expect(restored.resultLetter, 'L');
      expect(restored.timestamp, DateTime(2026, 6, 23, 12, 30, 0));
    });

    test('equality works correctly', () {
      final a = ResultEntry(
        name1: 'A',
        name2: 'B',
        resultLetter: 'F',
        timestamp: DateTime(2026, 1, 1),
      );
      final b = ResultEntry(
        name1: 'A',
        name2: 'B',
        resultLetter: 'F',
        timestamp: DateTime(2026, 1, 1),
      );
      final c = ResultEntry(
        name1: 'X',
        name2: 'Y',
        resultLetter: 'L',
        timestamp: DateTime(2026, 1, 2),
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });
  });

  group('ResultHistoryService', () {
    late ResultHistoryService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = ResultHistoryService();
    });

    test('starts with empty history', () async {
      final history = await service.getHistory();
      expect(history, isEmpty);
    });

    test('saves and retrieves an entry', () async {
      final entry = ResultEntry(
        name1: 'Alice',
        name2: 'Bob',
        resultLetter: 'L',
        timestamp: DateTime(2026, 6, 23),
      );

      await service.saveEntry(entry);
      final history = await service.getHistory();

      expect(history.length, 1);
      expect(history.first.name1, 'Alice');
      expect(history.first.name2, 'Bob');
      expect(history.first.resultLetter, 'L');
    });

    test('entries are ordered newest first', () async {
      final old = ResultEntry(
        name1: 'A',
        name2: 'B',
        resultLetter: 'F',
        timestamp: DateTime(2026, 1, 1),
      );
      final recent = ResultEntry(
        name1: 'C',
        name2: 'D',
        resultLetter: 'L',
        timestamp: DateTime(2026, 6, 23),
      );

      await service.saveEntry(old);
      await service.saveEntry(recent);
      final history = await service.getHistory();

      expect(history.length, 2);
      expect(history[0].name1, 'C'); // newest first
      expect(history[1].name1, 'A'); // oldest last
    });

    test('clearHistory removes all entries', () async {
      await service.saveEntry(
        ResultEntry(
          name1: 'A',
          name2: 'B',
          resultLetter: 'F',
          timestamp: DateTime(2026, 1, 1),
        ),
      );
      await service.saveEntry(
        ResultEntry(
          name1: 'C',
          name2: 'D',
          resultLetter: 'L',
          timestamp: DateTime(2026, 6, 23),
        ),
      );

      await service.clearHistory();
      final history = await service.getHistory();
      expect(history, isEmpty);
    });

    test('removeEntry removes specific entry by index', () async {
      await service.saveEntry(
        ResultEntry(
          name1: 'A',
          name2: 'B',
          resultLetter: 'F',
          timestamp: DateTime(2026, 1, 1),
        ),
      );
      await service.saveEntry(
        ResultEntry(
          name1: 'C',
          name2: 'D',
          resultLetter: 'L',
          timestamp: DateTime(2026, 6, 23),
        ),
      );

      // Remove the first (newest) entry
      await service.removeEntry(0);
      final history = await service.getHistory();

      expect(history.length, 1);
      expect(history.first.name1, 'A');
    });

    test('removeEntry with out-of-range index does nothing', () async {
      await service.saveEntry(
        ResultEntry(
          name1: 'A',
          name2: 'B',
          resultLetter: 'F',
          timestamp: DateTime(2026, 1, 1),
        ),
      );

      await service.removeEntry(99); // out of range
      final history = await service.getHistory();
      expect(history.length, 1);
    });

    test('caps at maxEntries', () async {
      // Save more than max entries
      for (var i = 0; i < ResultHistoryService.maxEntries + 5; i++) {
        await service.saveEntry(
          ResultEntry(
            name1: 'Name${i}a',
            name2: 'Name${i}b',
            resultLetter: 'L',
            timestamp: DateTime(2026, 1, 1).add(Duration(hours: i)),
          ),
        );
      }

      final history = await service.getHistory();
      expect(history.length, ResultHistoryService.maxEntries);
    });

    test('survives multiple read-write cycles', () async {
      // Write once
      await service.saveEntry(
        ResultEntry(
          name1: 'A',
          name2: 'B',
          resultLetter: 'F',
          timestamp: DateTime(2026, 1, 1),
        ),
      );

      // Read
      var history = await service.getHistory();
      expect(history.length, 1);

      // Write again
      await service.saveEntry(
        ResultEntry(
          name1: 'C',
          name2: 'D',
          resultLetter: 'L',
          timestamp: DateTime(2026, 6, 23),
        ),
      );

      // Read again
      history = await service.getHistory();
      expect(history.length, 2);
    });
  });
}
