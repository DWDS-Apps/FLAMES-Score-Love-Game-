import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_constants.dart';
import 'screens/home_screen.dart';

/// Entry point for the FLAMES Love Game application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlamesApp());
}

/// Root widget for the FLAMES Love Game.
///
/// Configures Material 3 theming with a pink/love color scheme
/// and supports both light and dark theme modes with persistent preference.
class FlamesApp extends StatefulWidget {
  /// Creates the root application widget.
  const FlamesApp({super.key});

  @override
  State<FlamesApp> createState() => _FlamesAppState();
}

class _FlamesAppState extends State<FlamesApp> {
  bool _useDarkMode = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  /// Loads the saved dark mode preference from local storage.
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useDarkMode = prefs.getBool('darkMode') ?? false;
      _initialized = true;
    });
  }

  /// Toggles dark mode and persists the preference.
  Future<void> _toggleDarkMode() async {
    final newValue = !_useDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', newValue);
    setState(() {
      _useDarkMode = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a splash-like empty container until preference is loaded
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
      ),
    );
  }
}
