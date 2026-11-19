import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/pomodoro_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/pomodoro_mode.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/pomodoro_action_buttons.dart';
import '../widgets/pomodoro_mode_selector.dart';
import '../widgets/pomodoro_timer_circle.dart';

class PromodoroPage extends StatefulWidget {
  const PromodoroPage({
    required this.pomodoroController,
    required this.authController,
    required this.themeController,
    super.key,
  });

  final PomodoroController pomodoroController;
  final AuthController authController;
  final ThemeController themeController;

  @override
  State<PromodoroPage> createState() => _PromodoroPageState();
}

class _PromodoroPageState extends State<PromodoroPage> {
  bool _dialogShowing = false;

  @override
  void initState() {
    super.initState();
    widget.pomodoroController.addListener(_onControllerUpdate);
    if (widget.pomodoroController.completion != null && !_dialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onControllerUpdate(),
      );
    }
  }

  @override
  void didUpdateWidget(PromodoroPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pomodoroController != widget.pomodoroController) {
      oldWidget.pomodoroController.removeListener(_onControllerUpdate);
      widget.pomodoroController.addListener(_onControllerUpdate);
      if (widget.pomodoroController.completion != null && !_dialogShowing) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _onControllerUpdate(),
        );
      }
    }
  }

  @override
  void dispose() {
    widget.pomodoroController.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final completion = widget.pomodoroController.completion;
    if (completion != null && !_dialogShowing) {
      _dialogShowing = true;
      _exibirDialogoConclusao(completion);
    }
  }

  void _exibirDialogoConclusao(PomodoroCompletion completion) {
    final controller = widget.pomodoroController;

    final bool foiModoFoco = completion.modoCompletado == PomodoroMode.foco;
    final bool isPausaLonga = foiModoFoco &&
        (controller.ciclosCompletos % PomodoroController.ciclosPorSessao == 0);

    final PomodoroMode proximoModo = foiModoFoco
        ? (isPausaLonga ? PomodoroMode.pausaLonga : PomodoroMode.pausaCurta)
        : PomodoroMode.foco;

    final String titulo = foiModoFoco
        ? 'Sessão de Foco Concluída! 🎉'
        : 'Pausa Finalizada! ⚡';

    final String mensagem = foiModoFoco
        ? (isPausaLonga
            ? 'Excelente trabalho! Você completou ${PomodoroController.ciclosPorSessao} ciclos. Aproveite uma Pausa Longa de 15 minutos!'
            : 'Parabéns pelo foco! Que tal uma Pausa Curta de 5 minutos?')
        : 'Sua pausa chegou ao fim. Pronto para mais um ciclo de foco?';

    final String botaoTexto = foiModoFoco
        ? (isPausaLonga ? 'Iniciar Pausa Longa' : 'Iniciar Pausa Curta')
        : 'Voltar ao Foco';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final primaryColor = Theme.of(ctx).colorScheme.primary;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            titulo,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Text(
            mensagem,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.confirmarConclusao();
                controller.reiniciar();
                _dialogShowing = false;
              },
              child: const Text('Agora não'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.confirmarConclusao();
                controller.selecionarModo(proximoModo);
                controller.iniciar();
                _dialogShowing = false;
              },
              child: Text(botaoTexto),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.pomodoroController;

    return Scaffold(
      appBar: AppHeader(
        title: 'Temporizador Pomodoro',
        subtitle: 'Concentre-se. Descanse. Repita.',
        authController: widget.authController,
        themeController: widget.themeController,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),

                            PomodoroModeSelector(
                              selectedMode: controller.modoAtual,
                              onModeSelected: controller.selecionarModo,
                            ),

                            const Spacer(),

                            PomodoroTimerCircle(
                              mode: controller.modoAtual,
                              remainingSeconds: controller.segundosRestantes,
                              totalSeconds:
                                  controller.modoAtual.duracaoSegundos,
                              diameter: 250,
                            ),

                            const Spacer(),

                            PomodoroActionButtons(
                              isRunning: controller.estaExecutando,
                              onStartPause: controller.alternarExecucao,
                              onReset: controller.reiniciar,
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }
}
