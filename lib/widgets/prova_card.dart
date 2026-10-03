import 'package:flutter/material.dart';

import '../models/prova.dart';

class ProvaCard extends StatelessWidget {
  const ProvaCard({required this.prova, super.key});

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
    if (_diasRestantes < 0) return Colors.grey;
    if (_diasRestantes <= 2) return Colors.red;
    if (_diasRestantes <= 7) return Colors.orange;
    return Colors.green;
  }

  Color get _corDeFundoDaContagem {
    if (_diasRestantes < 0) return Colors.grey.shade100;
    if (_diasRestantes <= 2) return Colors.red.shade50;
    if (_diasRestantes <= 7) return Colors.amber.shade50;
    return Colors.green.shade50;
  }

  String get _textoDaContagem {
    final dias = _diasRestantes;
    if (dias < 0) return 'realizada';
    if (dias == 0) return 'hoje';
    if (dias == 1) return 'amanhã';
    return '$dias dias';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    prova.materia,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade300,
                      fontSize: 14,
                    ),
                  ),
                  if (prova.sala != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.room_outlined,
                          size: 14,
                          color: Colors.blueGrey.shade300,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prova.sala!,
                          style: TextStyle(
                            color: Colors.blueGrey.shade300,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    '${prova.data.day.toString().padLeft(2, '0')}/'
                    '${prova.data.month.toString().padLeft(2, '0')}/'
                    '${prova.data.year}',
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      ),
    );
  }
}
