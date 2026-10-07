import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final Map<String, String> _usuarios = {'aluno': 'estudo@2026'};

  String? _usuarioLogado;

  void Function(String usuario)? aoExcluirConta;

  bool get isLogado => _usuarioLogado != null;
  String? get usuarioLogado => _usuarioLogado;

  static String _normalizar(String usuario) => usuario.trim().toLowerCase();

  Future<String?> cadastrar(String usuario, String senha) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final chave = _normalizar(usuario);
    if (_usuarios.containsKey(chave)) {
      return 'Este nome de usuário já está em uso.';
    }

    _usuarios[chave] = senha;
    return null;
  }

  Future<String?> login(String usuario, String senha) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final chave = _normalizar(usuario);
    final senhaCorreta = _usuarios[chave];

    if (senhaCorreta == null || senhaCorreta != senha) {
      return 'Usuário ou senha incorretos.';
    }

    _usuarioLogado = chave;
    notifyListeners();
    return null;
  }

  void logout() {
    _usuarioLogado = null;
    notifyListeners();
  }

  bool senhaConfere(String senha) {
    final usuario = _usuarioLogado;
    return usuario != null && _usuarios[usuario] == senha;
  }

  Future<String?> alterarSenha(String senhaAtual, String novaSenha) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!senhaConfere(senhaAtual)) {
      return 'Senha atual incorreta.';
    }
    if (senhaAtual == novaSenha) {
      return 'A nova senha deve ser diferente da atual.';
    }

    _usuarios[_usuarioLogado!] = novaSenha;
    return null;
  }

  Future<String?> excluirConta(String senha) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!senhaConfere(senha)) {
      return 'Senha incorreta.';
    }

    final usuario = _usuarioLogado!;
    _usuarios.remove(usuario);
    _usuarioLogado = null;
    aoExcluirConta?.call(usuario);
    notifyListeners();
    return null;
  }
}
