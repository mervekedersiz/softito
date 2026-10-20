import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../controllers/blood_animation_controller.dart';
import '../models/blood_animation_state.dart';
import 'blood_bag_painter.dart';
import 'blood_flow_painter.dart';

class AnimatedBloodBag extends StatefulWidget {
  final BloodAnimationController controller;
  final double width;
  final double height;

  const AnimatedBloodBag({
    super.key,
    required this.controller,
    this.width = 220,
    this.height = 300,
  });

  @override
  State<AnimatedBloodBag> createState() => _AnimatedBloodBagState();
}

class _AnimatedBloodBagState extends State<AnimatedBloodBag>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _fillController;
  late AnimationController _flowController;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 12 seconds fill simulation as specified
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    // 1.5 seconds cyclic wave & pulse loop
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fillController.addListener(() {
      widget.controller.updateProgress(_fillController.value);
    });

    _fillController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flowController.stop();
        widget.controller.updateProgress(1.0);
      }
    });

    _listener = _handleControllerStateChanged;
    widget.controller.addListener(_listener);
  }

  void _handleControllerStateChanged() {
    final state = widget.controller.value;
    switch (state.status) {
      case AnimationStatusState.idle:
        _fillController.reset();
        _flowController.reset();
        break;
      case AnimationStatusState.running:
        if (!_fillController.isAnimating && _fillController.value < 1.0) {
          _fillController.forward(from: state.progress);
        }
        if (!_flowController.isAnimating) {
          _flowController.repeat();
        }
        break;
      case AnimationStatusState.paused:
        if (_fillController.isAnimating) {
          _fillController.stop();
        }
        if (_flowController.isAnimating) {
          _flowController.stop();
        }
        break;
      case AnimationStatusState.completed:
        _fillController.value = 1.0;
        _flowController.stop();
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_listener);
    _fillController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kanColors = context.kanColors;

    return ValueListenableBuilder<BloodAnimationState>(
      valueListenable: widget.controller,
      builder: (context, state, child) {
        return Semantics(
          label: 'Kan bağış simülasyonu, yüzde ${state.percentage}',
          value: '${state.percentage}%',
          child: RepaintBoundary(
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: AnimatedBuilder(
                animation: Listenable.merge([_fillController, _flowController]),
                builder: (context, child) {
                  final currentProgress = _fillController.value;
                  final flowPhase = _flowController.value;
                  final wavePhase = flowPhase * 2 * math.pi;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Blood Bag Body & Liquid Painter
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: BloodBagPainter(
                          progress: currentProgress,
                          wavePhase: wavePhase,
                          fluidTopColor: kanColors.fluidGradientTop,
                          fluidBottomColor: kanColors.fluidGradientBottom,
                          bagBorderColor: kanColors.bagBorder,
                          bagBgColor: kanColors.bagBackground,
                          isDark: isDark,
                        ),
                      ),
                      // Directional Blood Flow Tube & Particles
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: BloodFlowPainter(
                          flowPhase: flowPhase,
                          isFlowing: state.isRunning,
                          tubeColor: kanColors.tubeColor,
                          bloodColor: kanColors.bloodRed,
                          isDark: isDark,
                        ),
                      ),
                      // Center Percentage Label
                      Positioned(
                        bottom: widget.height * 0.22,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withAlpha(160)
                                : Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : AppColors.lightBorder,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.water_drop_rounded,
                                size: 14,
                                color: kanColors.bloodRed,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '%${(currentProgress * 100).round()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
