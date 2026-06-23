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

  /// Shares the current result via the system share sheet.
  void _shareResult() {
    _audioService.playButtonTap();
    if (_resultLetter == null || _name1 == null || _name2 == null) return;

    final l10n = AppLocalizations.of(context);
    final meaning = _getLocalizedMeaning(_resultLetter!);
    if (meaning == null) return;

    final text = l10n.shareResultText(
      _name1!,
      _name2!,
      _resultLetter!,
      meaning['label']!,
      meaning['emoji']!,
      meaning['description']!,
    );

    Share.share(text.trim());
  }

  /// Shares a history [entry] via the system share sheet.
  void _shareEntry(ResultEntry entry) {
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

    Share.share(text.trim());
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
    final random = Random();
    return AppConstants.sampleNames[random.nextInt(AppConstants.sampleNames.length)];
  }

  /// Fills the first name field with a random name.
  void _fillRandomName1() {
    _audioService.playButtonTap();
    _name1Controller.text = _randomName();
    setState(() {});
  }

  /// Fills the second name field with a random name.
  void _fillRandomName2() {
    _audioService.playButtonTap();
    _name2Controller.text = _randomName();
    setState(() {});
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
      builder: (sheetContext) {
        return _buildHistorySheet(sheetContext, history);
      },
    );
  }

  /// Builds the history bottom sheet content.
  Widget _buildHistorySheet(BuildContext context, List<ResultEntry> history) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      key: const ValueKey(AppConstants.historySheetKey),
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title row
              Row(
                children: [
                  Icon(Icons.history_rounded,
                      color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    l10n.historyTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (history.isNotEmpty)
                    TextButton.icon(
                      key: const ValueKey(AppConstants.clearHistoryButtonKey),
                      onPressed: () async {
                        await _historyService.clearHistory();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_sweep, size: 18),
                      label: Text(l10n.historyClearAll),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 4),

              // History list
              if (history.isEmpty)
                Expanded(
                  child: Center(
                    key: const ValueKey(AppConstants.emptyHistoryKey),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 48,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.historyEmptyTitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.historyEmptySubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      final meaning =
                          _getLocalizedMeaning(entry.resultLetter);
                      final emoji = meaning?['emoji'] ?? '';
                      final label = meaning?['label'] ?? entry.resultLetter;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            entry.resultLetter,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        title: Text(
                          '${entry.name1} ♥ ${entry.name2}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '$emoji $label  •  ${_formatTimestamp(entry.timestamp, l10n)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.share_rounded,
                                size: 18,
                                color: colorScheme.primary
                                    .withValues(alpha: 0.7),
                              ),
                              tooltip: l10n.shareTooltip,
                              onPressed: () {
                                _shareEntry(entry);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                              onPressed: () async {
                                await _historyService.removeEntry(index);
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Load the history entry's names
                          Navigator.of(context).pop();
                          _name1Controller.text = entry.name1;
                          _name2Controller.text = entry.name2;
                          _calculate();
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Formats a timestamp to a short, readable string using localized strings.
  String _formatTimestamp(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return l10n.timestampJustNow;
    if (diff.inHours < 1) return l10n.timestampMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.timestampHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timestampDaysAgo(diff.inDays);

    // Otherwise show date
    return '${dt.month}/${dt.day}/${dt.year}';
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
              const SizedBox(height: 32),

              // Header row with theme toggle and locale toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
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
                  const Spacer(),
                  // History, locale, and dark mode toggle buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: const ValueKey(AppConstants.historyButtonKey),
                          icon: const Icon(Icons.history_rounded),
                          tooltip: l10n.historyTooltip,
                          onPressed: _showHistory,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        // Locale toggle button
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
                  ),
                ],
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
      label: 'FLAMES legend',
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
          TextFormField(
            key: const ValueKey(AppConstants.name1FieldKey),
            controller: _name1Controller,
            textCapitalization: TextCapitalization.words,
            maxLength: AppConstants.maxNameLength,
            decoration: InputDecoration(
              labelText: l10n.labelName1,
              hintText: l10n.hintName1,
              prefixIcon: const Icon(Icons.person),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey(AppConstants.name1RandomKey),
                    icon: const Icon(Icons.shuffle, size: 18),
                    tooltip: l10n.randomNameTooltip,
                    onPressed: _fillRandomName1,
                  ),
                  if (_name1Controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _clearName1();
                        setState(() {});
                      },
                    ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              counterText: '', // Hide character counter
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validationEmpty;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
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
          TextFormField(
            key: const ValueKey(AppConstants.name2FieldKey),
            controller: _name2Controller,
            textCapitalization: TextCapitalization.words,
            maxLength: AppConstants.maxNameLength,
            decoration: InputDecoration(
              labelText: l10n.labelName2,
              hintText: l10n.hintName2,
              prefixIcon: const Icon(Icons.favorite_border),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey(AppConstants.name2RandomKey),
                    icon: const Icon(Icons.shuffle, size: 18),
                    tooltip: l10n.randomNameTooltip,
                    onPressed: _fillRandomName2,
                  ),
                  if (_name2Controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _clearName2();
                        setState(() {});
                      },
                    ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validationEmpty;
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _calculate(),
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
      label: 'FLAMES calculation result',
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
