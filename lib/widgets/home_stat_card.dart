import 'package:flutter/material.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    required this.valor,
    required this.rotulo,
    required this.corTexto,
    required this.corDeFundo,
    super.key,
  });

  final int valor;
  final String rotulo;
  final Color corTexto;
  final Color corDeFundo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: corDeFundo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$valor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rotulo,
            style: TextStyle(
              fontSize: 13,
              color: corTexto.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
