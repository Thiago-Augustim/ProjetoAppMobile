import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../core/app_state.dart';
import 'theme_toggle_button.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle!,
                style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 14),
              ),
            ),
          ],
        ],
      ),
      actions: [
        const ThemeToggleButton(),
        IconButton(
          tooltip: 'Sair',
          icon: const Icon(Icons.logout),
          onPressed: () {
            AppState.of(context).authController.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            'lib/img/StudyFocus.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
