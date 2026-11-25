import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class FotoCapturada {
  const FotoCapturada({
    required this.bytes,
    required this.nomeArquivo,
  });

  final Uint8List bytes;
  final String nomeArquivo;
}

class CameraService {
  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<FotoCapturada?> tirarFoto() async {
    final arquivo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    if (arquivo == null) return null;

    final bytes = await arquivo.readAsBytes();
    final nome = arquivo.name.isNotEmpty
        ? arquivo.name
        : 'tarefa_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return FotoCapturada(bytes: bytes, nomeArquivo: nome);
  }
}
