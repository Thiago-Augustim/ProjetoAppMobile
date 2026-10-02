class Prova {
  Prova({
    required this.titulo,
    required this.materia,
    required this.data,
    this.sala,
  });

  final String titulo;
  final String materia;
  final DateTime data;
  final String? sala;
}
