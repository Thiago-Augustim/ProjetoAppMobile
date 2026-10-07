import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_state.dart';
import '../widgets/alterar_senha_dialog.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/excluir_conta_dialog.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  Future<void> _alterarSenha(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final alterou = await showDialog<bool>(
      context: context,
      builder: (_) => const AlterarSenhaDialog(),
    );

    if (alterou == true) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso.')),
      );
    }
  }

  Future<void> _excluirConta(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final excluiu = await showDialog<bool>(
      context: context,
      builder: (_) => const ExcluirContaDialog(),
    );

    if (excluiu != true) {
      return;
    }

    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    messenger.showSnackBar(
      const SnackBar(content: Text('Conta excluída com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AppState.of(context).authController.usuarioLogado ?? '';

    return Scaffold(
      appBar: const AppHeader(
        title: 'Configurações',
        subtitle: 'Gerencie sua conta',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            'Conectado como $usuario',
            style: TextStyle(color: Colors.blueGrey.shade300),
          ),
          const SizedBox(height: 16),
          _OpcaoCard(
            icone: Icons.lock_reset,
            titulo: 'Trocar senha',
            descricao: 'Altere a senha da sua conta',
            onTap: () => _alterarSenha(context),
          ),
          _OpcaoCard(
            icone: Icons.delete_forever_outlined,
            titulo: 'Excluir conta',
            descricao: 'Apague sua conta e todos os seus dados',
            cor: Theme.of(context).colorScheme.error,
            onTap: () => _excluirConta(context),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
    );
  }
}

class _OpcaoCard extends StatelessWidget {
  const _OpcaoCard({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.onTap,
    this.cor,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(icone, color: cor),
        title: Text(
          titulo,
          style: TextStyle(fontWeight: FontWeight.w600, color: cor),
        ),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
