import 'package:flutter/material.dart';

import '../models/tarefa.dart';

class HomeProximoPrazoTile extends StatelessWidget {
  const HomeProximoPrazoTile({required this.tarefa, super.key});

  final Tarefa tarefa;

  Color get _corDaPrioridade {
    switch (tarefa.prioridade) {
      case Prioridade.alta:
        return Colors.red;
      case Prioridade.media:
        return Colors.orange;
      case Prioridade.baixa:
        return Colors.green;
    }
  }

  Color get _corDeFundoDaPrioridade {
    switch (tarefa.prioridade) {
      case Prioridade.alta:
        return Colors.red.shade50;
      case Prioridade.media:
        return Colors.amber.shade50;
      case Prioridade.baixa:
        return Colors.green.shade50;
    }
  }

  String get _textoDaPrioridade {
    switch (tarefa.prioridade) {
      case Prioridade.alta:
        return 'alta';
      case Prioridade.media:
        return 'média';
      case Prioridade.baixa:
        return 'baixa';
    }
  }

  String get _textoPrazo {
    final prazo = tarefa.prazo!;
    final hoje = DateTime.now();
    final diffDias = DateTime(
      prazo.year,
      prazo.month,
      prazo.day,
    ).difference(DateTime(hoje.year, hoje.month, hoje.day)).inDays;

    if (diffDias == 0) return 'Hoje';
    if (diffDias == 1) return 'Amanhã';
    if (diffDias < 0) return 'Atrasada';
    return '${prazo.day.toString().padLeft(2, '0')}/'
        '${prazo.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarefa.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  tarefa.materia,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.blueGrey.shade300,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _textoPrazo,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade400,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _corDeFundoDaPrioridade,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _textoDaPrioridade,
              style: TextStyle(
                color: _corDaPrioridade,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
