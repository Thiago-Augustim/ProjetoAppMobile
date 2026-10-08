import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/pomodoro_controller.dart';
import 'package:appestudos/controllers/provas_controller.dart';
import 'package:appestudos/controllers/tarefas_controller.dart';
import 'package:appestudos/controllers/theme_controller.dart';
import 'package:appestudos/core/app_state.dart';
import 'package:appestudos/core/app_theme.dart';
import 'package:appestudos/pages/promodoro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestWidget({
  ThemeController? themeController,
  PomodoroController? pomodoroController,
  TarefasController? tarefasController,
  ProvasController? provasController,
}) {
  return AppState(
    authController: AuthController(),
    themeController: themeController ?? ThemeController(),
    pomodoroController: pomodoroController ?? PomodoroController(),
    tarefasController: tarefasController ?? TarefasController(),
    provasController: provasController ?? ProvasController(),
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const PromodoroPage(),
    ),
  );
}

void main() {
  testWidgets(
      'PromodoroPage renders title, modes, initial timer and action buttons',
      (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Temporizador Pomodoro'), findsOneWidget);
    expect(find.text('Concentre-se. Descanse. Repita.'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Reiniciar'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Pausa Curta'), findsOneWidget);
    expect(find.text('Pausa Longa'), findsOneWidget);
  });

  testWidgets('Switching modes updates the timer duration', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byKey(const Key('pomodoro_mode_pausaCurta')));
    await tester.pumpAndSettle();
    expect(find.text('05:00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pomodoro_mode_pausaLonga')));
    await tester.pumpAndSettle();
    expect(find.text('15:00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pomodoro_mode_foco')));
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
  });

  testWidgets('Iniciar starts the timer and toggles button to Pausar',
      (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    expect(find.text('Pausar'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('24:59'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('24:57'), findsOneWidget);

    await tester.tap(find.text('Pausar'));
    await tester.pump();
    expect(find.text('Iniciar'), findsOneWidget);

    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.text('25:00'), findsOneWidget);
  });

  testWidgets('Timer keeps counting when controller is shared (simulate nav)',
      (tester) async {
    final controller = PomodoroController();
    await tester.pumpWidget(createTestWidget(pomodoroController: controller));

    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    expect(find.text('Pausar'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('24:55'), findsOneWidget);

    await tester.pumpWidget(createTestWidget(pomodoroController: controller));
    await tester.pump();

    expect(find.text('24:55'), findsOneWidget);
    expect(find.text('Pausar'), findsOneWidget);

    controller.dispose();
  });
}
