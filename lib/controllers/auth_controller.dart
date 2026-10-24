import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../services/pocketbase_service.dart';

class AuthController extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  String? _usuarioLogado;
  String? _senhaAtual;

  void Function(String usuario)? aoExcluirConta;

  bool get isLogado => _pb.authStore.isValid && _usuarioLogado != null;
  String? get usuarioLogado => _usuarioLogado;

  static String _normalizar(String usuario) => usuario.trim().toLowerCase();

  Future<String?> cadastrar(String usuario, String senha) async {
    final chave = _normalizar(usuario);

    try {
      await _pb.collection('users').create(body: {
        'username': chave,
        'email': '$chave@estudos.com',
        'password': senha,
        'passwordConfirm': senha,
        'name': usuario.trim(),
      });
      return null;
    } on ClientException catch (e) {
      if (e.response['data'] is Map) {
        final data = e.response['data'] as Map;
        final erros = <String>[];
        for (final entry in data.entries) {
          final valor = entry.value;
          if (valor is Map && valor['message'] != null) {
            var msg = valor['message'].toString();
            if (entry.key == 'username') {
              msg = 'Nome de usuário já está em uso ou é inválido.';
            } else if (entry.key == 'password') {
              msg = 'A senha deve ter no mínimo 8 caracteres.';
            } else if (entry.key == 'email') {
              msg = 'E-mail do usuário já cadastrado.';
            } else if (entry.key == 'passwordConfirm') {
              msg = 'A confirmação de senha não confere.';
            }
            erros.add(msg);
          }
        }
        if (erros.isNotEmpty) {
          return erros.join('\n');
        }
      }
      return e.response['message'] as String? ?? 'Erro ao cadastrar usuário.';
    } catch (e) {
      return 'Não foi possível conectar ao PocketBase (${PocketBaseService.baseUrl}). Verifique se o servidor está rodando.';
    }
  }

  Future<String?> login(String usuario, String senha) async {
    final chave = _normalizar(usuario);

    try {
      final authData = await _pb.collection('users').authWithPassword(
        chave,
        senha,
      );

      final username = authData.record.getStringValue('username');
      _usuarioLogado = username.isNotEmpty ? username : chave;
      _senhaAtual = senha;
      notifyListeners();
      return null;
    } on ClientException catch (_) {
      return 'Usuário ou senha incorretos.';
    } catch (e) {
      return 'Não foi possível conectar ao PocketBase (${PocketBaseService.baseUrl}). Verifique se o servidor está rodando.';
    }
  }

  void logout() {
    _pb.authStore.clear();
    _usuarioLogado = null;
    _senhaAtual = null;
    notifyListeners();
  }

  bool senhaConfere(String senha) {
    return _senhaAtual != null && _senhaAtual == senha;
  }

  Future<String?> alterarSenha(String senhaAtual, String novaSenha) async {
    final userId = _pb.authStore.record?.id;
    if (userId == null) {
      return 'Nenhum usuário conectado.';
    }

    if (!senhaConfere(senhaAtual)) {
      return 'Senha atual incorreta.';
    }
    if (senhaAtual == novaSenha) {
      return 'A nova senha deve ser diferente da atual.';
    }

    try {
      await _pb.collection('users').update(userId, body: {
        'oldPassword': senhaAtual,
        'password': novaSenha,
        'passwordConfirm': novaSenha,
      });
      _senhaAtual = novaSenha;
      return null;
    } on ClientException catch (e) {
      return e.response['message'] as String? ?? 'Erro ao alterar senha.';
    } catch (e) {
      return 'Não foi possível conectar ao servidor para alterar a senha.';
    }
  }

  Future<String?> excluirConta(String senha) async {
    final userId = _pb.authStore.record?.id;
    if (userId == null) {
      return 'Nenhum usuário conectado.';
    }

    if (!senhaConfere(senha)) {
      return 'Senha incorreta.';
    }

    final usuario = _usuarioLogado!;

    try {
      await _pb.collection('users').delete(userId);
      _pb.authStore.clear();
      _usuarioLogado = null;
      _senhaAtual = null;
      aoExcluirConta?.call(usuario);
      notifyListeners();
      return null;
    } on ClientException catch (e) {
      return e.response['message'] as String? ?? 'Erro ao excluir conta.';
    } catch (e) {
      return 'Não foi possível conectar ao servidor para excluir a conta.';
    }
  }
}

