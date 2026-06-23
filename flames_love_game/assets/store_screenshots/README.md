# App Store Listing Assets

This directory contains assets for Google Play Store and Apple App Store listings.

## Required Screenshots

| Platform | Orientation | Size | Count |
|----------|-------------|------|-------|
| Android  | Phone       | 1080×1920 px | 4-8 |
| Android  | Tablet (optional) | 1920×1080 px | 2-4 |
| iOS      | Phone       | 1242×2688 px (6.5") | 4-6 |
| iOS      | Phone       | 1242×2208 px (5.5") | 4-6 |

## Screenshot Content Plan

1. **Splash/Intro** — App launch with FLAMES logo
2. **Name Entry** — Two text fields with "Alice ♥ Bob" filled in
3. **Result Reveal** — Result card showing "L — Lovers 💕" with heart particles
4. **Dark Mode** — Same result in dark theme
5. **History Sheet** — Bottom sheet showing saved results
6. **Filipino Locale** — Name entry in Filipino (optional)

## How to Generate

On a real device/emulator:

```bash
flutter run --release
```

Then take screenshots using:
- **Android**: `adb shell screencap /sdcard/screenshot.png && adb pull /sdcard/screenshot.png`
- **iOS**: Cmd+S in Simulator, or use `xcrun simctl screenshot`

## Description Snippets

### English

> FLAMES Love Game — the classic name-based compatibility calculator!
> Enter two names and discover your FLAMES result: Friends, Lovers,
> Affection, Marriage, Enemy, or Siblings. Features fun heart animations,
> sound effects, and result history. Available in English and Filipino!

### Filipino

> FLAMES Larong Pag-ibig — ang klasikong laro ng compatibility!
> Ilagay ang dalawang pangalan at alamin ang inyong FLAMES resulta:
> Magkaibigan, Magkasintahan, Pagmamahal, Kasal, Kaaway, o Magkapatid.
> May masasayang heart animations, sound effects, at history ng resulta!
