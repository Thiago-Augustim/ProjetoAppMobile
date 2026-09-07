import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: Text('App Estudos'),
          
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
        ),
    );
  }
}

