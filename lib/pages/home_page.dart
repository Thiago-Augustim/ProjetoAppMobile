import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/pomodoro_controller.dart';
import '../controllers/provas_controller.dart';
import '../controllers/tarefas_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/pomodoro_mode.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/home_proxima_prova_tile.dart';
import '../widgets/home_proximo_prazo_tile.dart';
import '../widgets/home_stat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.tarefasController,
    required this.provasController,
    required this.authController,
    required this.themeController,
    this.pomodoroController,
    super.key,
  });

  final TarefasController tarefasController;
  final ProvasController provasController;
  final PomodoroController? pomodoroController;
  final AuthController authController;
  final ThemeController themeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.tarefasController.addListener(_rebuild);
    widget.provasController.addListener(_rebuild);
    widget.pomodoroController?.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tarefasController != widget.tarefasController) {
      oldWidget.tarefasController.removeListener(_rebuild);
      widget.tarefasController.addListener(_rebuild);
    }
    if (oldWidget.provasController != widget.provasController) {
      oldWidget.provasController.removeListener(_rebuild);
      widget.provasController.addListener(_rebuild);
    }
    if (oldWidget.pomodoroController != widget.pomodoroController) {
      oldWidget.pomodoroController?.removeListener(_rebuild);
      widget.pomodoroController?.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    widget.tarefasController.removeListener(_rebuild);
    widget.provasController.removeListener(_rebuild);
    widget.pomodoroController?.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  String get _dataDeHoje {
    const diasDaSemana = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    const meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    final hoje = DateTime.now();
    final diaDaSemana = diasDaSemana[hoje.weekday - 1];
    final mes = meses[hoje.month - 1];
    return '$diaDaSemana, ${hoje.day} de $mes de ${hoje.year}';
  }

  String _formatarSegundos(int segundos) {
    final minutos = (segundos ~/ 60).toString().padLeft(2, '0');
    final restante = (segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$restante';
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = widget.tarefasController;
    final provas = widget.provasController;
    final pomodoro = widget.pomodoroController;

    final modoPomodoro = pomodoro?.modoAtual ?? PomodoroMode.foco;
    final segundosRestantes =
        pomodoro?.segundosRestantes ?? PomodoroMode.foco.duracaoSegundos;
    final pomodoroExecutando = pomodoro?.estaExecutando ?? false;

    final proximosPrazos = tarefas.proximosPrazos();
    final proximasProvas = provas.proximas();

    return Scaffold(
      appBar: AppHeader(
        title: 'Início',
        authController: widget.authController,
        themeController: widget.themeController,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            'Bom dia! 👋',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(_dataDeHoje, style: TextStyle(color: Colors.blueGrey.shade300)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              HomeStatCard(
                valor: tarefas.pendentesCount,
                rotulo: 'Pendentes',
                corTexto: Colors.blueGrey.shade700,
                corDeFundo: Colors.blueGrey.shade50,
              ),
              HomeStatCard(
                valor: tarefas.concluidasCount,
                rotulo: 'Concluídas',
                corTexto: Colors.green.shade700,
                corDeFundo: Colors.green.shade50,
              ),
              HomeStatCard(
                valor: tarefas.urgentesCount,
                rotulo: 'Urgentes',
                corTexto: Colors.red.shade700,
                corDeFundo: Colors.red.shade50,
              ),
              HomeStatCard(
                valor: proximosPrazos.length,
                rotulo: 'Com prazo próximo',
                corTexto: Colors.blue.shade700,
                corDeFundo: Colors.blue.shade50,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionCard(
            titulo: 'Próximas tarefas',
            child: proximosPrazos.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Nenhuma tarefa com prazo definido'),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < proximosPrazos.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        HomeProximoPrazoTile(tarefa: proximosPrazos[i]),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            titulo: 'Próximas Provas',
            child: proximasProvas.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Nenhuma prova cadastrada'),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < proximasProvas.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        HomeProximaProvaTile(prova: proximasProvas[i]),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            titulo: 'Pomodoro',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarSegundos(segundosRestantes),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pomodoroExecutando
                          ? '${modoPomodoro.titulo} · em andamento'
                          : '${modoPomodoro.titulo} · pausado',
                      style: TextStyle(color: Colors.blueGrey.shade300),
                    ),
                  ],
                ),
                Icon(
                  modoPomodoro.icone,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child,
        ],
      ),
    );
  }
}
