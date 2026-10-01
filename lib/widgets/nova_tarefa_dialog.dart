import 'package:flutter/material.dart';
import '../models/tarefa.dart';

class NovaTarefaDialog extends StatefulWidget {
  const NovaTarefaDialog({super.key});

  @override
  State<NovaTarefaDialog> createState() => _NovaTarefaDialogState();
}

class _NovaTarefaDialogState extends State<NovaTarefaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _materiaController = TextEditingController();
  Prioridade _prioridade = Prioridade.media;
  DateTime? _prazo;

  @override
  void dispose() {
    _tituloController.dispose();
    _materiaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarPrazo() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _prazo ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selecionada != null) {
      setState(() => _prazo = selecionada);
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      Tarefa(
        titulo: _tituloController.text.trim(),
        materia: _materiaController.text.trim(),
        prioridade: _prioridade,
        prazo: _prazo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _materiaController,
                decoration: const InputDecoration(
                  labelText: 'Matéria',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a matéria';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Prioridade>(
                value: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                ),
                items: const [
                  DropdownMenuItem(
                    value: Prioridade.alta,
                    child: Text('Alta'),
                  ),
                  DropdownMenuItem(
                    value: Prioridade.media,
                    child: Text('Média'),
                  ),
                  DropdownMenuItem(
                    value: Prioridade.baixa,
                    child: Text('Baixa'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _prioridade = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(
                  _prazo == null
                      ? 'Sem prazo definido'
                      : 'Prazo: ${_prazo!.day.toString().padLeft(2, '0')}/'
                          '${_prazo!.month.toString().padLeft(2, '0')}/'
                          '${_prazo!.year}',
                ),
                trailing: _prazo == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _prazo = null),
                      ),
                onTap: _selecionarPrazo,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvar,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
