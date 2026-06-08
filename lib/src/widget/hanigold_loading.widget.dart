import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';

/// Branded loading indicator — drop-in replacement for [CircularProgressIndicator].
///
/// ```dart
/// const Center(child: HaniGoldLoading())
/// HaniGoldLoading.small(color: AppColor.buttonColor)
/// ```
class HaniGoldLoading extends StatefulWidget {
  const HaniGoldLoading({
    super.key,
    this.size = 40,
    this.color,
    this.showOrbit,
    this.semanticLabel,
  });

  const HaniGoldLoading.small({
    super.key,
    this.size = 24,
    this.color,
    this.showOrbit = false,
    this.semanticLabel,
  });

  const HaniGoldLoading.large({
    super.key,
    this.size = 56,
    this.color,
    this.showOrbit = true,
    this.semanticLabel,
  });

  final double size;
  final Color? color;
  final bool? showOrbit;
  final String? semanticLabel;

  static const String _logoAsset = 'assets/images/HaniGold.png';

  static const Color _goldLight = Color(0xFFFFE55C);
  static const Color _gold = Color(0xFFFFD700);
  static const Color _goldDeep = Color(0xFFB8860B);

  @override
  State<HaniGoldLoading> createState() => _HaniGoldLoadingState();
}

class _HaniGoldLoadingState extends State<HaniGoldLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _showOrbit =>
      widget.showOrbit ?? widget.size >= 32;

  Color get _accent => widget.color ?? AppColor.dividerColor;

  @override
  Widget build(BuildContext context) {
    final dimension = widget.size;
    final logoSize = dimension * (_showOrbit ? 0.62 : 0.88);

    return Semantics(
      label: widget.semanticLabel ?? 'در حال بارگذاری',
      child: SizedBox(
        width: dimension,
        height: dimension,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final pulse = 0.94 + 0.06 * math.sin(t * 2 * math.pi);
              final glow = 0.35 + 0.25 * math.sin(t * 2 * math.pi + math.pi / 2);

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_showOrbit)
                    CustomPaint(
                      size: Size.square(dimension),
                      painter: _GoldOrbitPainter(
                        progress: t,
                        color: _accent,
                      ),
                    ),
                  Transform.scale(
                    scale: pulse,
                    child: Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: HaniGoldLoading._gold.withValues(
                              alpha: (0.31 * glow).clamp(0.0, 0.31),
                            ),
                            blurRadius: dimension * 0.22,
                            spreadRadius: dimension * 0.02,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              HaniGoldLoading._goldDeep,
                              HaniGoldLoading._goldLight,
                              HaniGoldLoading._gold,
                              HaniGoldLoading._goldLight,
                              HaniGoldLoading._goldDeep,
                            ],
                            stops: [
                              (t - 0.45).clamp(0.0, 1.0),
                              (t - 0.15).clamp(0.0, 1.0),
                              t,
                              (t + 0.15).clamp(0.0, 1.0),
                              (t + 0.45).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds);
                        },
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Image.asset(
              HaniGoldLoading._logoAsset,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldOrbitPainter extends CustomPainter {
  _GoldOrbitPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 1.5;
    final sweep = math.pi * 1.35;
    final start = progress * 2 * math.pi;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.15);
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.25
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [
          color.withValues(alpha: 0),
          HaniGoldLoading._goldLight,
          HaniGoldLoading._gold,
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
        transform: GradientRotation(start),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GoldOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Full-area loading placeholder (e.g. page [PageState.loading]).
class HaniGoldLoadingPage extends StatelessWidget {
  const HaniGoldLoadingPage({
    super.key,
    this.size = 56,
    this.message,
  });

  final double size;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HaniGoldLoading.large(size: size),
          if (message != null) ...[
            SizedBox(height: size * 0.35),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.textColorSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
