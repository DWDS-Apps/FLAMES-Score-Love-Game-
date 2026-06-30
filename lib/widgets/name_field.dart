import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

/// A text form field for entering a name with shuffle and clear buttons.
///
/// Shows a text input with a prefix icon, a shuffle (random) button,
/// and a clear button that appears when the field has text.
class NameField extends StatelessWidget {
  /// Unique key string for widget testing.
  final String fieldKey;

  /// Controller for the text field.
  final TextEditingController controller;

  /// Label text displayed above the field.
  final String labelText;

  /// Hint text displayed inside the field when empty.
  final String hintText;

  /// Icon shown at the start of the field.
  final IconData prefixIcon;

  /// Key for the shuffle button (for testing).
  final String randomKey;

  /// Called when the shuffle button is pressed.
  final VoidCallback onRandom;

  /// Called when the clear button is pressed.
  final VoidCallback onClear;

  /// The type of action button to show on the keyboard.
  final TextInputAction textInputAction;

  /// Called when the user submits the field (e.g., presses done).
  final void Function(String)? onFieldSubmitted;

  /// Called when the field text changes.
  final void Function(String)? onChanged;

  /// The current color scheme from the theme.
  final ColorScheme colorScheme;

  /// Localization instance for translated strings.
  final AppLocalizations l10n;

  /// Creates a name input field.
  const NameField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.randomKey,
    required this.onRandom,
    required this.onClear,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    required this.colorScheme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(fieldKey),
      controller: controller,
      textCapitalization: TextCapitalization.words,
      maxLength: AppConstants.maxNameLength,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: ValueKey(randomKey),
              icon: const Icon(Icons.shuffle, size: 18),
              tooltip: l10n.randomNameTooltip,
              onPressed: onRandom,
            ),
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  onClear();
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
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
    );
  }
}
