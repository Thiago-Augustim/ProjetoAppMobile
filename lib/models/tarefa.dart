import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';

import '../services/pocketbase_service.dart';

enum Prioridade { alta, media, baixa }

class Tarefa {
  Tarefa({
    this.id,
    required this.titulo,
    required this.materia,
    required this.prioridade,
    this.concluida = false,
    this.prazo,
    this.fotoBytes,
    this.fotoNome,
    this.fotoUrl,
  });

  final String? id;
  final String titulo;
  final String materia;
  final Prioridade prioridade;
  bool concluida;
  final DateTime? prazo;
  final Uint8List? fotoBytes;
  final String? fotoNome;
  final String? fotoUrl;

  bool get possuiFoto =>
      (fotoBytes != null && fotoBytes!.isNotEmpty) ||
      (fotoUrl != null && fotoUrl!.isNotEmpty);

  factory Tarefa.fromRecord(
    RecordModel record, {
    String? baseUrl,
    Uint8List? fotoBytes,
  }) {
    final prioridadeStr = record.getStringValue('prioridade');
    final prioridade = Prioridade.values.firstWhere(
      (p) => p.name == prioridadeStr,
      orElse: () => Prioridade.media,
    );

    final prazoStr = record.getStringValue('prazo');
    final prazo = prazoStr.isNotEmpty ? DateTime.tryParse(prazoStr) : null;

    final fotoArquivo = record.getStringValue('foto');
    final urlBase = baseUrl ?? PocketBaseService.baseUrl;
    final fotoUrl = fotoArquivo.isNotEmpty
        ? '$urlBase/api/files/${record.collectionId}/${record.id}/$fotoArquivo'
        : null;

    return Tarefa(
      id: record.id,
      titulo: record.getStringValue('titulo'),
      materia: record.getStringValue('materia'),
      prioridade: prioridade,
      concluida: record.getBoolValue('concluida'),
      prazo: prazo,
      fotoBytes: fotoBytes,
      fotoNome: fotoArquivo.isNotEmpty ? fotoArquivo : null,
      fotoUrl: fotoUrl,
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
    Uint8List? fotoBytes,
    String? fotoNome,
    String? fotoUrl,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      materia: materia ?? this.materia,
      prioridade: prioridade ?? this.prioridade,
      concluida: concluida ?? this.concluida,
      prazo: prazo ?? this.prazo,
      fotoBytes: fotoBytes ?? this.fotoBytes,
      fotoNome: fotoNome ?? this.fotoNome,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}
