import 'dart:convert';
import 'dart:typed_data';

import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/tarefas_controller.dart';
import 'package:appestudos/controllers/theme_controller.dart';
import 'package:appestudos/pages/tarefas_page.dart';
import 'package:appestudos/services/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// PNG 1x1 transparente válido para Image.memory nos testes de widget
final Uint8List _kTransparentPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
);

class _FakeCameraService extends CameraService {
  _FakeCameraService({this.fotoRetorno});

  FotoCapturada? fotoRetorno;
  int chamadas = 0;

  @override
  Future<FotoCapturada?> tirarFoto() async {
    chamadas++;
    return fotoRetorno;
  }
}

void main() {
  testWidgets(
    'Permite tirar foto no modal de Nova Tarefa, exibir miniatura no card e ampliar ao tocar',
    (tester) async {
      final fakeCamera = _FakeCameraService(
        fotoRetorno: FotoCapturada(
          bytes: _kTransparentPng,
          nomeArquivo: 'caderno.jpg',
        ),
      );
      final tarefasController = TarefasController();
      final authController = AuthController();
      final themeController = ThemeController();

      await tester.pumpWidget(
        MaterialApp(
          home: TarefasPage(
            tarefasController: tarefasController,
            authController: authController,
            themeController: themeController,
            cameraService: fakeCamera,
          ),
        ),
      );

      // Abre o modal de Nova Tarefa
      await tester.tap(find.text('Nova Tarefa'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('btn_tirar_foto_tarefa')), findsOneWidget);
      expect(find.byKey(const Key('preview_foto_nova_tarefa')), findsNothing);

      // Tira uma foto
      await tester.tap(find.byKey(const Key('btn_tirar_foto_tarefa')));
      await tester.pumpAndSettle();

      expect(fakeCamera.chamadas, 1);
      expect(
        find.byKey(const Key('preview_foto_nova_tarefa')),
        findsOneWidget,
      );

      // Preenche os dados obrigatórios da tarefa e salva
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Título'),
        'Resolver lista 3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Matéria'),
        'Física',
      );
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();

      // Verifica se a tarefa foi criada com a foto e exibe a miniatura no card
      expect(tarefasController.tarefasFiltradas.length, 1);
      expect(tarefasController.tarefasFiltradas.first.possuiFoto, isTrue);
      expect(
        tarefasController.tarefasFiltradas.first.fotoNome,
        'caderno.jpg',
      );
      expect(find.byKey(const Key('miniatura_foto_tarefa')), findsOneWidget);

      // Toca na miniatura para abrir a foto ampliada
      await tester.tap(find.byKey(const Key('miniatura_foto_tarefa')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('dialog_foto_ampliada_tarefa')),
        findsOneWidget,
      );

      // Fecha o diálogo da foto ampliada
      await tester.tap(find.byTooltip('Fechar'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('dialog_foto_ampliada_tarefa')),
        findsNothing,
      );

      tarefasController.dispose();
      authController.dispose();
      themeController.dispose();
    },
  );

  testWidgets('Permite remover a foto capturada antes de salvar a tarefa', (
    tester,
  ) async {
    final fakeCamera = _FakeCameraService(
      fotoRetorno: FotoCapturada(
        bytes: _kTransparentPng,
        nomeArquivo: 'rascunho.jpg',
      ),
    );
    final tarefasController = TarefasController();
    final authController = AuthController();
    final themeController = ThemeController();

    await tester.pumpWidget(
      MaterialApp(
        home: TarefasPage(
          tarefasController: tarefasController,
          authController: authController,
          themeController: themeController,
          cameraService: fakeCamera,
        ),
      ),
    );

    await tester.tap(find.text('Nova Tarefa'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_tirar_foto_tarefa')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('preview_foto_nova_tarefa')), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('btn_remover_foto_tarefa')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('btn_remover_foto_tarefa')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview_foto_nova_tarefa')), findsNothing);
    expect(find.byKey(const Key('btn_tirar_foto_tarefa')), findsOneWidget);

    tarefasController.dispose();
    authController.dispose();
    themeController.dispose();
  });
}
