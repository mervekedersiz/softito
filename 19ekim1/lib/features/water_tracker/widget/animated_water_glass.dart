import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class AnimatedWaterGlass extends StatefulWidget {
  const AnimatedWaterGlass({
    super.key,
    required this.progress,
    required this.drankMl,
    required this.goalMl,
  });

  final double progress;
  final int drankMl;
  final int goalMl;

  @override
  State<AnimatedWaterGlass> createState() => _AnimatedWaterGlassState();
}

class _AnimatedWaterGlassState extends State<AnimatedWaterGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Color _resolveWaterColor(double progress) {
    if (progress < 0.35) {
      return Color.lerp(
        const Color(0xFF80DEEA),
        AppColors.neonCyan,
        progress / 0.35,
      )!;
    } else if (progress < 0.8) {
      return Color.lerp(
        AppColors.neonCyan,
        const Color(0xFF0091EA),
        (progress - 0.35) / 0.45,
      )!;
    } else {
      return Color.lerp(
        const Color(0xFF0091EA),
        const Color(0xFF00E5FF),
        (progress - 0.8) / 0.2,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = widget.progress.clamp(0.0, 1.0);
    final waterColor = _resolveWaterColor(clampedProgress);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 170,
          height: 220,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) {
              return CustomPaint(
                painter: _GlassAndWaterPainter(
                  progress: clampedProgress,
                  wavePhase: _waveController.value * 2 * math.pi,
                  waterColor: waterColor,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _GlassMetrics(
          drankMl: widget.drankMl,
          goalMl: widget.goalMl,
          percentage: (clampedProgress * 100).toInt(),
          waterColor: waterColor,
        ),
      ],
    );
  }
}

class _GlassMetrics extends StatelessWidget {
  const _GlassMetrics({
    required this.drankMl,
    required this.goalMl,
    required this.percentage,
    required this.waterColor,
  });

  final int drankMl;
  final int goalMl;
  final int percentage;
  final Color waterColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$drankMl ml',
          style: TextStyle(
            color: waterColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Hedef: $goalMl ml  •  %$percentage Dolu',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GlassAndWaterPainter extends CustomPainter {
  _GlassAndWaterPainter({
    required this.progress,
    required this.wavePhase,
    required this.waterColor,
  });

  final double progress;
  final double wavePhase;
  final Color waterColor;

  @override
  void paint(Canvas canvas, Size size) {
    const glassTopWidth = 130.0;
    const glassBottomWidth = 96.0;
    const glassHeight = 190.0;

    final leftTop = (size.width - glassTopWidth) / 2;
    final rightTop = leftTop + glassTopWidth;
    final leftBottom = (size.width - glassBottomWidth) / 2;
    final rightBottom = leftBottom + glassBottomWidth;
    final topY = size.height - glassHeight - 10;
    final bottomY = size.height - 10;

    final glassPath = Path()
      ..moveTo(leftTop, topY)
      ..lineTo(leftBottom + 8, bottomY - 6)
      ..quadraticBezierTo(leftBottom + 12, bottomY, leftBottom + 20, bottomY)
      ..lineTo(rightBottom - 20, bottomY)
      ..quadraticBezierTo(rightBottom - 12, bottomY, rightBottom - 8, bottomY - 6)
      ..lineTo(rightTop, topY);

    if (progress > 0.01) {
      canvas.save();
      canvas.clipPath(glassPath);

      final waterHeight = (glassHeight - 12) * progress;
      final waterSurfaceY = bottomY - waterHeight;

      final waterPath = Path()..moveTo(leftTop - 10, bottomY + 10);
      waterPath.lineTo(rightTop + 10, bottomY + 10);
      waterPath.lineTo(rightTop + 10, waterSurfaceY);

      for (double x = rightTop + 10; x >= leftTop - 10; x -= 4) {
        final waveY = waterSurfaceY + math.sin((x / 18) + wavePhase) * 3.5;
        waterPath.lineTo(x, waveY);
      }
      waterPath.close();

      final waterGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          waterColor.withValues(alpha: 0.85),
          waterColor.withValues(alpha: 0.55),
        ],
      );

      final waterPaint = Paint()
        ..shader = waterGradient.createShader(
          Rect.fromLTRB(leftBottom, waterSurfaceY, rightBottom, bottomY),
        );
      canvas.drawPath(waterPath, waterPaint);

      final crestPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(waterPath, crestPaint);

      canvas.restore();
    }

    final glassBorderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(glassPath, glassBorderPaint);

    final reflectionPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final reflectionPath = Path()
      ..moveTo(leftTop + 10, topY + 20)
      ..lineTo(leftBottom + 14, bottomY - 30);
    canvas.drawPath(reflectionPath, reflectionPaint);
  }

  @override
  bool shouldRepaint(covariant _GlassAndWaterPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.waterColor != waterColor;
  }
}
