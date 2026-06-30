# Performance Profiling Guide

Run these commands to profile the FLAMES Love Game app.

## Prerequisites

```bash
export FLUTTER_ROOT=/root/flutter  # Adjust for your environment
```

## Profile Mode Build

Builds the app in profile mode (includes performance tracing, no debug assertions):

```bash
flutter run --profile
```

## Build Performance Traces

### Android Profile Build

```bash
flutter build apk --profile
```

Run the APK on a device, then use the Flutter DevTools timeline.

### Web Profile Build

```bash
flutter build web --profile
```

## Measuring Startup Time

Run with performance metrics enabled:

```bash
flutter run --profile --trace-startup
```

This outputs a JSON trace of startup phases (time to first frame, time to
first meaningful paint, etc.) to stdout and a file like
`build/startup_info.json`.

## Frame Rate Analysis

Attach DevTools to a running profile-mode app:

```bash
flutter pub global activate devtools
flutter pub global run devtools --app-id http://127.0.0.1:9100
```

Then:
1. Open the **Performance** tab
2. Click **Record** to capture a timeline
3. Perform interactions (enter names, tap Calculate, etc.)
4. Stop recording and inspect frame build/raster times
5. Look for jank (frames > 16ms on 60Hz, > 8ms on 120Hz)

## Memory Profiling

In DevTools **Memory** tab:
1. Record a heap snapshot
2. Perform several FLAMES calculations
3. Take another snapshot and diff to find leaks
4. Check for growing `ResultHistoryService` data

## Repaint Boundaries

To debug unnecessary repaints:

```bash
flutter run --profile --trace-skia
```

Or add this line to `main.dart` temporarily:

```dart
debugRepaintRainbowEnabled = true; // shows repainted areas
```

## Lighthouse (Web)

For web builds, run Lighthouse in Chrome DevTools:

1. `flutter build web --release`
2. Serve: `python3 -m http.server 8080 -d build/web`
3. Open Chrome DevTools → Lighthouse tab
4. Run audit for Performance, Accessibility, Best Practices

## Checklist

- [ ] Startup time under 2 seconds on mid-range device
- [ ] No jank during form input
- [ ] Result reveal animation runs at 60fps
- [ ] Heart particles don't drop frames (limit to 12 particles)
- [ ] No memory leaks across 50+ calculations
- [ ] SharedPreferences history read/write completes under 100ms
