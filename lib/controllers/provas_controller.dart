import 'package:flutter/foundation.dart';

import '../models/prova.dart';

/// Gerencia a lista de provas, sempre ordenada pela data mais próxima.
///
/// Por viver fora da árvore de widgets, os dados persistem enquanto o app
/// estiver aberto — independente de quantas vezes o usuário troque de aba.
class ProvasController extends ChangeNotifier {
  final List<Prova> _provas = [];

  bool get estaVazio => _provas.isEmpty;

  List<Prova> get provas {
    final lista = [..._provas]..sort((a, b) => a.data.compareTo(b.data));
    return lista;
  }

  /// As [limite] provas mais próximas, usado no resumo da Home.
  List<Prova> proximas({int limite = 3}) => provas.take(limite).toList();

  void adicionar(Prova prova) {
    _provas.add(prova);
    notifyListeners();
  }

  void remover(Prova prova) {
    _provas.remove(prova);
    notifyListeners();
  }
}
