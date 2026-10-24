import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/prova.dart';
import '../services/pocketbase_service.dart';

class ProvasController extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Prova> _provas = [];
  bool _carregando = false;

  bool get carregando => _carregando;

  void descartarDadosDe(String usuario) {
    _provas = [];
    notifyListeners();
  }

  void trocarUsuario(String? usuario) {
    _provas = [];
    notifyListeners();

    if (usuario != null) {
      carregarProvas();
    }
  }

  Future<void> carregarProvas() async {
    final userId = PocketBaseService.instance.currentUserId;
    if (userId == null) return;

    _carregando = true;
    notifyListeners();

    try {
      final records = await _pb.collection('provas').getFullList(
        filter: 'user = "$userId"',
        sort: 'data',
      );
      _provas = records.map((r) => Prova.fromRecord(r)).toList();
    } catch (e) {
      debugPrint('Erro ao carregar provas do PocketBase: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  bool get estaVazio => _provas.isEmpty;

  List<Prova> get provas {
    final lista = [..._provas]..sort((a, b) => a.data.compareTo(b.data));
    return lista;
  }

  List<Prova> proximas({int limite = 3}) => provas.take(limite).toList();

  Future<void> adicionar(Prova prova) async {
    _provas.add(prova);
    notifyListeners();

    final userId = PocketBaseService.instance.currentUserId;
    if (userId != null) {
      try {
        final record = await _pb.collection('provas').create(
          body: prova.toJson(userId: userId),
        );
        final index = _provas.indexOf(prova);
        if (index != -1) {
          _provas[index] = Prova.fromRecord(record);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Erro ao adicionar prova no PocketBase: $e');
      }
    }
  }

  Future<void> editar(Prova provaAntiga, Prova provaEditada) async {
    final index = _provas.indexOf(provaAntiga);
    if (index == -1) return;
    _provas[index] = provaEditada;
    notifyListeners();

    final id = provaAntiga.id ?? provaEditada.id;
    if (id != null) {
      try {
        final record = await _pb.collection('provas').update(
          id,
          body: provaEditada.toJson(),
        );
        final currentIndex = _provas.indexOf(provaEditada);
        if (currentIndex != -1) {
          _provas[currentIndex] = Prova.fromRecord(record);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Erro ao editar prova no PocketBase: $e');
      }
    }
  }

  Future<void> remover(Prova prova) async {
    _provas.remove(prova);
    notifyListeners();

    if (prova.id != null) {
      try {
        await _pb.collection('provas').delete(prova.id!);
      } catch (e) {
        debugPrint('Erro ao excluir prova no PocketBase: $e');
      }
    }
  }
}

