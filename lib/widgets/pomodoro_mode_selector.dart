import 'package:flutter/material.dart';

import '../models/pomodoro_mode.dart';

class PomodoroModeSelector extends StatelessWidget {
  const PomodoroModeSelector({
    required this.selectedMode,
    required this.onModeSelected,
    super.key,
  });

  final PomodoroMode selectedMode;
  final ValueChanged<PomodoroMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: PomodoroMode.values.map((mode) {
          final isSelected = mode == selectedMode;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: Key('pomodoro_mode_${mode.name}'),
                borderRadius: BorderRadius.circular(12),
                onTap: () => onModeSelected(mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: _buildSegmentContent(mode, isSelected),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSegmentContent(PomodoroMode mode, bool isSelected) {
    if (mode == PomodoroMode.foco) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Foco ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            TextSpan(
              text: mode.textoDuracao,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.blueGrey.shade400,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          mode.titulo,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          mode.textoDuracao,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.blueGrey.shade400,
          ),
        ),
      ],
    );
  }
}
