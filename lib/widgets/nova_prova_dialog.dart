import 'package:flutter/material.dart';

import '../models/prova.dart';

class NovaProvaDialog extends StatefulWidget {
  const NovaProvaDialog({this.provaParaEditar, super.key});

  /// Quando informada, o diálogo abre preenchido com os dados dela e
  /// passa a funcionar como edição em vez de criação.
  final Prova? provaParaEditar;

  @override
  State<NovaProvaDialog> createState() => _NovaProvaDialogState();
}

class _NovaProvaDialogState extends State<NovaProvaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _tituloController = TextEditingController(
    text: widget.provaParaEditar?.titulo,
  );
  late final _materiaController = TextEditingController(
    text: widget.provaParaEditar?.materia,
  );
  late final _salaController = TextEditingController(
    text: widget.provaParaEditar?.sala,
  );
  late DateTime? _data = widget.provaParaEditar?.data;

  bool get _estaEditando => widget.provaParaEditar != null;

  @override
  void dispose() {
    _tituloController.dispose();
    _materiaController.dispose();
    _salaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _data ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selecionada != null) {
      setState(() => _data = selecionada);
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_data == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe a data da prova')));
      return;
    }

    Navigator.pop(
      context,
      Prova(
        titulo: _tituloController.text.trim(),
        materia: _materiaController.text.trim(),
        data: _data!,
        sala: _salaController.text.trim().isEmpty
            ? null
            : _salaController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_estaEditando ? 'Editar prova' : 'Nova prova'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _materiaController,
                decoration: const InputDecoration(labelText: 'Matéria'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a matéria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaController,
                decoration: const InputDecoration(
                  labelText: 'Sala (opcional)',
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(
                  _data == null
                      ? 'Selecionar data'
                      : '${_data!.day.toString().padLeft(2, '0')}/'
                          '${_data!.month.toString().padLeft(2, '0')}/'
                          '${_data!.year}',
                ),
                onTap: _selecionarData,
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
          child: Text(_estaEditando ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}
