import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/result_entry.dart';
import '../services/result_history_service.dart';

/// A modal bottom sheet displaying FLAMES result history.
///
/// Shows a scrollable list of past results with share, delete,
/// and tap-to-load actions. Supports clear-all with confirmation.
class HistorySheet extends StatelessWidget {
  /// The list of [ResultEntry] to display.
  final List<ResultEntry> history;

  /// Service for persisting history changes.
  final ResultHistoryService historyService;

  /// Called when the user taps a history entry to load it.
  final ValueChanged<ResultEntry> onEntryTap;

  /// Called when the user taps the share button on an entry.
  final ValueChanged<ResultEntry> onShareEntry;

  const HistorySheet({
    super.key,
    required this.history,
    required this.historyService,
    required this.onEntryTap,
    required this.onShareEntry,
  });

  @override
  Widget build(BuildContext context) {
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
              _buildTitleRow(context, l10n, colorScheme),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 4),
              if (history.isEmpty)
                _buildEmptyState(l10n, colorScheme)
              else
                _buildHistoryList(context, l10n, colorScheme, scrollController),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleRow(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(Icons.history_rounded, color: colorScheme.onSurfaceVariant),
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
            onPressed: () => _onClearAll(context, l10n, colorScheme),
            icon: const Icon(Icons.delete_sweep, size: 18),
            label: Text(l10n.historyClearAll),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ColorScheme colorScheme) {
    return Expanded(
      child: Center(
        key: const ValueKey(AppConstants.emptyHistoryKey),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
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
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    ScrollController scrollController,
  ) {
    return Expanded(
      child: ListView.separated(
        controller: scrollController,
        itemCount: history.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = history[index];
          final meaning = l10n.flamesMeanings[entry.resultLetter];
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
                    color: colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  tooltip: l10n.shareTooltip,
                  onPressed: () => onShareEntry(entry),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  onPressed: () async {
                    await historyService.removeEntry(index);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              onEntryTap(entry);
            },
          );
        },
      ),
    );
  }

  Future<void> _onClearAll(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.historyClearConfirmTitle),
        content: Text(l10n.historyClearConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.historyClearCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.historyClearConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await historyService.clearHistory();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  static String _formatTimestamp(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return l10n.timestampJustNow;
    if (diff.inHours < 1) return l10n.timestampMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.timestampHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timestampDaysAgo(diff.inDays);

    return l10n.dateFormat(dt);
  }
}
