import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'controllers/pomodoro_controller.dart';
import 'controllers/provas_controller.dart';
import 'controllers/tarefas_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'pages/cadastro_page.dart';
import 'pages/configuracoes_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/promodoro_page.dart';
import 'pages/provas_page.dart';
import 'pages/tarefas_page.dart';
import 'services/pocketbase_service.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatefulWidget {
  const StudyApp({
    this.service,
    this.authController,
    this.themeController,
    this.criarTarefasController,
    this.criarProvasController,
    this.criarPomodoroController,
    super.key,
  });

  final PocketBaseService? service;
  final AuthController? authController;
  final ThemeController? themeController;
  final TarefasController Function(PocketBaseService service)?
  criarTarefasController;
  final ProvasController Function(PocketBaseService service)?
  criarProvasController;
  final PomodoroController Function()? criarPomodoroController;

  @override
  State<StudyApp> createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> {
  // PocketBaseService injetado explicitamente nos controllers que precisam
  // dele, em vez de cada um ir buscar o singleton por conta própria.
  late final _pocketBaseService = widget.service ?? PocketBaseService.instance;
  late final _themeController = widget.themeController ?? ThemeController();
  late final _authController =
      widget.authController ?? AuthController(service: _pocketBaseService);

  // Controllers de domínio criados sob demanda (lazy) apenas quando uma rota
  // que realmente precisa deles é acessada, e liberados ao fazer logout.
  TarefasController? _tarefasController;
  ProvasController? _provasController;
  PomodoroController? _pomodoroController;

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_rebuild);
    _authController.addListener(_aoMudarUsuario);
    _authController.aoExcluirConta = _descartarDados;
  }

  TarefasController _obterTarefasController() {
    var controller = _tarefasController;
    if (controller == null) {
      controller =
          widget.criarTarefasController?.call(_pocketBaseService) ??
          TarefasController(service: _pocketBaseService);
      final usuario = _authController.usuarioLogado;
      if (usuario != null) {
        controller.trocarUsuario(usuario);
      }
      _tarefasController = controller;
    }
    return controller;
  }

  ProvasController _obterProvasController() {
    var controller = _provasController;
    if (controller == null) {
      controller =
          widget.criarProvasController?.call(_pocketBaseService) ??
          ProvasController(service: _pocketBaseService);
      final usuario = _authController.usuarioLogado;
      if (usuario != null) {
        controller.trocarUsuario(usuario);
      }
      _provasController = controller;
    }
    return controller;
  }

  PomodoroController _obterPomodoroController() {
    return _pomodoroController ??=
        (widget.criarPomodoroController?.call() ?? PomodoroController());
  }

  void _descartarDados(String usuario) {
    _tarefasController?.descartarDadosDe(usuario);
    _provasController?.descartarDadosDe(usuario);
  }

  void _liberarControllersDeDominio() {
    final tarefas = _tarefasController;
    final provas = _provasController;
    final pomodoro = _pomodoroController;

    _tarefasController = null;
    _provasController = null;
    _pomodoroController = null;

    tarefas?.trocarUsuario(null);
    provas?.trocarUsuario(null);
    pomodoro?.resetarSessao();

    tarefas?.dispose();
    provas?.dispose();
    pomodoro?.dispose();
  }

  void _aoMudarUsuario() {
    final usuario = _authController.usuarioLogado;
    if (usuario == null) {
      _liberarControllersDeDominio();
      return;
    }

    _tarefasController?.trocarUsuario(usuario);
    _provasController?.trocarUsuario(usuario);
    _pomodoroController?.resetarSessao();
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _authController.removeListener(_aoMudarUsuario);
    _themeController.removeListener(_rebuild);
    if (widget.authController == null) {
      _authController.dispose();
    }
    if (widget.themeController == null) {
      _themeController.dispose();
    }
    _pomodoroController?.dispose();
    _tarefasController?.dispose();
    _provasController?.dispose();
    super.dispose();
  }

  Route<dynamic> _gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.cadastro:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => CadastroPage(
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.home:
        final tarefasController = _obterTarefasController();
        final provasController = _obterProvasController();
        final pomodoroController = _pomodoroController;
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => HomePage(
            tarefasController: tarefasController,
            provasController: provasController,
            pomodoroController: pomodoroController,
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.tarefas:
        final tarefasController = _obterTarefasController();
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => TarefasPage(
            tarefasController: tarefasController,
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.promodoro:
        final pomodoroController = _obterPomodoroController();
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => PromodoroPage(
            pomodoroController: pomodoroController,
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.provas:
        final provasController = _obterProvasController();
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => ProvasPage(
            provasController: provasController,
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.configuracoes:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => ConfiguracoesPage(
            authController: _authController,
            themeController: _themeController,
          ),
        );
      case AppRoutes.login:
      default:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => LoginPage(
            authController: _authController,
            themeController: _themeController,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Estudos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeController.themeMode,
      onGenerateInitialRoutes: (initialRoute) => [
        _gerarRota(
          RouteSettings(
            name: initialRoute.isNotEmpty && initialRoute != '/'
                ? initialRoute
                : AppRoutes.login,
          ),
        ),
      ],
      onGenerateRoute: _gerarRota,
    );
  }
}
