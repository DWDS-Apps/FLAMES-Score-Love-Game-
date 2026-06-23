import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_constants.dart' show AppColors, AppConstants, StorageKeys;
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

/// Entry point for the FLAMES Love Game application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlamesApp());
}

/// Root widget for the FLAMES Love Game.
///
/// Configures Material 3 theming with a pink/love color scheme,
/// supports both light and dark theme modes, and provides
/// English and Filipino localization with persistent preference.
class FlamesApp extends StatefulWidget {
  /// Creates the root application widget.
  const FlamesApp({super.key});

  @override
  State<FlamesApp> createState() => _FlamesAppState();
}

class _FlamesAppState extends State<FlamesApp> {
  bool _useDarkMode = false;
  bool _initialized = false;
  Locale _locale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Loads the saved dark mode and locale preferences from local storage.
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useDarkMode = prefs.getBool(StorageKeys.darkMode) ?? false;
      final localeCode = prefs.getString(StorageKeys.locale) ?? 'en';
      _locale = localeCode == 'fil'
          ? const Locale('fil', 'PH')
          : const Locale('en', 'US');
      _initialized = true;
    });
  }

  /// Toggles dark mode and persists the preference.
  Future<void> _toggleDarkMode() async {
    final newValue = !_useDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.darkMode, newValue);
    setState(() {
      _useDarkMode = newValue;
    });
  }

  /// Toggles between English and Filipino locale and persists the preference.
  Future<void> _toggleLocale() async {
    final newLocale =
        _locale.languageCode == 'en'
            ? const Locale('fil', 'PH')
            : const Locale('en', 'US');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.locale, newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a splash-like empty container until preferences are loaded
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(AppColors.seedPink),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Icon(
              Icons.favorite_rounded,
              size: 64,
              color: Colors.pink,
            ),
          ),
        ),
      );
    }

    final brightness = _useDarkMode ? Brightness.dark : Brightness.light;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(AppColors.seedPink),
      brightness: brightness,
    );

    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppColors.seedPink),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
        ),
      ),
      themeMode: _useDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: _useDarkMode,
        onToggleDarkMode: _toggleDarkMode,
        locale: _locale,
        onToggleLocale: _toggleLocale,
      ),
    );
  }
}
