// Service for playing sound effects throughout the app.
//
// Wraps the [audioplayers] package and provides simple methods
// for playing tap, reveal, and button interaction sounds.
//
// Uses lazy initialization — the first play call creates the
// audio player instances automatically.
import 'package:audioplayers/audioplayers.dart';

/// Sound effect types available in the app.
enum SoundEffect {
  /// Short click/tap sound for UI interactions.
  tap,

  /// Ascending chime played when a FLAMES result is revealed.
  reveal,

  /// Soft tap for general button presses.
  buttonTap,
}

/// Service that manages sound effect playback.
///
/// Designed as a simple utility class with a shared instance.
/// Plays WAV assets bundled under `assets/sounds/`.
class AudioService {
  /// The shared singleton instance.
  static final AudioService instance = AudioService._();

  AudioService._();

  // Cache audio players by effect to reuse them.
  final Map<SoundEffect, AudioPlayer> _players = {};

  /// Audio asset path for each sound effect.
  static const _assetPaths = {
    SoundEffect.tap: 'sounds/tap.wav',
    SoundEffect.reveal: 'sounds/reveal.wav',
    SoundEffect.buttonTap: 'sounds/button_tap.wav',
  };

  /// Retrieves or creates an [AudioPlayer] for the given [effect].
  AudioPlayer _playerFor(SoundEffect effect) {
    if (!_players.containsKey(effect)) {
      _players[effect] = AudioPlayer();
    }
    return _players[effect]!;
  }

  /// Plays a sound effect once.
  ///
  /// If a previous instance of the same [effect] is still playing,
  /// it will be stopped and restarted.
  Future<void> play(SoundEffect effect) async {
    try {
      final player = _playerFor(effect);
      await player.stop();
      await player.play(AssetSource(_assetPaths[effect]!));
    } catch (_) {
      // Silently ignore audio errors — sound is non-critical.
    }
  }

  /// Plays the tap sound effect.
  Future<void> playTap() => play(SoundEffect.tap);

  /// Plays the reveal (result) sound effect.
  Future<void> playReveal() => play(SoundEffect.reveal);

  /// Plays the button tap sound effect.
  Future<void> playButtonTap() => play(SoundEffect.buttonTap);

  /// Disposes all cached audio players.
  ///
  /// Call when the app is shutting down to free resources.
  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}
