import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that renders floating, fading heart particles.
///
/// Creates [particleCount] hearts that rise and fade out over
/// [particleDuration]. Useful as a celebratory effect on result reveal.
class HeartParticles extends StatefulWidget {
  /// Number of heart particles to display.
  final int particleCount;

  /// Duration each particle lives before disappearing.
  final Duration particleDuration;

  /// The color of the hearts.
  final Color heartColor;

  const HeartParticles({
    super.key,
    this.particleCount = 12,
    this.particleDuration = const Duration(milliseconds: 2000),
    this.heartColor = Colors.pink,
  });

  @override
  State<HeartParticles> createState() => _HeartParticlesState();
}

class _HeartParticlesState extends State<HeartParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.particleDuration,
    );
    _particles = List.generate(widget.particleCount, (_) => _Particle(_random));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _HeartPainter(
            particles: _particles,
            progress: _controller.value,
            heartColor: widget.heartColor,
          ),
        );
      },
    );
  }
}

/// Data for a single heart particle.
class _Particle {
  _Particle(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = 12.0 + random.nextDouble() * 20.0,
        speed = 0.3 + random.nextDouble() * 0.7,
        sway = random.nextDouble() * 2 * pi,
        swayFreq = 0.5 + random.nextDouble() * 1.5,
        swayAmount = 10.0 + random.nextDouble() * 20.0,
        delay = random.nextDouble() * 0.5;

  final double x;
  final double y;
  final double size;
  final double speed;
  final double sway;
  final double swayFreq;
  final double swayAmount;
  final double delay;
}

/// Paints floating heart particles using a custom painter.
class _HeartPainter extends CustomPainter {
  _HeartPainter({
    required this.particles,
    required this.progress,
    required this.heartColor,
  });

  final List<_Particle> particles;
  final double progress;
  final Color heartColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      // Rise upward
      final yPos = size.height * (1 - p.y) - t * p.speed * size.height * 0.5;
      final xSway = sin(t * p.swayFreq * 2 * pi + p.sway) * p.swayAmount;
      final xPos = size.width * p.x + xSway;

      // Fade out near end
      final opacity = (1 - t) * 0.8;
      if (opacity <= 0) continue;

      // Scale up slightly then fade
      final scale = 1.0 + t * 0.5;

      canvas.save();
      canvas.translate(xPos, yPos);
      canvas.scale(scale);

      final paint = Paint()
        ..color = heartColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      _drawHeart(canvas, paint, p.size);

      canvas.restore();
    }
  }

  /// Draws a simple heart shape using a path.
  void _drawHeart(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final half = size / 2;

    // Start at bottom point
    path.moveTo(0, size);

    // Left curve
    path.cubicTo(
      -half * 1.5,
      size * 0.6,
      -half * 1.5,
      size * 0.15,
      0,
      size * 0.15,
    );

    // Right curve
    path.cubicTo(
      half * 1.5,
      size * 0.15,
      half * 1.5,
      size * 0.6,
      0,
      size,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
