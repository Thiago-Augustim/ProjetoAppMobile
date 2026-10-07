import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/pomodoro_controller.dart';
import 'package:appestudos/controllers/provas_controller.dart';
import 'package:appestudos/controllers/tarefas_controller.dart';
import 'package:appestudos/controllers/theme_controller.dart';
import 'package:appestudos/core/app_state.dart';
import 'package:appestudos/widgets/app_header.dart';

void main() {
  testWidgets('AppHeader renders correctly and toggles theme', (tester) async {
    final themeController = ThemeController();

    await tester.pumpWidget(
      AppState(
        authController: AuthController(),
        themeController: themeController,
        pomodoroController: PomodoroController(),
        tarefasController: TarefasController(),
        provasController: ProvasController(),
        child: AnimatedBuilder(
          animation: themeController,
          builder: (context, _) {
            return MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeController.themeMode,
              home: const Scaffold(
                appBar: AppHeader(
                  title: 'Temporizador Pomodoro',
                  subtitle: 'Concentre-se. Descanse. Repita.',
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Temporizador Pomodoro'), findsOneWidget);
    expect(find.text('Concentre-se. Descanse. Repita.'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(themeController.isDarkMode, isTrue);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode_outlined));
    await tester.pumpAndSettle();

    expect(themeController.isDarkMode, isFalse);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });
}
