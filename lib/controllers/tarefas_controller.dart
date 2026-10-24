import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/tarefa.dart';
import '../services/pocketbase_service.dart';
import '../widgets/tarefa_filters.dart';

class TarefasController extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Tarefa> _tarefas = [];
  bool _carregando = false;
  FiltroStatus _filtroStatus = FiltroStatus.todas;
  FiltroPrioridade _filtroPrioridade = FiltroPrioridade.todas;

  bool get carregando => _carregando;

  void descartarDadosDe(String usuario) {
    _tarefas = [];
    notifyListeners();
  }

  void trocarUsuario(String? usuario) {
    _tarefas = [];
    _filtroStatus = FiltroStatus.todas;
    _filtroPrioridade = FiltroPrioridade.todas;
    notifyListeners();

    if (usuario != null) {
      carregarTarefas();
    }
  }

  Future<void> carregarTarefas() async {
    final userId = PocketBaseService.instance.currentUserId;
    if (userId == null) return;

    _carregando = true;
    notifyListeners();

    try {
      final records = await _pb.collection('tarefas').getFullList(
        filter: 'user = "$userId"',
        sort: '-created',
      );
      _tarefas = records.map((r) => Tarefa.fromRecord(r)).toList();
    } catch (e) {
      debugPrint('Erro ao carregar tarefas do PocketBase: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  FiltroStatus get filtroStatus => _filtroStatus;
  FiltroPrioridade get filtroPrioridade => _filtroPrioridade;
  bool get estaVazio => _tarefas.isEmpty;

  List<Tarefa> get tarefasFiltradas {
    return _tarefas.where((tarefa) {
      final correspondeAoStatus = switch (_filtroStatus) {
        FiltroStatus.todas => true,
        FiltroStatus.pendentes => !tarefa.concluida,
        FiltroStatus.concluidas => tarefa.concluida,
      };
      final correspondeAPrioridade = switch (_filtroPrioridade) {
        FiltroPrioridade.todas => true,
        FiltroPrioridade.alta => tarefa.prioridade == Prioridade.alta,
        FiltroPrioridade.media => tarefa.prioridade == Prioridade.media,
        FiltroPrioridade.baixa => tarefa.prioridade == Prioridade.baixa,
      };
      return correspondeAoStatus && correspondeAPrioridade;
    }).toList();
  }

  String get resumo {
    final quantidade = tarefasFiltradas.length;
    final texto = quantidade == 1 ? 'tarefa' : 'tarefas';
    return '$quantidade $texto encontradas';
  }

  int get pendentesCount => _tarefas.where((t) => !t.concluida).length;

  int get concluidasCount => _tarefas.where((t) => t.concluida).length;

  int get urgentesCount => _tarefas
      .where((t) => !t.concluida && t.prioridade == Prioridade.alta)
      .length;

  List<Tarefa> proximosPrazos({int limite = 5}) {
    final comPrazo = _tarefas
        .where((t) => !t.concluida && t.prazo != null)
        .toList()
      ..sort((a, b) => a.prazo!.compareTo(b.prazo!));
    return comPrazo.take(limite).toList();
  }

  Future<void> adicionar(Tarefa tarefa) async {
    _tarefas.insert(0, tarefa);
    notifyListeners();

    final userId = PocketBaseService.instance.currentUserId;
    if (userId != null) {
      try {
        final record = await _pb.collection('tarefas').create(
          body: tarefa.toJson(userId: userId),
        );
        final index = _tarefas.indexOf(tarefa);
        if (index != -1) {
          _tarefas[index] = Tarefa.fromRecord(record);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Erro ao salvar tarefa no PocketBase: $e');
      }
    }
  }

  Future<void> remover(Tarefa tarefa) async {
    _tarefas.remove(tarefa);
    notifyListeners();

    if (tarefa.id != null) {
      try {
        await _pb.collection('tarefas').delete(tarefa.id!);
      } catch (e) {
        debugPrint('Erro ao excluir tarefa no PocketBase: $e');
      }
    }
  }

  Future<void> alternarStatus(Tarefa tarefa, bool? concluida) async {
    tarefa.concluida = concluida ?? false;
    notifyListeners();

    if (tarefa.id != null) {
      try {
        await _pb.collection('tarefas').update(
          tarefa.id!,
          body: {'concluida': tarefa.concluida},
        );
      } catch (e) {
        debugPrint('Erro ao atualizar status da tarefa no PocketBase: $e');
      }
    }
  }

  void setFiltroStatus(FiltroStatus status) {
    if (_filtroStatus == status) return;
    _filtroStatus = status;
    notifyListeners();
  }

  void setFiltroPrioridade(FiltroPrioridade prioridade) {
    if (_filtroPrioridade == prioridade) return;
    _filtroPrioridade = prioridade;
    notifyListeners();
  }
}

