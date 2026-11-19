import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/theme_controller.dart';
import 'package:appestudos/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppHeader renders correctly and toggles theme', (tester) async {
    final authController = AuthController();
    final themeController = ThemeController();

    await tester.pumpWidget(
      AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeController.themeMode,
            home: Scaffold(
              appBar: AppHeader(
                title: 'Temporizador Pomodoro',
                subtitle: 'Concentre-se. Descanse. Repita.',
                authController: authController,
                themeController: themeController,
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('Temporizador Pomodoro'), findsOneWidget);
    expect(find.text('Concentre-se. Descanse. Repita.'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pumpAndSettle();

    expect(themeController.isDarkMode, isTrue);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode_outlined));
    await tester.pumpAndSettle();

    expect(themeController.isDarkMode, isFalse);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    authController.dispose();
    themeController.dispose();
  });
}
