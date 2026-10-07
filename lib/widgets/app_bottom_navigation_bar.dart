import 'package:flutter/material.dart';

import '../core/app_routes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({required this.currentIndex, super.key});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == currentIndex) {
          return;
        }

        Navigator.pushReplacementNamed(context, AppRoutes.all[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Tarefas'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Promodoro'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Provas'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ],
    );
  }
}
