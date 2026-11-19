import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/pomodoro_controller.dart';
import 'package:appestudos/controllers/provas_controller.dart';
import 'package:appestudos/controllers/tarefas_controller.dart';
import 'package:appestudos/core/app_routes.dart';
import 'package:appestudos/main.dart';
import 'package:appestudos/services/pocketbase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthController extends AuthController {
  String? _fakeUsuario;

  @override
  String? get usuarioLogado => _fakeUsuario;

  @override
  bool get isLogado => _fakeUsuario != null;

  void simularLogin(String usuario) {
    _fakeUsuario = usuario;
    notifyListeners();
  }

  @override
  void logout() {
    _fakeUsuario = null;
    notifyListeners();
  }
}

class _TrackingTarefasController extends TarefasController {
  _TrackingTarefasController({
    required PocketBaseService super.service,
    required this.onDispose,
  });

  final VoidCallback onDispose;

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

class _TrackingProvasController extends ProvasController {
  _TrackingProvasController({
    required PocketBaseService super.service,
    required this.onDispose,
  });

  final VoidCallback onDispose;

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

class _TrackingPomodoroController extends PomodoroController {
  _TrackingPomodoroController({required this.onDispose});

  final VoidCallback onDispose;

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

void main() {
  testWidgets(
    'LoginPage e CadastroPage não instanciam controllers de domínio',
    (tester) async {
      var tarefasCriadas = 0;
      var provasCriadas = 0;
      var pomodoroCriados = 0;

      final auth = _FakeAuthController();

      await tester.pumpWidget(
        StudyApp(
          authController: auth,
          criarTarefasController: (service) {
            tarefasCriadas++;
            return _TrackingTarefasController(
              service: service,
              onDispose: () {},
            );
          },
          criarProvasController: (service) {
            provasCriadas++;
            return _TrackingProvasController(
              service: service,
              onDispose: () {},
            );
          },
          criarPomodoroController: () {
            pomodoroCriados++;
            return _TrackingPomodoroController(onDispose: () {});
          },
        ),
      );

      expect(find.text('Bem-vindo!'), findsOneWidget);
      expect(tarefasCriadas, 0);
      expect(provasCriadas, 0);
      expect(pomodoroCriados, 0);

      await tester.tap(find.text('Não tem conta? Cadastre-se'));
      await tester.pumpAndSettle();

      expect(find.text('Criar conta'), findsOneWidget);
      expect(tarefasCriadas, 0);
      expect(provasCriadas, 0);
      expect(pomodoroCriados, 0);

      auth.dispose();
    },
  );

  testWidgets(
    'Controllers são criados sob demanda por rota e descartados (dispose) no logout',
    (tester) async {
      var tarefasCriadas = 0;
      var tarefasDisposed = 0;
      var provasCriadas = 0;
      var provasDisposed = 0;
      var pomodoroCriados = 0;
      var pomodoroDisposed = 0;

      final auth = _FakeAuthController();

      await tester.pumpWidget(
        StudyApp(
          authController: auth,
          criarTarefasController: (service) {
            tarefasCriadas++;
            return _TrackingTarefasController(
              service: service,
              onDispose: () => tarefasDisposed++,
            );
          },
          criarProvasController: (service) {
            provasCriadas++;
            return _TrackingProvasController(
              service: service,
              onDispose: () => provasDisposed++,
            );
          },
          criarPomodoroController: () {
            pomodoroCriados++;
            return _TrackingPomodoroController(
              onDispose: () => pomodoroDisposed++,
            );
          },
        ),
      );

      auth.simularLogin('aluno');
      expect(tarefasCriadas, 0);
      expect(provasCriadas, 0);
      expect(pomodoroCriados, 0);

      // Navega direto para Tarefas -> cria apenas TarefasController
      final navContext = tester.element(find.byType(Scaffold));
      Navigator.of(navContext).pushReplacementNamed(AppRoutes.tarefas);
      await tester.pumpAndSettle();

      expect(tarefasCriadas, 1);
      expect(provasCriadas, 0);
      expect(pomodoroCriados, 0);

      // Navega pela barra inferior para Pomodoro -> cria apenas PomodoroController
      await tester.tap(find.text('Promodoro'));
      await tester.pumpAndSettle();

      expect(tarefasCriadas, 1);
      expect(provasCriadas, 0);
      expect(pomodoroCriados, 1);

      // Volta para Tarefas -> reutiliza instância já criada
      await tester.tap(find.text('Tarefas'));
      await tester.pumpAndSettle();

      expect(tarefasCriadas, 1);
      expect(tarefasDisposed, 0);

      // Faz logout -> descarta (dispose) os controllers criados e não toca em Provas
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo!'), findsOneWidget);
      expect(tarefasDisposed, 1);
      expect(pomodoroDisposed, 1);
      expect(provasCriadas, 0);
      expect(provasDisposed, 0);

      // Novo login + acesso a Provas -> cria apenas ProvasController
      auth.simularLogin('maria');
      final loginContext = tester.element(find.byType(Scaffold));
      Navigator.of(loginContext).pushReplacementNamed(AppRoutes.provas);
      await tester.pumpAndSettle();

      expect(provasCriadas, 1);
      expect(tarefasCriadas, 1);
      expect(pomodoroCriados, 1);

      auth.dispose();
    },
  );

  testWidgets(
    'HomePage mantém PomodoroController lazy até uso e sincroniza quando ativo',
    (tester) async {
      var tarefasCriadas = 0;
      var provasCriadas = 0;
      var pomodoroCriados = 0;
      var pomodoroDisposed = 0;

      final auth = _FakeAuthController();

      await tester.pumpWidget(
        StudyApp(
          authController: auth,
          criarTarefasController: (service) {
            tarefasCriadas++;
            return _TrackingTarefasController(
              service: service,
              onDispose: () {},
            );
          },
          criarProvasController: (service) {
            provasCriadas++;
            return _TrackingProvasController(
              service: service,
              onDispose: () {},
            );
          },
          criarPomodoroController: () {
            pomodoroCriados++;
            return _TrackingPomodoroController(
              onDispose: () => pomodoroDisposed++,
            );
          },
        ),
      );

      auth.simularLogin('aluno');
      final loginContext = tester.element(find.byType(Scaffold));
      Navigator.of(loginContext).pushReplacementNamed(AppRoutes.home);
      await tester.pumpAndSettle();

      // Home cria Tarefas e Provas, mas NÃO instancia PomodoroController
      expect(tarefasCriadas, 1);
      expect(provasCriadas, 1);
      expect(pomodoroCriados, 0);

      await tester.scrollUntilVisible(
        find.text('25:00'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('Foco · pausado'), findsOneWidget);

      // Abre a aba Pomodoro e inicia o cronômetro
      await tester.tap(find.text('Promodoro'));
      await tester.pumpAndSettle();
      expect(pomodoroCriados, 1);

      await tester.tap(find.text('Iniciar'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('24:55'), findsOneWidget);

      // Volta para a Home e verifica sincronização ao vivo
      await tester.tap(find.text('Home'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pump();

      expect(find.text('24:55'), findsOneWidget);
      expect(find.text('Foco · em andamento'), findsOneWidget);

      // Logout cancela timer e faz dispose do controller
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(pomodoroDisposed, 1);

      auth.dispose();
    },
  );
}
