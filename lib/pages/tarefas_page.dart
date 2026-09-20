import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/tarefa_card.dart';
import '../widgets/tarefa_filters.dart';
import '../widgets/nova_tarefa_dialog.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final List<Tarefa> _tarefas = [];
  FiltroStatus _filtroStatus = FiltroStatus.todas;
  FiltroPrioridade _filtroPrioridade = FiltroPrioridade.todas;

  Future<void> _adicionarTarefa() async {
    final tarefa = await showDialog<Tarefa>(
      context: context,
      builder: (_) => const NovaTarefaDialog(),
    );

    if (tarefa != null && mounted) {
      setState(() {
        _tarefas.add(tarefa);
      });
    }
  }

  void _alternarStatus(Tarefa tarefa, bool? concluida) {
    setState(() {
      tarefa.concluida = concluida ?? false;
    });
  }

  String get _resumoTarefasEncontradas {
    final quantidade = _tarefasFiltradas.length;
    final textoTarefa = quantidade == 1 ? 'tarefa' : 'tarefas';

    return '$quantidade $textoTarefa encontradas';
  }

  List<Tarefa> get _tarefasFiltradas {
    return _tarefas.where((tarefa) {
      final correspondeAoStatus = switch (_filtroStatus) {
        FiltroStatus.todas => true,
        FiltroStatus.pendentes => !tarefa.concluida,
        FiltroStatus.concluidas => tarefa.concluida,
      };
      final correspondeAPrioridade = switch (_filtroPrioridade) {
        FiltroPrioridade.todas => true,
        FiltroPrioridade.alta => tarefa.prioridade == Prioridade.alta,
        FiltroPrioridade.media => tarefa.prioridade == Prioridade.media,
        FiltroPrioridade.baixa => tarefa.prioridade == Prioridade.baixa,
      };

      return correspondeAoStatus && correspondeAPrioridade;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Tarefas', subtitle: _resumoTarefasEncontradas),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TarefaFilters(
            status: _filtroStatus,
            prioridade: _filtroPrioridade,
            onStatusChanged: (status) {
              setState(() {
                _filtroStatus = status;
              });
            },
            onPrioridadeChanged: (prioridade) {
              setState(() {
                _filtroPrioridade = prioridade;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _tarefas.isEmpty
                ? const Center(child: Text('Nenhuma tarefa cadastrada'))
                : _tarefasFiltradas.isEmpty
                ? const Center(child: Text('Nenhuma tarefa encontrada'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: _tarefasFiltradas.length,
                    itemBuilder: (context, index) {
                      final tarefa = _tarefasFiltradas[index];

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
                        onDismissed: (_) {
                          setState(() {
                            _tarefas.remove(tarefa);
                          });
                        },
                        child: TarefaCard(
                          tarefa: tarefa,
                          onStatusChanged: (value) =>
                              _alternarStatus(tarefa, value),
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
