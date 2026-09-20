import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    super.key,
  });

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

        final routes = [
          '/',
          '/tarefas',
          '/promodoro',
          '/provas',
        ];

        Navigator.pushReplacementNamed(context, routes[index]);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Promodoro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Provas',
        ),
      ],
    );
  }
}
