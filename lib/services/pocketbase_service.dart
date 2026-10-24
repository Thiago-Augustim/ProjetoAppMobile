import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  PocketBaseService._();
  static final PocketBaseService instance = PocketBaseService._();

  /// Se estiver testando em celular físico via Wi-Fi, coloque o IP da sua máquina aqui.
  /// Exemplo: static String customUrl = 'http://192.168.1.15:8090';
  static String customUrl = '';

  static String get baseUrl {
    if (customUrl.isNotEmpty) return customUrl;
    if (kIsWeb) return 'http://127.0.0.1:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      // 10.0.2.2 é o alias especial do emulador Android para o localhost do PC
      return 'http://10.0.2.2:8090';
    }
    return 'http://127.0.0.1:8090';
  }

  late final PocketBase client = PocketBase(baseUrl);

  PocketBase get pb => client;

  String? get currentUserId => client.authStore.record?.id;
  String? get currentUsername => client.authStore.record?.getStringValue('username');
  bool get isAuthenticated => client.authStore.isValid;
}
