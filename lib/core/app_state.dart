import 'package:flutter/widgets.dart';

import '../controllers/pomodoro_controller.dart';
import '../controllers/provas_controller.dart';
import '../controllers/tarefas_controller.dart';

/// Injeta os controllers globais na árvore de widgets.
///
/// Instanciado uma única vez em [main.dart] e wraps o [MaterialApp],
/// garantindo que todos os controllers vivam durante toda a sessão do app.
class AppState extends InheritedWidget {
  const AppState({
    required this.pomodoroController,
    required this.tarefasController,
    required this.provasController,
    required super.child,
    super.key,
  });

  final PomodoroController pomodoroController;
  final TarefasController tarefasController;
  final ProvasController provasController;

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'Nenhum AppState encontrado na árvore de widgets');
    return result!;
  }

  /// Retorna false porque os controllers nunca são substituídos —
  /// as páginas reagem via [ChangeNotifier], não via InheritedWidget.
  @override
  bool updateShouldNotify(AppState oldWidget) => false;
}
