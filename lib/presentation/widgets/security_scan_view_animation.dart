import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Security-scanning radar: rotating sweep beam + pulsing rings.
/// Driven by a vsync Ticker, so it runs at the display refresh rate (60/120).
class SecurityScanViewAnimation extends StatefulWidget {
  const SecurityScanViewAnimation({
    super.key,
    this.size = 240,
    this.color,
    this.period = const Duration(seconds: 2),
  });

  final double size;
  final Color? color;
  final Duration period; // one full sweep revolution

  @override
  State<SecurityScanViewAnimation> createState() => _SecurityScanViewAnimationState();
}

class _SecurityScanViewAnimationState extends State<SecurityScanViewAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // vsync-driven; repeat() loops the 0..1 phase forever.
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // stop the ticker, avoid leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return SizedBox.square(
      dimension: widget.size,
      // Isolate per-frame repaints into their own layer.
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.square(widget.size),
          willChange: true, // animating: don't raster-cache the layer
          painter: _RadarPainter(progress: _controller, color: color),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.progress, required this.color})
  // repaint via Listenable -> repaints WITHOUT rebuilding widgets
      : super(repaint: progress) {
    _gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..color = color.withValues(alpha: 0.15);
    _ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = true;
    _beamPaint = Paint()..isAntiAlias = true;
    _dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = color;
  }

  final Animation<double> progress;
  final Color color;

  // Reused across frames — no allocations inside paint().
  late final Paint _gridPaint;
  late final Paint _ringPaint;
  late final Paint _beamPaint;
  late final Paint _dotPaint;

  // Sweep shader is rebuilt only when the size changes, not every frame.
  Shader? _beamShader;
  Size? _shaderSize;

  static const int _ringCount = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final t = progress.value; // single time source, 0..1

    // --- Static grid: concentric rings + crosshair ---
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 3, _gridPaint);
    }
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      _gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      _gridPaint,
    );

    // --- Pulsing rings: expand + fade, derived purely from phase ---
    for (int i = 0; i < _ringCount; i++) {
      final p = (t + i / _ringCount) % 1.0;
      final opacity = (1.0 - p).clamp(0.0, 1.0);
      _ringPaint.color = color.withValues(alpha: opacity * 0.5);
      canvas.drawCircle(center, p * radius, _ringPaint);
    }

    // --- Rotating sweep beam ---
    // Build the SweepGradient shader once per size; rotate the canvas (cheap)
    // instead of recreating the shader every frame.
    if (_beamShader == null || _shaderSize != size) {
      _beamShader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [color.withValues(alpha: 0.0), color.withValues(alpha: 0.45)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
      _shaderSize = size;
    }
    _beamPaint.shader = _beamShader;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(t * 2 * math.pi);
    canvas.drawCircle(Offset.zero, radius, _beamPaint);
    canvas.restore();

    // --- Center blip ---
    canvas.drawCircle(center, 3, _dotPaint);
  }

  // Animation repaints come from the Listenable, so only static config matters.
  @override
  bool shouldRepaint(covariant _RadarPainter old) => old.color != color;
}