import 'package:flutter/material.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});
  @override
  _TarefasPageState createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
      ),
      body: Center(
        child: Text('Conteúdo da página de tarefas'),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
    );
  }
}