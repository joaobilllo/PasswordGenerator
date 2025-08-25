import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Serviço responsável por gerar a senha a partir dos dados e algoritmo escolhidos.
class PasswordService {
  /// Gera a senha baseada nos campos e algoritmo selecionado.
  static String generate({
    required String service,
  String username = '',
  required String passphrase,
  required int length,
  required String algorithm,
  bool includeUppercase = true,
  bool includeNumbers = true,
  bool includeSymbols = false,
  }) {
    // Combina os campos para formar a "semente" (payload)
  final seed = '$service|$username|$passphrase';
    List<int> bytes = utf8.encode(seed);
    Digest digest;
    // Seleciona algoritmo
    switch (algorithm) {
      case 'MD5':
        digest = md5.convert(bytes);
        break;
      case 'SHA-1':
        digest = sha1.convert(bytes);
        break;
      case 'SHA-256':
      default:
        digest = sha256.convert(bytes);
    }
    // Converte hash para string segura (apenas letras/números)
    // Monta alfabeto baseado nas flags
    final lower = 'abcdefghijklmnopqrstuvwxyz';
    final upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    final symbols = '!@#\$%&*()-_=+[]{};:,.<>?';

    String alphabet = lower;
    if (includeUppercase) alphabet += upper;
    if (includeNumbers) alphabet += numbers;
    if (includeSymbols) alphabet += symbols;

    // Se por algum motivo o alfabeto ficar vazio, usa base64 do hash
    if (alphabet.isEmpty) {
      final fallback = base64UrlEncode(digest.bytes).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      return fallback.substring(0, length);
    }

    // Mapeia bytes do hash para caracteres do alfabeto
    final buf = StringBuffer();
    final bytesExpand = digest.bytes;
    for (var i = 0; buf.length < length; i++) {
      final b = bytesExpand[i % bytesExpand.length];
      final idx = b % alphabet.length;
      buf.write(alphabet[idx]);
    }

    return buf.toString();
  }
}
