import 'package:flutter/material.dart';

import 'controllers/pomodoro_controller.dart';
import 'controllers/provas_controller.dart';
import 'controllers/tarefas_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/app_routes.dart';
import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'pages/home_page.dart';
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
  // Controllers criados uma vez e descartados apenas quando o app fecha.
  final _themeController = ThemeController();
  final _pomodoroController = PomodoroController();
  final _tarefasController = TarefasController();
  final _provasController = ProvasController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _themeController.removeListener(_rebuild);
    _themeController.dispose();
    _pomodoroController.dispose();
    _tarefasController.dispose();
    _provasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
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
        routes: {
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.tarefas: (_) => const TarefasPage(),
          AppRoutes.promodoro: (_) => const PromodoroPage(),
          AppRoutes.provas: (_) => const ProvasPage(),
        },
      ),
    );
  }
}
