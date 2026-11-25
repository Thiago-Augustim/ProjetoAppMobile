import 'package:flutter/material.dart';

import '../models/tarefa.dart';

class TarefaCard extends StatelessWidget {
  const TarefaCard({
    required this.tarefa,
    required this.onStatusChanged,
    super.key,
  });

  final Tarefa tarefa;
  final ValueChanged<bool?> onStatusChanged;

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
        return 'Alta';
      case Prioridade.media:
        return 'Média';
      case Prioridade.baixa:
        return 'Baixa';
    }
  }

  Widget _construirImagem({BoxFit fit = BoxFit.cover}) {
    if (tarefa.fotoBytes != null && tarefa.fotoBytes!.isNotEmpty) {
      return Image.memory(
        tarefa.fotoBytes!,
        fit: fit,
      );
    }
    return Image.network(
      tarefa.fotoUrl!,
      fit: fit,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(Icons.broken_image_outlined),
      ),
    );
  }

  void _abrirFotoAmpliada(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        key: const Key('dialog_foto_ampliada_tarefa'),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tarefa.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: InteractiveViewer(
                child: _construirImagem(fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
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
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onStatusChanged(!tarefa.concluida),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            children: [
              Checkbox(
                value: tarefa.concluida,
                shape: const CircleBorder(),
                visualDensity: VisualDensity.compact,
                onChanged: onStatusChanged,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarefa.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: tarefa.concluida
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tarefa.materia,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey.shade300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (tarefa.possuiFoto) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Ver foto anexada',
                  child: GestureDetector(
                    key: const Key('miniatura_foto_tarefa'),
                    onTap: () => _abrirFotoAmpliada(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: _construirImagem(),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: _corDeFundoDaPrioridade,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _textoDaPrioridade.toLowerCase(),
                  style: TextStyle(
                    color: _corDaPrioridade,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
