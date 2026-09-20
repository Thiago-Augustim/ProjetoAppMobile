import 'package:flutter/material.dart';

import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';

class ProvasPage extends StatelessWidget {
  const ProvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Provas'),
      body: const Center(child: Text('Conteudo da pagina de provas')),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
    );
  }
}
