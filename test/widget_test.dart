import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appestudos/widgets/app_header.dart';

void main() {
  testWidgets('AppHeader renders correctly with title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: AppHeader(
            title: 'Temporizador Pomodoro',
            subtitle: 'Concentre-se. Descanse. Repita.',
          ),
        ),
      ),
    );

    expect(find.text('Temporizador Pomodoro'), findsOneWidget);
    expect(find.text('Concentre-se. Descanse. Repita.'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
