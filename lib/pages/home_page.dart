import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Home'),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
