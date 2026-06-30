// Localization strings for the FLAMES Love Game.
//
// Provides English and Filipino translations for all user-facing
// strings in the app.
import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

/// Delegate for loading [AppLocalizations] based on locale.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'fil':
        return AppLocalizationsFil();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// Base class for FLAMES app localizations.
///
/// Subclasses provide translations for all user-facing strings.
/// Uses a static registry pattern so strings can be resolved
/// without requiring a [BuildContext] in non-widget code.
abstract class AppLocalizations {
  /// The locales this app supports.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fil'),
  ];

  /// Convenience method to look up localizations from context.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsEn();
  }

  // ── App metadata ──

  /// The application title.
  String get appTitle;

  /// Subtitle below the header.
  String get headerSubtitle;

  /// The three-letter language code for the current locale.
  String get languageCode;

  // ── Input fields ──

  /// Label for the first name field.
  String get labelName1;

  /// Hint text for the first name field.
  String get hintName1;

  /// Label for the second name field.
  String get labelName2;

  /// Hint text for the second name field.
  String get hintName2;

  /// Validation message for empty fields.
  String get validationEmpty;

  // ── Buttons ──

  /// Calculate button label.
  String get buttonCalculate;

  /// Try Again button label.
  String get buttonTryAgain;

  /// Share button label.
  String get buttonShare;

  // ── History strings ──

  /// History sheet title.
  String get historyTitle;

  /// Clear all button text.
  String get historyClearAll;

  /// Confirmation dialog title for clearing history.
  String get historyClearConfirmTitle;

  /// Confirmation dialog body for clearing history.
  String get historyClearConfirmBody;

  /// Cancel button in the clear history confirmation dialog.
  String get historyClearCancel;

  /// Confirm action button in the clear history dialog.
  String get historyClearConfirmAction;

  /// Empty state: no results yet.
  String get historyEmptyTitle;

  /// Empty state: prompt to calculate first result.
  String get historyEmptySubtitle;

  /// Share result tooltip.
  String get shareTooltip;

  // ── Timestamp format strings ──

  /// "Just now" for timestamps under 1 minute.
  String get timestampJustNow;

  /// "Xm ago" for timestamps in minutes.
  String timestampMinutesAgo(int minutes);

  /// "Xh ago" for timestamps in hours.
  String timestampHoursAgo(int hours);

  /// "Xd ago" for timestamps in days.
  String timestampDaysAgo(int days);

  // ── Date formatting ──

  /// Formats a date for display (used for entries older than 7 days).
  String dateFormat(DateTime date);

  // ── Tooltips ──

  /// Random name generator tooltip.
  String get randomNameTooltip;

  /// History button tooltip.
  String get historyTooltip;

  /// Light mode toggle tooltip.
  String get lightModeTooltip;

  /// Dark mode toggle tooltip.
  String get darkModeTooltip;

  // ── FLAMES legend labels ──

  /// FLAMES legend item labels, keyed by letter.
  Map<String, String> get legendLabels;

  // ── FLAMES meanings ──

  /// FLAMES meanings with localized labels and descriptions.
  ///
  /// Structure: { letter: { label, emoji, description, color } }
  Map<String, Map<String, String>> get flamesMeanings;

  // ── Share text ──

  /// Creates the share text for a FLAMES result.
  String shareResultText(String name1, String name2, String letter,
      String label, String emoji, String description);

  // ── Locale switch ──

  /// Label for switching to Filipino locale.
  String get switchToFilipino;

  /// Label for switching to English locale.
  String get switchToEnglish;
}
