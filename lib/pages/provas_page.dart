import 'package:flutter/material.dart';

import '../controllers/provas_controller.dart';
import '../core/app_state.dart';
import '../models/prova.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/nova_prova_dialog.dart';
import '../widgets/prova_card.dart';

class ProvasPage extends StatefulWidget {
  const ProvasPage({super.key});

  @override
  State<ProvasPage> createState() => _ProvasPageState();
}

class _ProvasPageState extends State<ProvasPage> {
  ProvasController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = AppState.of(context).provasController;
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

  Future<void> _adicionarProva() async {
    final prova = await showDialog<Prova>(
      context: context,
      builder: (_) => const NovaProvaDialog(),
    );
    if (prova != null && mounted) {
      _controller!.adicionar(prova);
    }
  }

  Future<void> _editarProva(Prova provaAntiga) async {
    final provaEditada = await showDialog<Prova>(
      context: context,
      builder: (_) => NovaProvaDialog(provaParaEditar: provaAntiga),
    );
    if (provaEditada != null && mounted) {
      _controller!.editar(provaAntiga, provaEditada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    final provas = controller.provas;

    return Scaffold(
      appBar: AppHeader(
        title: 'Provas',
        subtitle: controller.estaVazio
            ? null
            : '${provas.length} ${provas.length == 1 ? 'prova' : 'provas'} cadastradas',
      ),
      body: controller.estaVazio
          ? const Center(child: Text('Nenhuma prova cadastrada'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: provas.length,
              itemBuilder: (context, index) {
                final prova = provas[index];
                return Dismissible(
                  key: ObjectKey(prova),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 10),
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
                  onDismissed: (_) => controller.remover(prova),
                  child: ProvaCard(
                    prova: prova,
                    onTap: () => _editarProva(prova),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarProva,
        tooltip: 'Adicionar prova',
        icon: const Icon(Icons.add),
        label: const Text('Nova Prova'),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
    );
  }
}
