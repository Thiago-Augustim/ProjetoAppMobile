import 'package:flutter/material.dart';

import '../models/prova.dart';

class HomeProximaProvaTile extends StatelessWidget {
  const HomeProximaProvaTile({required this.prova, super.key});

  final Prova prova;

  int get _diasRestantes {
    final hoje = DateTime.now();
    final data = prova.data;
    return DateTime(
      data.year,
      data.month,
      data.day,
    ).difference(DateTime(hoje.year, hoje.month, hoje.day)).inDays;
  }

  Color get _corDaContagem {
    if (_diasRestantes <= 2) return Colors.red;
    if (_diasRestantes <= 7) return Colors.orange;
    return Colors.green;
  }

  Color get _corDeFundoDaContagem {
    if (_diasRestantes <= 2) return Colors.red.shade50;
    if (_diasRestantes <= 7) return Colors.amber.shade50;
    return Colors.green.shade50;
  }

  String get _textoDaContagem {
    final dias = _diasRestantes;
    if (dias == 0) return 'hoje';
    if (dias == 1) return 'amanhã';
    return '$dias dias';
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
                  prova.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  prova.sala == null
                      ? prova.materia
                      : '${prova.materia} · sala ${prova.sala}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _corDeFundoDaContagem,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _textoDaContagem,
              style: TextStyle(
                color: _corDaContagem,
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
