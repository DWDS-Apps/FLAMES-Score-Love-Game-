# FLAMES Love Game Documentation

## Overview

FLAMES Love Game is a fun name-based compatibility calculator built with Flutter. It implements the classic FLAMES algorithm: Friends, Lovers, Affection, Marriage, Enemy, Siblings.

## Project Structure

```
flames_love_game/
├── lib/
│   ├── main.dart                    # App entry point & theming
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   ├── models/
│   │   └── flames_game.dart         # FLAMES algorithm implementation
│   ├── screens/
│   │   └── home_screen.dart         # Main screen with form & result
│   └── widgets/
│       ├── heart_particles.dart     # Floating heart particle animation
│       └── result_card.dart         # Result display card widget
├── test/
│   ├── flames_game_test.dart        # Unit tests for the algorithm
│   └── widget_test.dart             # Widget tests for UI components
└── pubspec.yaml
```

## Features

- **FLAMES Algorithm**: Calculates compatibility based on name letter matching
- **Animated Results**: Fade + scale transitions when the result appears
- **Haptic Feedback**: Physical feedback on calculation
- **Heart Particles**: Celebratory floating hearts on result reveal
- **Input Validation**: Empty field validation with inline errors
- **Clear Buttons**: X buttons to quickly clear input fields
- **Max Length**: Names limited to 50 characters
- **Material 3**: Pink-themed Material Design 3 UI

## Local Development

```bash
cd flames_love_game
flutter pub get
dart analyze lib/     # Static analysis
flutter test          # Run all tests
flutter run           # Launch app
```

## Building

```bash
# Android release APK
flutter build apk --release

# Web build
flutter build web
```
