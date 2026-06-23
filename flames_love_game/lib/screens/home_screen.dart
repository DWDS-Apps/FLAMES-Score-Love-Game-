import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../models/flames_game.dart';
import '../models/result_entry.dart';
import '../services/result_history_service.dart';
import '../widgets/heart_particles.dart';
import '../widgets/result_card.dart';

/// The main screen of the FLAMES Love Game.
///
/// Displays the FLAMES legend, input form for two names, and the result card
/// with an animated reveal and celebratory heart particles.
class HomeScreen extends StatefulWidget {
  /// Whether dark mode is currently active.
  final bool isDarkMode;

  /// Callback invoked when the user toggles dark mode.
  final VoidCallback onToggleDarkMode;

  /// Creates the home screen.
  const HomeScreen({
    super.key,
    this.isDarkMode = false,
    required this.onToggleDarkMode,
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
  }

  /// Resets the form and result state.
  void _reset() {
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
    if (_resultLetter == null || _name1 == null || _name2 == null) return;

    final meaning = FlamesGame.getMeaning(_resultLetter!);
    if (meaning == null) return;

    final text = '''
💕 FLAMES Love Game Result 💕

$_name1 ♥ $_name2

Result: $_resultLetter — ${meaning['label']} ${meaning['emoji']}

${meaning['description']}

━━━━━━━━━━━━━━━━━━━━━━━
Made with FLAMES Love Game ❤️''';

    Share.share(text.trim());
  }

  /// Shares a history [entry] via the system share sheet.
  void _shareEntry(ResultEntry entry) {
    final meaning = FlamesGame.getMeaning(entry.resultLetter);
    if (meaning == null) return;

    final text = '''
💕 FLAMES Love Game Result 💕

${entry.name1} ♥ ${entry.name2}

Result: ${entry.resultLetter} — ${meaning['label']} ${meaning['emoji']}

${meaning['description']}

━━━━━━━━━━━━━━━━━━━━━━━
Made with FLAMES Love Game ❤️''';

    Share.share(text.trim());
  }

  /// Clears the first name field.
  void _clearName1() {
    _name1Controller.clear();
  }

  /// Clears the second name field.
  void _clearName2() {
    _name2Controller.clear();
  }

  /// Picks a random name from the sample list.
  String _randomName() {
    final random = Random();
    return AppConstants.sampleNames[random.nextInt(AppConstants.sampleNames.length)];
  }

  /// Fills the first name field with a random name.
  void _fillRandomName1() {
    _name1Controller.text = _randomName();
    setState(() {});
  }

  /// Fills the second name field with a random name.
  void _fillRandomName2() {
    _name2Controller.text = _randomName();
    setState(() {});
  }

  /// Shows a modal bottom sheet with the result history.
  Future<void> _showHistory() async {
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
                    'Result History',
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
                      label: const Text('Clear all'),
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
                          'No results yet!',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Calculate your first FLAMES result.',
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
                          FlamesGame.getMeaning(entry.resultLetter);
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
                          '$emoji $label  •  ${_formatTimestamp(entry.timestamp)}',
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
                              tooltip: 'Share result',
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

  /// Formats a timestamp to a short, readable string.
  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    // Otherwise show date
    return '${dt.month}/${dt.day}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Header row with theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        size: 48,
                        color: colorScheme.primary.withValues(alpha: 0.7),
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
                        AppConstants.headerSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Dark mode toggle and history buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: const ValueKey(AppConstants.historyButtonKey),
                          icon: const Icon(Icons.history_rounded),
                          tooltip: 'Result history',
                          onPressed: _showHistory,
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
                              ? 'Switch to light mode'
                              : 'Switch to dark mode',
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
              _buildFlamesLegend(colorScheme),
              const SizedBox(height: 28),

              // Form or Result
              if (_resultLetter == null) _buildForm(colorScheme),
              if (_resultLetter != null) _buildResult(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the FLAMES legend row with letter, emoji, and label.
  Widget _buildFlamesLegend(ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: AppConstants.legendItems.map((item) {
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
                item.$2,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Builds the input form with name fields, heart icon, and calculate button.
  Widget _buildForm(ColorScheme colorScheme) {
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
              labelText: AppConstants.labelName1,
              hintText: AppConstants.hintName1,
              prefixIcon: const Icon(Icons.person),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey(AppConstants.name1RandomKey),
                    icon: const Icon(Icons.shuffle, size: 18),
                    tooltip: 'Random name',
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
                return AppConstants.validationEmpty;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // Heart icon between fields
          Center(
            child: Icon(
              Icons.favorite,
              size: 28,
              color: colorScheme.primary.withValues(alpha: 0.5),
              key: const ValueKey(AppConstants.heartIconKey),
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
              labelText: AppConstants.labelName2,
              hintText: AppConstants.hintName2,
              prefixIcon: const Icon(Icons.favorite_border),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey(AppConstants.name2RandomKey),
                    icon: const Icon(Icons.shuffle, size: 18),
                    tooltip: 'Random name',
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
                return AppConstants.validationEmpty;
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome),
                  SizedBox(width: 8),
                  Text(
                    AppConstants.buttonCalculate,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
  Widget _buildResult(ColorScheme colorScheme) {
    return Column(
      children: [
        // Heart particles overlay
        SizedBox(
          height: 380,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated result card
              FadeTransition(
                opacity: _resultFade,
                child: ScaleTransition(
                  scale: _resultScale,
                  child: ResultCard(
                    key: const ValueKey(AppConstants.resultCardKey),
                    letter: _resultLetter!,
                    name1: _name1!,
                    name2: _name2!,
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
                  label: const Text(
                    AppConstants.buttonTryAgain,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  label: const Text(
                    AppConstants.buttonShare,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }
}
