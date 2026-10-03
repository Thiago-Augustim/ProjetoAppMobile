import 'package:flutter/material.dart';

import '../core/app_state.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        IconButton(
          tooltip: isDark ? 'Ativar modo claro' : 'Ativar modo escuro',
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () {
            AppState.of(context).themeController.toggleTheme();
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
