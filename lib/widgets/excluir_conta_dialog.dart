import 'package:flutter/material.dart';

import '../core/app_state.dart';

class ExcluirContaDialog extends StatefulWidget {
  const ExcluirContaDialog({super.key});

  @override
  State<ExcluirContaDialog> createState() => _ExcluirContaDialogState();
}

class _ExcluirContaDialogState extends State<ExcluirContaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();

  bool _ocultarSenha = true;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  Future<bool> _confirmar() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta?'),
        content: const Text(
          'Tem certeza? Sua conta, tarefas e provas serão apagadas '
          'permanentemente e essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim, excluir'),
          ),
        ],
      ),
    );
    return confirmou == true;
  }

  Future<void> _excluir() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = AppState.of(context).authController;

    if (!auth.senhaConfere(_senhaController.text)) {
      setState(() => _erro = 'Senha incorreta.');
      return;
    }

    setState(() => _erro = null);

    if (!await _confirmar() || !mounted) {
      return;
    }

    setState(() => _carregando = true);
    final erro = await auth.excluirConta(_senhaController.text);

    if (!mounted) {
      return;
    }

    if (erro != null) {
      setState(() {
        _carregando = false;
        _erro = erro;
      });
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final corErro = Theme.of(context).colorScheme.error;

    return AlertDialog(
      title: const Text('Excluir conta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Para continuar, digite sua senha. Essa ação apaga sua conta '
                'e todos os seus dados.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _excluir(),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(
                      _ocultarSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe sua senha';
                  }
                  return null;
                },
              ),
              if (_erro != null) ...[
                const SizedBox(height: 12),
                Text(_erro!, style: TextStyle(color: corErro)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _carregando ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: corErro,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _carregando ? null : _excluir,
          child: _carregando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Excluir'),
        ),
      ],
    );
  }
}
