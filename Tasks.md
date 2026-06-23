# FLAMES Love Game — Tasks

> Active work items. Check off as completed.

## Current Sprint

### Polish & UX
- [ ] Add animated transition when result card appears (fade + scale)
- [ ] Add haptic feedback on "Calculate" tap
- [ ] Improve empty-state UI (legend looks nicer, maybe a prompt)
- [ ] Add input clearing "X" button in text fields
- [ ] Add subtle particle/heart animation on result reveal

### Testing
- [ ] Add widget tests for HomeScreen (form validation, result display)
- [ ] Add widget test for ResultCard rendering
- [ ] Add test for non-ASCII characters (e.g., ñ, ü)
- [ ] Add test for duplicate letters in names

### Code Quality
- [ ] Run `dart analyze` — 0 issues ✓
- [ ] Extract magic strings into constants
- [ ] Add doc comments to all public methods
- [ ] Audit color contrast ratios (WCAG AA)
- [ ] Add input max length enforcement

### Infrastructure
- [ ] Add `.github/workflows/ci.yml` (analyze + test)
- [ ] Add `flutter build apk --release` to CI
- [ ] Set up Firebase Hosting for web build
- [ ] Create app icon (at least adaptive Android icon)

## Backlog
- [ ] Result history with local storage (shared_preferences)
- [ ] Share sheet integration (share_plus)
- [ ] Sound effects (flutter_beep or audioplayers)
- [ ] Dark theme toggle
- [ ] i18n: English + Filipino locale
- [ ] Random name generator
- [ ] Splash screen (flutter_native_splash)
