import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/pomodoro_mode.dart';

class PomodoroTimerCircle extends StatelessWidget {
  const PomodoroTimerCircle({
    required this.mode,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.diameter = 260.0,
    super.key,
  });

  final PomodoroMode mode;
  final int remainingSeconds;
  final int totalSeconds;
  final double diameter;

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSecs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSecs';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final trackColor = primaryColor.withValues(alpha: 0.12);
    final progress = totalSeconds > 0 ? (remainingSeconds / totalSeconds) : 0.0;

    return Center(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular progress ring with animated transition
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: progress, end: progress),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, animatedProgress, child) {
                return CustomPaint(
                  size: Size(diameter, diameter),
                  painter: _PomodoroProgressPainter(
                    progress: animatedProgress,
                    primaryColor: primaryColor,
                    trackColor: trackColor,
                    strokeWidth: 10.0,
                  ),
                );
              },
            ),

            // Inner white circular card
            Container(
              width: diameter - 26,
              height: diameter - 26,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Time display (e.g. 25:00)
                  Text(
                    _formatTime(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Mode indicator (e.g. 🎯 Foco)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mode.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        mode.titulo,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
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

class _PomodoroProgressPainter extends CustomPainter {
  const _PomodoroProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color primaryColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track ring
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0.0) {
      final progressPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PomodoroProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
