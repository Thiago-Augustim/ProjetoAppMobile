import 'package:flutter/material.dart';

enum FiltroStatus { todas, pendentes, concluidas }

enum FiltroPrioridade { todas, alta, media, baixa }

class TarefaFilters extends StatelessWidget {
  const TarefaFilters({
    required this.status,
    required this.prioridade,
    required this.onStatusChanged,
    required this.onPrioridadeChanged,
    super.key,
  });

  final FiltroStatus status;
  final FiltroPrioridade prioridade;
  final ValueChanged<FiltroStatus> onStatusChanged;
  final ValueChanged<FiltroPrioridade> onPrioridadeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SegmentedFilter<FiltroStatus>(
          selected: status,
          segments: const [
            ButtonSegment(value: FiltroStatus.todas, label: Text('Todas')),
            ButtonSegment(
              value: FiltroStatus.pendentes,
              label: Text('Pendentes'),
            ),
            ButtonSegment(
              value: FiltroStatus.concluidas,
              label: Text('Concluídas'),
            ),
          ],
          onChanged: onStatusChanged,
        ),
        const SizedBox(height: 2),
        _SegmentedFilter<FiltroPrioridade>(
          selected: prioridade,
          segments: const [
            ButtonSegment(value: FiltroPrioridade.todas, label: Text('Todas')),
            ButtonSegment(value: FiltroPrioridade.alta, label: Text('Alta')),
            ButtonSegment(value: FiltroPrioridade.media, label: Text('Média')),
            ButtonSegment(value: FiltroPrioridade.baixa, label: Text('Baixa')),
          ],
          onChanged: onPrioridadeChanged,
        ),
      ],
    );
  }
}

class _SegmentedFilter<T> extends StatelessWidget {
  const _SegmentedFilter({
    required this.selected,
    required this.segments,
    required this.onChanged,
  });

  final T selected;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SegmentedButton<T>(
          showSelectedIcon: false,
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? Color.lerp(
                      Theme.of(context).colorScheme.primary,
                      Colors.white,
                      0.15,
                    )!
                  : Colors.white;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.black87;
            }),
            side: WidgetStatePropertyAll(
              BorderSide(color: Colors.grey.shade300),
            ),
          ),
          segments: segments,
          selected: {selected},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ),
    );
  }
}
