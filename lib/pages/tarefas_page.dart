import 'package:flutter/material.dart';

import '../controllers/tarefas_controller.dart';
import '../core/app_state.dart';
import '../models/tarefa.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/nova_tarefa_dialog.dart';
import '../widgets/tarefa_card.dart';
import '../widgets/tarefa_filters.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  TarefasController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = AppState.of(context).tarefasController;
    if (_controller != newController) {
      _controller?.removeListener(_rebuild);
      _controller = newController;
      _controller!.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Future<void> _adicionarTarefa() async {
    final tarefa = await showDialog<Tarefa>(
      context: context,
      builder: (_) => const NovaTarefaDialog(),
    );
    if (tarefa != null && mounted) {
      _controller!.adicionar(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;

    return Scaffold(
      appBar: AppHeader(
        title: 'Tarefas',
        subtitle: controller.resumo,
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
