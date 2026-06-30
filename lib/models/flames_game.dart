/// Implements the classic FLAMES love compatibility algorithm.
///
/// FLAMES stands for Friends, Lovers, Affection, Marriage, Enemy, Siblings.
/// The algorithm counts unmatched letters between two names and uses that
/// count to eliminate letters from "FLAMES" until one remains.
class FlamesGame {
  /// The six FLAMES letters in order.
  static const List<String> flamesLetters = ['F', 'L', 'A', 'M', 'E', 'S'];

  /// Meanings for each FLAMES letter.
  ///
  /// Each entry contains:
  /// - `label`: Human-readable category name
  /// - `emoji`: Corresponding emoji
  /// - `description`: Explanation of the result
  /// - `color`: Theme color as a hex string
  static const Map<String, Map<String, String>> flamesMeanings = {
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

  /// Calculates the FLAMES result for two names.
  ///
  /// Algorithm:
  /// 1. Count letter frequencies for each name (case-insensitive).
  /// 2. For each letter, take the absolute difference of counts.
  /// 3. Sum all differences to get the total remaining letter count.
  /// 4. Use that count to iteratively eliminate letters from "FLAMES".
  /// 5. The last remaining letter is the result.
  ///
  /// Returns an empty string if either name is empty after trimming.
  static String calculate(String name1, String name2) {
    final n1 = name1.trim().toLowerCase();
    final n2 = name2.trim().toLowerCase();

    if (n1.isEmpty || n2.isEmpty) return '';

    final count1 = _letterCounts(n1);
    final count2 = _letterCounts(n2);

    // Sum of absolute differences = remaining uncancelled letters
    int remaining = 0;
    final allLetters = <String>{...count1.keys, ...count2.keys};
    for (final letter in allLetters) {
      remaining += ((count1[letter] ?? 0) - (count2[letter] ?? 0)).abs();
    }

    if (remaining == 0) return 'S'; // everything cancels out → Siblings

    // Elimination game
    final flames = List<String>.from(flamesLetters);
    while (flames.length > 1) {
      final pos = (remaining - 1) % flames.length;
      flames.removeAt(pos);
    }

    return flames.first;
  }

  /// Returns the meaning map for a given FLAMES letter.
  ///
  /// Returns `null` if [letter] is not one of F, L, A, M, E, or S.
  static Map<String, String>? getMeaning(String letter) {
    return flamesMeanings[letter];
  }

  /// Matches a single lowercase letter a-z.
  static final _letterRegex = RegExp(r'^[a-z]$');

  /// Counts letter frequencies (a-z only, case-normalized).
  ///
  /// Ignores non-alphabetic characters and spaces.
  static Map<String, int> _letterCounts(String input) {
    final counts = <String, int>{};
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (_letterRegex.hasMatch(char)) {
        counts[char] = (counts[char] ?? 0) + 1;
      }
    }
    return counts;
  }
}
