import 'package:flutter/material.dart';
import 'pages/home_page.dart';

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
      home: const HomePage(),
    );
  }
}




