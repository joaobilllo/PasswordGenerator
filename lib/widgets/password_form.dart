import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/password_service.dart';

/// Formulário principal do gerador de senhas.
/// Organiza os campos, validação, seleção de algoritmo e exibe o resultado.
class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passphraseController = TextEditingController();
  double _length = 12;
  String _algorithm = 'SHA-256';
  String _result = '';
  bool _copied = false;
  bool _useUppercase = true;
  bool _useNumbers = true;
  bool _useSymbols = false;

  // Limpa controladores ao destruir widget
  @override
  void dispose() {
    _serviceController.dispose();
    _usernameController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  // Gera a senha usando o serviço
  void _generate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _result = PasswordService.generate(
          service: _serviceController.text,
          username: _usernameController.text,
          passphrase: _passphraseController.text,
          length: _length.toInt(),
          algorithm: _algorithm,
          includeUppercase: _useUppercase,
          includeNumbers: _useNumbers,
          includeSymbols: _useSymbols,
        );
        _copied = false;
      });
    }
  }

  // Copia a senha para a área de transferência
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));
    setState(() => _copied = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo Serviço/Site
            TextFormField(
              controller: _serviceController,
              decoration: const InputDecoration(labelText: 'Serviço/Site'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obrigatório' : null,
            ),
            // Campo opcional Nome de usuário
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nome de usuário (opcional)',
              ),
            ),
            // Campo Frase-base
            TextFormField(
              controller: _passphraseController,
              decoration: const InputDecoration(labelText: 'Frase-base'),
              obscureText: true,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            // Slider para comprimento
            Text('Comprimento: ${_length.toInt()}'),
            Slider(
              min: 8,
              max: 32,
              value: _length,
              divisions: 24,
              label: _length.toInt().toString(),
              onChanged: (v) => setState(() => _length = v),
            ),
            const SizedBox(height: 16),
            // Opções de composição da senha
            CheckboxListTile(
              title: const Text('Incluir maiúsculas'),
              value: _useUppercase,
              onChanged: (v) => setState(() => _useUppercase = v ?? true),
            ),
            CheckboxListTile(
              title: const Text('Incluir números'),
              value: _useNumbers,
              onChanged: (v) => setState(() => _useNumbers = v ?? true),
            ),
            CheckboxListTile(
              title: const Text('Incluir símbolos'),
              value: _useSymbols,
              onChanged: (v) => setState(() => _useSymbols = v ?? false),
            ),
            // Dropdown para algoritmo
            DropdownButtonFormField<String>(
              value: _algorithm,
              decoration: const InputDecoration(labelText: 'Algoritmo'),
              items: const [
                DropdownMenuItem(value: 'MD5', child: Text('MD5')),
                DropdownMenuItem(value: 'SHA-1', child: Text('SHA-1')),
                DropdownMenuItem(value: 'SHA-256', child: Text('SHA-256')),
              ],
              onChanged: (v) => setState(() => _algorithm = v!),
            ),
            const SizedBox(height: 12),
            // Medidor simples de força: baseado no comprimento e diversidade de classes
            Builder(
              builder: (context) {
                int classes = 1;
                if (_useUppercase) classes++;
                if (_useNumbers) classes++;
                if (_useSymbols) classes++;
                final score = (_length / 32.0 * 0.6) + (classes / 4.0 * 0.4);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Força estimada: ${(score * 100).round()}%'),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(value: score.clamp(0.0, 1.0)),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Botão de gerar senha
            ElevatedButton(
              onPressed: _generate,
              child: const Text('Gerar Senha'),
            ),
            const SizedBox(height: 24),
            // Exibe resultado e botão de copiar
            if (_result.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText(
                    _result,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: Text(_copied ? 'Copiada!' : 'Copiar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
