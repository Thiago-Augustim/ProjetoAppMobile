import 'package:flutter/material.dart';

import '../core/app_state.dart';

class AlterarSenhaDialog extends StatefulWidget {
  const AlterarSenhaDialog({super.key});

  @override
  State<AlterarSenhaDialog> createState() => _AlterarSenhaDialogState();
}

class _AlterarSenhaDialogState extends State<AlterarSenhaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _atualController = TextEditingController();
  final _novaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _ocultarSenhas = true;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _atualController.dispose();
    _novaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = AppState.of(context).authController;
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await auth.alterarSenha(
      _atualController.text,
      _novaController.text,
    );

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

  InputDecoration _decoracao(String rotulo, {bool comOlho = false}) {
    return InputDecoration(
      labelText: rotulo,
      suffixIcon: comOlho
          ? IconButton(
              tooltip: _ocultarSenhas ? 'Mostrar senhas' : 'Ocultar senhas',
              icon: Icon(
                _ocultarSenhas
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _ocultarSenhas = !_ocultarSenhas),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trocar senha'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _atualController,
                obscureText: _ocultarSenhas,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: _decoracao('Senha atual', comOlho: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha atual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _novaController,
                obscureText: _ocultarSenhas,
                textInputAction: TextInputAction.next,
                decoration: _decoracao('Nova senha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a nova senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter ao menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmarController,
                obscureText: _ocultarSenhas,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _salvar(),
                decoration: _decoracao('Confirmar nova senha'),
                validator: (value) {
                  if (value != _novaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              if (_erro != null) ...[
                const SizedBox(height: 12),
                Text(
                  _erro!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
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
          onPressed: _carregando ? null : _salvar,
          child: _carregando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
