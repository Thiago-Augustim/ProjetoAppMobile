import 'package:flutter/material.dart';

import '../controllers/pomodoro_controller.dart';
import '../core/app_state.dart';
import '../models/pomodoro_mode.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/pomodoro_action_buttons.dart';
import '../widgets/pomodoro_mode_selector.dart';
import '../widgets/pomodoro_timer_circle.dart';

class PromodoroPage extends StatefulWidget {
  const PromodoroPage({super.key});

  @override
  State<PromodoroPage> createState() => _PromodoroPageState();
}

class _PromodoroPageState extends State<PromodoroPage> {
  PomodoroController? _controller;

  // Evita abrir dois diálogos se o evento chegar antes do frame ser renderizado.
  bool _dialogShowing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = AppState.of(context).pomodoroController;
    if (_controller != newController) {
      _controller?.removeListener(_onControllerUpdate);
      _controller = newController;
      _controller!.addListener(_onControllerUpdate);
    }

    // Ao entrar na página, verifica se o timer terminou enquanto o usuário
    // estava em outra aba e exibe o diálogo no próximo frame.
    if (_controller!.completion != null && !_dialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onControllerUpdate());
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final completion = _controller?.completion;
    if (completion != null && !_dialogShowing) {
      _dialogShowing = true;
      _exibirDialogoConclusao(completion);
    }
  }

  void _exibirDialogoConclusao(PomodoroCompletion completion) {
    final controller = _controller!;

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
    return Scaffold(
      appBar: const AppHeader(
        title: 'Temporizador Pomodoro',
        subtitle: 'Concentre-se. Descanse. Repita.',
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: AppState.of(context).pomodoroController,
          builder: (context, _) {
            final controller = AppState.of(context).pomodoroController;
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

                            // Seletor de modo (Foco / Pausa Curta / Pausa Longa)
                            PomodoroModeSelector(
                              selectedMode: controller.modoAtual,
                              onModeSelected: controller.selecionarModo,
                            ),

                            const Spacer(),

                            // Relógio circular com progresso
                            PomodoroTimerCircle(
                              mode: controller.modoAtual,
                              remainingSeconds: controller.segundosRestantes,
                              totalSeconds:
                                  controller.modoAtual.duracaoSegundos,
                              diameter: 250,
                            ),

                            const Spacer(),

                            // Botões Reiniciar e Iniciar/Pausar
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
