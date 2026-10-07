import 'package:flutter/widgets.dart';

import '../controllers/auth_controller.dart';
import '../controllers/pomodoro_controller.dart';
import '../controllers/provas_controller.dart';
import '../controllers/tarefas_controller.dart';
import '../controllers/theme_controller.dart';

class AppState extends InheritedWidget {
  const AppState({
    required this.authController,
    required this.themeController,
    required this.pomodoroController,
    required this.tarefasController,
    required this.provasController,
    required super.child,
    super.key,
  });

  final AuthController authController;
  final ThemeController themeController;
  final PomodoroController pomodoroController;
  final TarefasController tarefasController;
  final ProvasController provasController;

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'Nenhum AppState encontrado na árvore de widgets');
    return result!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) => false;
}
