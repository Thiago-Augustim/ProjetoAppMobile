import 'package:flutter/foundation.dart';

import '../models/tarefa.dart';
import '../widgets/tarefa_filters.dart';

class TarefasController extends ChangeNotifier {
  final Map<String, List<Tarefa>> _tarefasPorUsuario = {};

  List<Tarefa> _tarefas = [];
  FiltroStatus _filtroStatus = FiltroStatus.todas;
  FiltroPrioridade _filtroPrioridade = FiltroPrioridade.todas;

  void descartarDadosDe(String usuario) {
    _tarefasPorUsuario.remove(usuario);
  }

  void trocarUsuario(String? usuario) {
    _tarefas = usuario == null
        ? []
        : _tarefasPorUsuario.putIfAbsent(usuario, () => []);
    _filtroStatus = FiltroStatus.todas;
    _filtroPrioridade = FiltroPrioridade.todas;
    notifyListeners();
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

  void adicionar(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void remover(Tarefa tarefa) {
    _tarefas.remove(tarefa);
    notifyListeners();
  }

  void alternarStatus(Tarefa tarefa, bool? concluida) {
    tarefa.concluida = concluida ?? false;
    notifyListeners();
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
