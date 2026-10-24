import 'package:pocketbase/pocketbase.dart';

class Prova {
  Prova({
    this.id,
    required this.titulo,
    required this.materia,
    required this.data,
    this.sala,
  });

  final String? id;
  final String titulo;
  final String materia;
  final DateTime data;
  final String? sala;

  factory Prova.fromRecord(RecordModel record) {
    final dataStr = record.getStringValue('data');
    final data = DateTime.tryParse(dataStr) ?? DateTime.now();

    final salaStr = record.getStringValue('sala');

    return Prova(
      id: record.id,
      titulo: record.getStringValue('titulo'),
      materia: record.getStringValue('materia'),
      data: data,
      sala: salaStr.isEmpty ? null : salaStr,
    );
  }

  Map<String, dynamic> toJson({String? userId}) {
    return {
      'titulo': titulo,
      'materia': materia,
      'data': data.toIso8601String(),
      if (sala != null && sala!.isNotEmpty) 'sala': sala,
      'user': ?userId,
    };
  }

  Prova copyWith({
    String? id,
    String? titulo,
    String? materia,
    DateTime? data,
    String? sala,
  }) {
    return Prova(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      materia: materia ?? this.materia,
      data: data ?? this.data,
      sala: sala ?? this.sala,
    );
  }
}

