import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/flames_game.dart';
import '../widgets/heart_particles.dart';
import '../widgets/result_card.dart';

/// The main screen of the FLAMES Love Game.
///
/// Displays the FLAMES legend, input form for two names, and the result card
/// with an animated reveal and celebratory heart particles.
class HomeScreen extends StatefulWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

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

  /// Clears the first name field.
  void _clearName1() {
    _name1Controller.clear();
  }

  /// Clears the second name field.
  void _clearName2() {
    _name2Controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Header
              Icon(
                Icons.favorite_rounded,
                size: 48,
                color: Colors.pink.shade300,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.headerTitle,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.pink.shade700,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.headerSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),

              // Legend: FLAMES letters
              _buildFlamesLegend(),
              const SizedBox(height: 28),

              // Form or Result
              if (_resultLetter == null) _buildForm(),
              if (_resultLetter != null) _buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the FLAMES legend row with letter, emoji, and label.
  Widget _buildFlamesLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: AppConstants.legendItems.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
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
                  color: Colors.pink.shade600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item.$2,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Builds the input form with name fields, heart icon, and calculate button.
  Widget _buildForm() {
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
              suffixIcon: _name1Controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _clearName1();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
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
              color: Colors.pink.shade200,
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
              suffixIcon: _name2Controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _clearName2();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
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
                backgroundColor: Colors.pink.shade500,
                foregroundColor: Colors.white,
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
  Widget _buildResult() {
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
                  heartColor: Colors.pink.shade200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Try again button
        SizedBox(
          width: double.infinity,
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
              foregroundColor: Colors.pink.shade500,
              side: BorderSide(color: Colors.pink.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
