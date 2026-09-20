import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/provas_page.dart';
import 'pages/promodoro_page.dart';
import 'pages/tarefas_page.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Estudos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routes: {
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.tarefas: (_) => const TarefasPage(),
        AppRoutes.promodoro: (_) => const PromodoroPage(),
        AppRoutes.provas: (_) => const ProvasPage(),
      },
    );
  }
}
