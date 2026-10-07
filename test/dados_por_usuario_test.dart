import 'package:appestudos/controllers/auth_controller.dart';
import 'package:appestudos/controllers/provas_controller.dart';
import 'package:appestudos/controllers/tarefas_controller.dart';
import 'package:appestudos/models/tarefa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testesDeConta();

  test('cada usuário enxerga apenas as próprias tarefas', () {
    final tarefas = TarefasController();
    final provas = ProvasController();

    tarefas.trocarUsuario('aluno');
    provas.trocarUsuario('aluno');
    expect(tarefas.estaVazio, isTrue);

    tarefas.adicionar(
      Tarefa(
        titulo: 'Estudar',
        materia: 'Matemática',
        prioridade: Prioridade.alta,
      ),
    );
    expect(tarefas.estaVazio, isFalse);

    tarefas.trocarUsuario('maria');
    expect(tarefas.estaVazio, isTrue);

    tarefas.trocarUsuario('aluno');
    expect(tarefas.tarefasFiltradas.length, 1);

    tarefas.trocarUsuario(null);
    expect(tarefas.estaVazio, isTrue);
  });

  test('AuthController informa o usuário logado', () async {
    final auth = AuthController();
    expect(await auth.login('aluno', 'estudo@2026'), isNull);
    expect(auth.usuarioLogado, 'aluno');
    auth.logout();
    expect(auth.usuarioLogado, isNull);
  });
}

void testesDeConta() {
  test('trocar senha exige a senha atual correta', () async {
    final auth = AuthController();
    await auth.login('aluno', 'estudo@2026');

    expect(await auth.alterarSenha('errada', 'nova@1234'), isNotNull);
    expect(await auth.alterarSenha('estudo@2026', 'nova@1234'), isNull);

    auth.logout();
    expect(await auth.login('aluno', 'estudo@2026'), isNotNull);
    expect(await auth.login('aluno', 'nova@1234'), isNull);
  });

  test('excluir conta exige senha e apaga o usuário e seus dados', () async {
    final auth = AuthController();
    final tarefas = TarefasController();
    auth.aoExcluirConta = tarefas.descartarDadosDe;

    await auth.login('aluno', 'estudo@2026');
    tarefas.trocarUsuario('aluno');
    tarefas.adicionar(
      Tarefa(
        titulo: 'Estudar',
        materia: 'Matemática',
        prioridade: Prioridade.alta,
      ),
    );

    expect(await auth.excluirConta('errada'), isNotNull);
    expect(auth.isLogado, isTrue);

    expect(await auth.excluirConta('estudo@2026'), isNull);
    expect(auth.isLogado, isFalse);
    expect(await auth.login('aluno', 'estudo@2026'), isNotNull);

    tarefas.trocarUsuario('aluno');
    expect(tarefas.estaVazio, isTrue);
  });
}
