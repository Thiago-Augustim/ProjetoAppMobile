import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'controllers/pomodoro_controller.dart';
import 'controllers/provas_controller.dart';
import 'controllers/tarefas_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/app_routes.dart';
import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'pages/cadastro_page.dart';
import 'pages/configuracoes_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/promodoro_page.dart';
import 'pages/provas_page.dart';
import 'pages/tarefas_page.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatefulWidget {
  const StudyApp({super.key});

  @override
  State<StudyApp> createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> {
  final _authController = AuthController();
  final _themeController = ThemeController();
  final _pomodoroController = PomodoroController();
  final _tarefasController = TarefasController();
  final _provasController = ProvasController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_rebuild);
    _authController.addListener(_aoMudarUsuario);
    _authController.aoExcluirConta = _descartarDados;
  }

  void _descartarDados(String usuario) {
    _tarefasController.descartarDadosDe(usuario);
    _provasController.descartarDadosDe(usuario);
  }

  void _aoMudarUsuario() {
    final usuario = _authController.usuarioLogado;
    _tarefasController.trocarUsuario(usuario);
    _provasController.trocarUsuario(usuario);
    _pomodoroController.resetarSessao();
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _authController.removeListener(_aoMudarUsuario);
    _themeController.removeListener(_rebuild);
    _authController.dispose();
    _themeController.dispose();
    _pomodoroController.dispose();
    _tarefasController.dispose();
    _provasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      authController: _authController,
      themeController: _themeController,
      pomodoroController: _pomodoroController,
      tarefasController: _tarefasController,
      provasController: _provasController,
      child: MaterialApp(
        title: 'App Estudos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _themeController.themeMode,
        onGenerateInitialRoutes: (_) => [
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        ],
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.cadastro: (_) => const CadastroPage(),
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.tarefas: (_) => const TarefasPage(),
          AppRoutes.promodoro: (_) => const PromodoroPage(),
          AppRoutes.provas: (_) => const ProvasPage(),
          AppRoutes.configuracoes: (_) => const ConfiguracoesPage(),
        },
      ),
    );
  }
}
