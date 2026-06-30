import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/flames_game.dart';
import '../models/result_entry.dart';
import '../services/audio_service.dart';
import '../services/result_history_service.dart';
import '../widgets/heart_particles.dart';
import '../widgets/history_sheet.dart';
import '../widgets/name_field.dart';
import '../widgets/result_card.dart';

/// The main screen of the FLAMES Love Game.
///
/// Displays the FLAMES legend, input form for two names, and the result card
/// with an animated reveal, celebratory heart particles, and sound effects.
/// Supports English and Filipino localization with a persistent toggle.
class HomeScreen extends StatefulWidget {
  /// Whether dark mode is currently active.
  final bool isDarkMode;

  /// Callback invoked when the user toggles dark mode.
  final VoidCallback onToggleDarkMode;

  /// The current locale for localization.
  final Locale locale;

  /// Callback invoked when the user toggles the locale.
  final VoidCallback onToggleLocale;

  /// Creates the home screen.
  const HomeScreen({
    super.key,
    this.isDarkMode = false,
    required this.onToggleDarkMode,
    required this.locale,
    required this.onToggleLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _name1Controller = TextEditingController();
  final _name2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _resultLetter;
  String? _name1;
  String? _name2;
  final _historyService = ResultHistoryService();
  final _audioService = AudioService.instance;
  final _random = Random();

  late final AnimationController _resultController;
  late final Animation<double> _resultScale;
  late final Animation<double> _resultFade;

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.resultFadeInMs),
    );
    _resultScale = CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    );
    _resultFade = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _name1Controller.dispose();
    _name2Controller.dispose();
    _resultController.dispose();
    super.dispose();
  }

  /// Returns the localized meaning for a FLAMES letter.
  Map<String, String>? _getLocalizedMeaning(String letter) {
    return AppLocalizations.of(context).flamesMeanings[letter];
  }

  /// Validates inputs, calculates FLAMES result, and triggers animations.
  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    // Haptic feedback on calculation
    HapticFeedback.mediumImpact();

    final name1 = _name1Controller.text;
    final name2 = _name2Controller.text;

    setState(() {
      _resultLetter = FlamesGame.calculate(name1, name2);
      _name1 = name1;
      _name2 = name2;
    });

    // Save to history (fire-and-forget)
    if (_resultLetter != null && _resultLetter!.isNotEmpty) {
      _historyService.saveEntry(
        ResultEntry(
          name1: name1,
          name2: name2,
          resultLetter: _resultLetter!,
          timestamp: DateTime.now(),
        ),
      );
    }

    // Animate result entrance
    _resultController.forward(from: 0);

    // Play reveal sound effect
    _audioService.playReveal();
  }

  /// Resets the form and result state.
  void _reset() {
    _audioService.playButtonTap();
    _resultController.reset();
    setState(() {
      _resultLetter = null;
      _name1 = null;
      _name2 = null;
    });
    _name1Controller.clear();
    _name2Controller.clear();
  }

  /// Shares a result [entry] via the system share sheet.
  Future<void> _shareEntry(ResultEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final meaning = _getLocalizedMeaning(entry.resultLetter);
    if (meaning == null) return;

    final text = l10n.shareResultText(
      entry.name1,
      entry.name2,
      entry.resultLetter,
      meaning['label']!,
      meaning['emoji']!,
      meaning['description']!,
    );

    try {
      await SharePlus.instance.share(ShareParams(text: text.trim()));
    } catch (_) {}
  }

  /// Shares the current result via the system share sheet.
  Future<void> _shareResult() async {
    _audioService.playButtonTap();
    if (_resultLetter == null || _name1 == null || _name2 == null) return;
    await _shareEntry(ResultEntry(
      name1: _name1!,
      name2: _name2!,
      resultLetter: _resultLetter!,
      timestamp: DateTime.now(),
    ));
  }

  /// Clears the first name field.
  void _clearName1() {
    _audioService.playTap();
    _name1Controller.clear();
  }

  /// Clears the second name field.
  void _clearName2() {
    _audioService.playTap();
    _name2Controller.clear();
  }

  /// Picks a random name from the sample list.
  String _randomName() {
    return AppConstants
        .sampleNames[_random.nextInt(AppConstants.sampleNames.length)];
  }

  /// Fills the first name field with a random name.
  void _fillRandomName1() {
    _audioService.playButtonTap();
    _name1Controller.text = _randomName();
  }

  /// Fills the second name field with a random name.
  void _fillRandomName2() {
    _audioService.playButtonTap();
    _name2Controller.text = _randomName();
  }

  /// Shows a modal bottom sheet with the result history.
  Future<void> _showHistory() async {
    _audioService.playButtonTap();
    final history = await _historyService.getHistory();

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => HistorySheet(
        history: history,
        historyService: _historyService,
        onEntryTap: (entry) {
          _name1Controller.text = entry.name1;
          _name2Controller.text = entry.name2;
          _calculate();
        },
        onShareEntry: _shareEntry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Top bar with history, locale, and theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    key: const ValueKey(AppConstants.historyButtonKey),
                    icon: const Icon(Icons.history_rounded),
                    tooltip: l10n.historyTooltip,
                    onPressed: _showHistory,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Text(
                      widget.locale.languageCode.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    tooltip: widget.locale.languageCode == 'en'
                        ? l10n.switchToFilipino
                        : l10n.switchToEnglish,
                    onPressed: widget.onToggleLocale,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      widget.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    tooltip: widget.isDarkMode
                        ? l10n.lightModeTooltip
                        : l10n.darkModeTooltip,
                    onPressed: widget.onToggleDarkMode,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Header
              Semantics(
                header: true,
                label: AppConstants.headerSemanticsTitle,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      excludeSemantics: true,
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 48,
                        color: colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.headerTitle,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.headerSubtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Legend: FLAMES letters
              _buildFlamesLegend(colorScheme, l10n),
              const SizedBox(height: 28),

              // Form or Result
              if (_resultLetter == null) _buildForm(colorScheme, l10n),
              if (_resultLetter != null) _buildResult(colorScheme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the FLAMES legend row with letter, emoji, and localized label.
  Widget _buildFlamesLegend(ColorScheme colorScheme, AppLocalizations l10n) {
    return Semantics(
      label: AppConstants.legendSemanticsLabel,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: AppConstants.legendItems.map((item) {
          final localizedLabel = l10n.legendLabels[item.$1] ?? item.$2;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.$3, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  item.$1,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  localizedLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the input form with name fields, heart icon, and calculate button.
  Widget _buildForm(ColorScheme colorScheme, AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name 1
          NameField(
            fieldKey: AppConstants.name1FieldKey,
            controller: _name1Controller,
            labelText: l10n.labelName1,
            hintText: l10n.hintName1,
            prefixIcon: Icons.person,
            randomKey: AppConstants.name1RandomKey,
            onRandom: _fillRandomName1,
            onClear: _clearName1,
            textInputAction: TextInputAction.next,
            colorScheme: colorScheme,
            l10n: l10n,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // Heart icon between fields
          Semantics(
            excludeSemantics: true,
            child: Center(
              child: Icon(
                Icons.favorite,
                size: 28,
                color: colorScheme.primary.withValues(alpha: 0.5),
                key: const ValueKey(AppConstants.heartIconKey),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Name 2
          NameField(
            fieldKey: AppConstants.name2FieldKey,
            controller: _name2Controller,
            labelText: l10n.labelName2,
            hintText: l10n.hintName2,
            prefixIcon: Icons.favorite_border,
            randomKey: AppConstants.name2RandomKey,
            onRandom: _fillRandomName2,
            onClear: _clearName2,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _calculate(),
            colorScheme: colorScheme,
            l10n: l10n,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),

          // Calculate button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              key: const ValueKey(AppConstants.calculateButtonKey),
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome),
                  const SizedBox(width: 8),
                  Text(
                    l10n.buttonCalculate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Builds the animated result section with heart particles.
  Widget _buildResult(ColorScheme colorScheme, AppLocalizations l10n) {
    return Semantics(
      label: AppConstants.resultSemanticsLabel,
      child: Column(
        children: [
          // Heart particles overlay
          SizedBox(
            height: 380,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated result card
                MergeSemantics(
                  child: FadeTransition(
                    opacity: _resultFade,
                    child: ScaleTransition(
                      scale: _resultScale,
                      child: ResultCard(
                        key: const ValueKey(AppConstants.resultCardKey),
                        letter: _resultLetter!,
                        name1: _name1!,
                        name2: _name2!,
                        getMeaning: _getLocalizedMeaning,
                      ),
                    ),
                  ),
                ),
                // Floating heart particles
                IgnorePointer(
                  child: HeartParticles(
                    heartColor: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons: Try Again + Share
          Row(
            children: [
              // Try Again button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    key: const ValueKey(AppConstants.tryAgainButtonKey),
                    onPressed: _reset,
                    icon: const Icon(Icons.replay),
                    label: Text(
                      l10n.buttonTryAgain,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(
                        color: colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Share button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    key: const ValueKey(AppConstants.shareButtonKey),
                    onPressed: _shareResult,
                    icon: const Icon(Icons.share_rounded),
                    label: Text(
                      l10n.buttonShare,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
