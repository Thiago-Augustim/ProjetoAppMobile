import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/tarefas_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/tarefa.dart';
import '../services/camera_service.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/nova_tarefa_dialog.dart';
import '../widgets/tarefa_card.dart';
import '../widgets/tarefa_filters.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({
    required this.tarefasController,
    required this.authController,
    required this.themeController,
    this.cameraService,
    super.key,
  });

  final TarefasController tarefasController;
  final AuthController authController;
  final ThemeController themeController;
  final CameraService? cameraService;

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  @override
  void initState() {
    super.initState();
    widget.tarefasController.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(TarefasPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tarefasController != widget.tarefasController) {
      oldWidget.tarefasController.removeListener(_rebuild);
      widget.tarefasController.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    widget.tarefasController.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Future<void> _adicionarTarefa() async {
    final tarefa = await showDialog<Tarefa>(
      context: context,
      builder: (_) => NovaTarefaDialog(cameraService: widget.cameraService),
    );
    if (tarefa != null && mounted) {
      widget.tarefasController.adicionar(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.tarefasController;

    return Scaffold(
      appBar: AppHeader(
        title: 'Tarefas',
        subtitle: controller.resumo,
        authController: widget.authController,
        themeController: widget.themeController,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TarefaFilters(
            status: controller.filtroStatus,
            prioridade: controller.filtroPrioridade,
            onStatusChanged: controller.setFiltroStatus,
            onPrioridadeChanged: controller.setFiltroPrioridade,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: controller.estaVazio
                ? const Center(child: Text('Nenhuma tarefa cadastrada'))
                : controller.tarefasFiltradas.isEmpty
                    ? const Center(child: Text('Nenhuma tarefa encontrada'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                        itemCount: controller.tarefasFiltradas.length,
                        itemBuilder: (context, index) {
                          final tarefa = controller.tarefasFiltradas[index];
                          return Dismissible(
                            key: ObjectKey(tarefa),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) => controller.remover(tarefa),
                            child: TarefaCard(
                              tarefa: tarefa,
                              onStatusChanged: (value) =>
                                  controller.alternarStatus(tarefa, value),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarTarefa,
        tooltip: 'Adicionar tarefa',
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
