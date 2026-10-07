import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/pomodoro_mode.dart';

class PomodoroCompletion {
  const PomodoroCompletion(this.modoCompletado);

  final PomodoroMode modoCompletado;
}

class PomodoroController extends ChangeNotifier {
  static const int ciclosPorSessao = 4;

  PomodoroMode _modoAtual = PomodoroMode.foco;
  late int _segundosRestantes = _modoAtual.duracaoSegundos;
  Timer? _timer;
  bool _estaExecutando = false;
  int _ciclosCompletos = 0;
  PomodoroCompletion? _completion;

  PomodoroMode get modoAtual => _modoAtual;
  int get segundosRestantes => _segundosRestantes;
  bool get estaExecutando => _estaExecutando;
  int get ciclosCompletos => _ciclosCompletos;

  PomodoroCompletion? get completion => _completion;

  void alternarExecucao() {
    _estaExecutando ? pausar() : iniciar();
  }

  void iniciar() {
    _timer?.cancel();
    _estaExecutando = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_segundosRestantes > 0) {
        _segundosRestantes--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _estaExecutando = false;

        if (_modoAtual == PomodoroMode.foco) {
          _ciclosCompletos++;
        }

        _completion = PomodoroCompletion(_modoAtual);
        notifyListeners();
      }
    });
  }

  void pausar() {
    _timer?.cancel();
    _estaExecutando = false;
    notifyListeners();
  }

  void reiniciar() {
    pausar();
    _segundosRestantes = _modoAtual.duracaoSegundos;
    notifyListeners();
  }

  void resetarSessao() {
    _timer?.cancel();
    _estaExecutando = false;
    _modoAtual = PomodoroMode.foco;
    _segundosRestantes = _modoAtual.duracaoSegundos;
    _ciclosCompletos = 0;
    _completion = null;
    notifyListeners();
  }

  void selecionarModo(PomodoroMode novoModo) {
    if (novoModo == _modoAtual) return;
    pausar();
    _modoAtual = novoModo;
    _segundosRestantes = novoModo.duracaoSegundos;
    notifyListeners();
  }

  void confirmarConclusao() {
    _completion = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
