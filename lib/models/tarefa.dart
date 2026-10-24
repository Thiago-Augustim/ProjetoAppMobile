import 'package:pocketbase/pocketbase.dart';

enum Prioridade { alta, media, baixa }

class Tarefa {
  Tarefa({
    this.id,
    required this.titulo,
    required this.materia,
    required this.prioridade,
    this.concluida = false,
    this.prazo,
  });

  final String? id;
  final String titulo;
  final String materia;
  final Prioridade prioridade;
  bool concluida;
  final DateTime? prazo;

  factory Tarefa.fromRecord(RecordModel record) {
    final prioridadeStr = record.getStringValue('prioridade');
    final prioridade = Prioridade.values.firstWhere(
      (p) => p.name == prioridadeStr,
      orElse: () => Prioridade.media,
    );

    final prazoStr = record.getStringValue('prazo');
    final prazo = prazoStr.isNotEmpty ? DateTime.tryParse(prazoStr) : null;

    return Tarefa(
      id: record.id,
      titulo: record.getStringValue('titulo'),
      materia: record.getStringValue('materia'),
      prioridade: prioridade,
      concluida: record.getBoolValue('concluida'),
      prazo: prazo,
    );
  }

  Map<String, dynamic> toJson({String? userId}) {
    return {
      'titulo': titulo,
      'materia': materia,
      'prioridade': prioridade.name,
      'concluida': concluida,
      if (prazo != null) 'prazo': prazo!.toIso8601String(),
      'user': ?userId,
    };
  }

  Tarefa copyWith({
    String? id,
    String? titulo,
    String? materia,
    Prioridade? prioridade,
    bool? concluida,
    DateTime? prazo,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      materia: materia ?? this.materia,
      prioridade: prioridade ?? this.prioridade,
      concluida: concluida ?? this.concluida,
      prazo: prazo ?? this.prazo,
    );
  }
}

