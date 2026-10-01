enum Prioridade { alta, media, baixa }

class Tarefa {
  Tarefa({
    required this.titulo,
    required this.materia,
    required this.prioridade,
    this.concluida = false,
    this.prazo,
  });

  final String titulo;
  final String materia;
  final Prioridade prioridade;
  bool concluida;
  final DateTime? prazo;
}
