import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'screens/home_screen.dart';

/// Entry point for the FLAMES Love Game application.
void main() {
  runApp(const FlamesApp());
}

/// Root widget for the FLAMES Love Game.
///
/// Configures Material 3 theming with a pink/love color scheme.
class FlamesApp extends StatelessWidget {
  /// Creates the root application widget.
  const FlamesApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const HomeScreen(),
    );
  }
}
