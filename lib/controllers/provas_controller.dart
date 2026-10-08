import 'package:flutter/foundation.dart';

import '../models/prova.dart';

class ProvasController extends ChangeNotifier {
  final Map<String, List<Prova>> _provasPorUsuario = {};

  List<Prova> _provas = [];

  void descartarDadosDe(String usuario) {
    _provasPorUsuario.remove(usuario);
  }

  void trocarUsuario(String? usuario) {
    _provas = usuario == null
        ? []
        : _provasPorUsuario.putIfAbsent(usuario, () => []);
    notifyListeners();
  }

  bool get estaVazio => _provas.isEmpty;

  List<Prova> get provas {
    final lista = [..._provas]..sort((a, b) => a.data.compareTo(b.data));
    return lista;
  }

  List<Prova> proximas({int limite = 3}) => provas.take(limite).toList();

  void adicionar(Prova prova) {
    _provas.add(prova);
    notifyListeners();
  }

  void editar(Prova provaAntiga, Prova provaEditada) {
    final index = _provas.indexOf(provaAntiga);
    if (index == -1) return;
    _provas[index] = provaEditada;
    notifyListeners();
  }

  void remover(Prova prova) {
    _provas.remove(prova);
    notifyListeners();
  }
}
