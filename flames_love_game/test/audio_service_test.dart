import 'package:flutter_test/flutter_test.dart';
import 'package:flames_love_game/services/audio_service.dart';
import 'package:flutter/services.dart';

void main() {
  // Initialize the test binding so we can mock platform channels.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AudioService service;

  setUp(() {
    // Mock the platform channel for audioplayers so it doesn't throw
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async {
        return null; // Silently succeed
      },
    );
    service = AudioService.instance;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      null,
    );
  });

  test('is a singleton', () {
    final another = AudioService.instance;
    expect(identical(service, another), isTrue);
  });

  test('playTap does not throw', () async {
    await expectLater(service.playTap(), completes);
  });

  test('playReveal does not throw', () async {
    await expectLater(service.playReveal(), completes);
  });

  test('playButtonTap does not throw', () async {
    await expectLater(service.playButtonTap(), completes);
  });

  test('play(SoundEffect) does not throw for any effect', () async {
    for (final effect in SoundEffect.values) {
      await expectLater(service.play(effect), completes);
    }
  });

  test('dispose does not throw', () async {
    // Call play first to create player instances
    await service.playTap();
    await service.playReveal();
    await service.playButtonTap();
    await expectLater(service.dispose(), completes);
  });

  test('multiple consecutive plays do not throw', () async {
    for (var i = 0; i < 5; i++) {
      await service.playTap();
      await service.playReveal();
      await service.playButtonTap();
    }
  });
}
