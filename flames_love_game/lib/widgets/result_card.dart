import 'package:flutter/material.dart';
import '../models/flames_game.dart';

/// A card that displays the FLAMES calculation result.
///
/// Shows the result letter in a large circle, the meaning (emoji + label),
/// a description, and the two names that were compared.
class ResultCard extends StatelessWidget {
  /// The FLAMES result letter (F, L, A, M, E, or S).
  final String letter;

  /// The first name entered by the user.
  final String name1;

  /// The second name entered by the user.
  final String name2;

  /// Creates a result card with the given [letter], [name1], and [name2].
  const ResultCard({
    super.key,
    required this.letter,
    required this.name1,
    required this.name2,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final meaning = FlamesGame.getMeaning(letter);
    if (meaning == null) return const SizedBox.shrink();

    final color = Color(int.parse(meaning['color']!));

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Big result letter in a circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
                border: Border.all(color: color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Emoji + Label
            Text(
              '${meaning['emoji']}  ${meaning['label']}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              meaning['description']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // The two names with a heart between them
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.favorite,
                      size: 18,
                      color: colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    name2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
