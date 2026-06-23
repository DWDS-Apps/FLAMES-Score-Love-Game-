/// Represents a single FLAMES calculation result saved to history.
///
/// Stores the two names compared, the result letter, and when
/// the calculation was performed.
class ResultEntry {
  /// The first name.
  final String name1;

  /// The second (crush's) name.
  final String name2;

  /// The FLAMES result letter (F, L, A, M, E, or S).
  final String resultLetter;

  /// Timestamp when the calculation was made.
  final DateTime timestamp;

  /// Creates a result entry.
  const ResultEntry({
    required this.name1,
    required this.name2,
    required this.resultLetter,
    required this.timestamp,
  });

  /// Deserializes from a JSON-compatible map.
  factory ResultEntry.fromJson(Map<String, dynamic> json) {
    return ResultEntry(
      name1: json['name1'] as String,
      name2: json['name2'] as String,
      resultLetter: json['resultLetter'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Serializes to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'name1': name1,
      'name2': name2,
      'resultLetter': resultLetter,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultEntry &&
          runtimeType == other.runtimeType &&
          name1 == other.name1 &&
          name2 == other.name2 &&
          resultLetter == other.resultLetter &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(name1, name2, resultLetter, timestamp);

  @override
  String toString() =>
      'ResultEntry(name1: $name1, name2: $name2, result: $resultLetter)';
}
