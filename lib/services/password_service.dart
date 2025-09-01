// Importa bibliotecas necessárias para codificação e algoritmos de hash
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Serviço responsável por gerar a senha a partir dos dados e algoritmo escolhidos.
class PasswordService {
  /// Gera a senha baseada nos campos e algoritmo selecionado.
  ///
  /// Parâmetros:
  ///   [service]: nome do serviço/site
  ///   [username]: nome de usuário (opcional)
  ///   [passphrase]: frase-base secreta
  ///   [length]: comprimento desejado da senha
  ///   [algorithm]: algoritmo de hash ('MD5', 'SHA-1', 'SHA-256')
  ///   [includeUppercase]: inclui letras maiúsculas
  ///   [includeNumbers]: inclui números
  ///   [includeSymbols]: inclui símbolos especiais
  ///
  /// Retorna:
  ///   String com a senha gerada
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
    // Combina os campos para formar a "semente" (payload) única para cada usuário/serviço
    final seed = '$service|$username|$passphrase';
    // Codifica a semente em bytes para uso no hash
    List<int> bytes = utf8.encode(seed);
    Digest digest;
    // Seleciona o algoritmo de hash conforme escolha do usuário
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
    // Define os conjuntos de caracteres possíveis
    final lower = 'abcdefghijklmnopqrstuvwxyz';
    final upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    final symbols = '!@#\$%&*()-_=+[]{};:,.<>?';

    // Monta o alfabeto final de acordo com as opções marcadas
    String alphabet = lower;
    if (includeUppercase) alphabet += upper;
    if (includeNumbers) alphabet += numbers;
    if (includeSymbols) alphabet += symbols;

    // Se o alfabeto ficar vazio (caso improvável), usa base64 do hash como fallback
    if (alphabet.isEmpty) {
      final fallback = base64UrlEncode(
        digest.bytes,
      ).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      return fallback.substring(0, length);
    }

    // Mapeia bytes do hash para caracteres do alfabeto, garantindo repetição se necessário
    final buf = StringBuffer();
    final bytesExpand = digest.bytes;
    for (var i = 0; buf.length < length; i++) {
      // Pega byte do hash, faz módulo pelo tamanho do alfabeto para garantir índice válido
      final b = bytesExpand[i % bytesExpand.length];
      final idx = b % alphabet.length;
      buf.write(alphabet[idx]);
    }

    // Retorna a senha final gerada
    return buf.toString();
  }
}
