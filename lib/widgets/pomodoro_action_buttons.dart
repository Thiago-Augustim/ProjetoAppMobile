import 'package:flutter/material.dart';

class PomodoroActionButtons extends StatelessWidget {
  const PomodoroActionButtons({
    required this.isRunning,
    required this.onStartPause,
    required this.onReset,
    super.key,
  });

  final bool isRunning;
  final VoidCallback onStartPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white70 : const Color(0xFF334155);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Reiniciar button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onReset,
                icon: Icon(
                  Icons.replay_rounded,
                  size: 20,
                  color: fg,
                ),
                label: Text(
                  'Reiniciar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: fg,
                  elevation: 0,
                  side: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Iniciar / Pausar button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onStartPause,
                icon: Icon(
                  isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                label: Text(
                  isRunning ? 'Pausar' : 'Iniciar',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
