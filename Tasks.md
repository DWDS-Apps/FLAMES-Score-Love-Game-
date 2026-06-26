# FLAMES Love Game — Tasks

> Active work items. Check off as completed.

## Current Sprint

### Phase 4: Quality ✅
- [x] Integration tests (integration_test/ with full app flow)
- [x] Accessibility audit (Semantics labels, decorative exclusions, semantic grouping)
- [x] Performance profiling (tools/performance_profiling.md)
- [x] App store listing assets (assets/store_screenshots/)

### Polish & UX
- [x] Add animated transition when result card appears (fade + scale)
- [x] Add haptic feedback on "Calculate" tap
- [x] Improve empty-state UI (legend looks nicer, maybe a prompt)
- [x] Add input clearing "X" button in text fields
- [x] Add subtle particle/heart animation on result reveal
- [x] Dark theme toggle with persistent preference

### Testing
- [x] Add widget tests for HomeScreen (form validation, result display)
- [x] Add widget test for ResultCard rendering
- [x] Add test for non-ASCII characters (e.g., ñ, ü)
- [x] Add test for duplicate letters in names
- [x] Add tests for dark mode toggle
- [x] Add tests for random name generator

### Code Quality
- [x] Run `dart analyze` — 0 issues ✓
- [x] Extract magic strings into constants
- [x] Add doc comments to all public methods
- [x] Audit color contrast ratios (WCAG AA)
- [x] Add input max length enforcement

### Infrastructure
- [x] Add `.github/workflows/ci.yml` (analyze + test)
- [x] Add `flutter build apk --release` to CI

## Quality Sprint 2
- [x] Share error handling (try-catch on Share.share calls)
- [x] Clear history confirmation dialog (with EN/FIL localization)
- [x] Extract `_buildNameField` helper to eliminate duplicate TextFormField code (~70 lines saved)
- [x] Make integration tests locale-independent (ValueKey finders instead of locale-specific text)

## Code Audit & Maintenance
- [x] Remove unnecessary `library;` directives from 5 files
- [x] Extract hardcoded Semantics labels into AppConstants
- [x] Add localized dateFormat() method to AppLocalizations
- [x] Replace hardcoded date string in _formatTimestamp with localized version
- [x] Add unit tests for dateFormat in both EN and FIL locales
- [x] Run dart analyze — 0 issues ✓
- [x] All 61 tests passing ✓

## Backlog
- [x] Result history with local storage (shared_preferences)
- [x] Share sheet integration (share_plus)
- [x] Sound effects (flutter_beep or audioplayers)
- [x] i18n: English + Filipino locale
