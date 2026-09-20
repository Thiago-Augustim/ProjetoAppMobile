import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/provas_page.dart';
import 'pages/promodoro_page.dart';
import 'pages/tarefas_page.dart';

void main() {
  runApp(StudyApp());
}

class StudyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Estudos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), 
      routes: {
        '/': (_) => const HomePage(),
        '/tarefas': (_) => const TarefasPage(),
        '/promodoro': (_) => const PromodoroPage(),
        '/provas': (_) => const ProvasPage(),
      },
    );
  }
}




