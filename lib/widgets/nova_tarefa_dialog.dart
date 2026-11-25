import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/camera_service.dart';

class NovaTarefaDialog extends StatefulWidget {
  const NovaTarefaDialog({this.cameraService, super.key});

  final CameraService? cameraService;

  @override
  State<NovaTarefaDialog> createState() => _NovaTarefaDialogState();
}

class _NovaTarefaDialogState extends State<NovaTarefaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _materiaController = TextEditingController();
  late final CameraService _cameraService =
      widget.cameraService ?? CameraService();

  Prioridade _prioridade = Prioridade.media;
  DateTime? _prazo;
  Uint8List? _fotoBytes;
  String? _fotoNome;
  bool _capturandoFoto = false;

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

  Future<void> _tirarFoto() async {
    if (_capturandoFoto) return;

    setState(() => _capturandoFoto = true);
    try {
      final foto = await _cameraService.tirarFoto();
      if (!mounted) return;
      if (foto != null) {
        setState(() {
          _fotoBytes = foto.bytes;
          _fotoNome = foto.nomeArquivo;
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a câmera neste dispositivo.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _capturandoFoto = false);
      }
    }
  }

  void _removerFoto() {
    setState(() {
      _fotoBytes = null;
      _fotoNome = null;
    });
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
        fotoBytes: _fotoBytes,
        fotoNome: _fotoNome,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                initialValue: _prioridade,
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
              const SizedBox(height: 8),
              if (_fotoBytes == null)
                OutlinedButton.icon(
                  key: const Key('btn_tirar_foto_tarefa'),
                  onPressed: _capturandoFoto ? null : _tirarFoto,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(
                    _capturandoFoto ? 'Abrindo câmera...' : 'Tirar foto',
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _fotoBytes!,
                        key: const Key('preview_foto_nova_tarefa'),
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          key: const Key('btn_trocar_foto_tarefa'),
                          onPressed: _capturandoFoto ? null : _tirarFoto,
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Trocar'),
                        ),
                        TextButton.icon(
                          key: const Key('btn_remover_foto_tarefa'),
                          onPressed: _removerFoto,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Remover'),
                        ),
                      ],
                    ),
                  ],
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
