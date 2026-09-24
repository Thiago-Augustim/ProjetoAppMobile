import 'package:flutter/material.dart';

enum PomodoroMode {
  foco(
    titulo: 'Foco',
    duracaoMinutos: 25,
    icone: Icons.crisis_alert_rounded,
    emoji: '🎯',
    descricao: 'Concentre-se na sua tarefa atual',
  ),
  pausaCurta(
    titulo: 'Pausa Curta',
    duracaoMinutos: 5,
    icone: Icons.coffee_rounded,
    emoji: '☕',
    descricao: 'Descanse um pouco e recarregue as energias',
  ),
  pausaLonga(
    titulo: 'Pausa Longa',
    duracaoMinutos: 15,
    icone: Icons.weekend_rounded,
    emoji: '🛋️',
    descricao: 'Pausa estendida para relaxar a mente',
  );

  const PomodoroMode({
    required this.titulo,
    required this.duracaoMinutos,
    required this.icone,
    required this.emoji,
    required this.descricao,
  });

  final String titulo;
  final int duracaoMinutos;
  final IconData icone;
  final String emoji;
  final String descricao;

  int get duracaoSegundos => duracaoMinutos * 60;
  String get textoDuracao => '${duracaoMinutos}min';
}
