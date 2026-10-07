import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_state.dart';
import '../widgets/theme_toggle_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _ocultarSenha = true;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _abrirCadastro() async {
    final usuario = await Navigator.pushNamed(context, AppRoutes.cadastro);
    if (!mounted || usuario is! String) return;

    _usuarioController.text = usuario;
    _senhaController.clear();
    setState(() => _erro = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta criada! Faça login para entrar.')),
    );
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = AppState.of(context).authController;
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await auth.login(
      _usuarioController.text,
      _senhaController.text,
    );

    if (!mounted) return;

    if (erro != null) {
      setState(() {
        _carregando = false;
        _erro = erro;
      });
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'lib/img/StudyFocus.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bem-vindo!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Entre para continuar seus estudos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey.shade300),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usuarioController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe seu usuário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: _ocultarSenha,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _entrar(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip:
                              _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
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
                      Text(
                        _erro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _carregando ? null : _entrar,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: _carregando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Entrar'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _carregando ? null : _abrirCadastro,
                      child: const Text('Não tem conta? Cadastre-se'),
                    ),
                    Text(
                      'Teste: aluno / estudo@2026',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey.shade300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
