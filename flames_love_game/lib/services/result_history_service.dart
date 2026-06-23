import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/result_entry.dart';

/// Service for persisting and retrieving FLAMS result history
/// using [SharedPreferences] as the local storage backend.
///
/// Stores up to [maxEntries] recent results, dropping the oldest
/// when the limit is exceeded.
class ResultHistoryService {
  /// Maximum number of history entries to keep.
  static const int maxEntries = 50;

  /// Creates a service with an optional dry-run flag for testing.
  ResultHistoryService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  /// Lazily loads SharedPreferences.
  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Retrieves all saved history entries, newest first.
  Future<List<ResultEntry>> getHistory() async {
    final prefs = await _storage;
    final raw = prefs.getString(StorageKeys.resultHistory);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ResultEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Saves a new result entry to the top of the history.
  ///
  /// Automatically caps the total at [maxEntries].
  Future<void> saveEntry(ResultEntry entry) async {
    final history = await getHistory();
    history.insert(0, entry);

    // Cap at max entries
    if (history.length > maxEntries) {
      history.removeRange(maxEntries, history.length);
    }

    await _persist(history);
  }

  /// Clears all history entries.
  Future<void> clearHistory() async {
    final prefs = await _storage;
    await prefs.remove(StorageKeys.resultHistory);
  }

  /// Removes a single entry from history by index.
  Future<void> removeEntry(int index) async {
    final history = await getHistory();
    if (index < 0 || index >= history.length) return;
    history.removeAt(index);
    await _persist(history);
  }

  /// Persists the full history list to SharedPreferences.
  Future<void> _persist(List<ResultEntry> history) async {
    final prefs = await _storage;
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(StorageKeys.resultHistory, encoded);
  }
}
