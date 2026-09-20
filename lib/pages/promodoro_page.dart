import 'package:flutter/material.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class PromodoroPage extends StatelessWidget {
  const PromodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promodoro'),
      ),
      body: const Center(
        child: Text('Conteudo da pagina de promodoro'),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }
}
