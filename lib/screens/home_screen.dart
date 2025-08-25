import 'package:flutter/material.dart';

import '../widgets/password_form.dart';

/// Tela principal do app, responsável por exibir o formulário de geração de senha.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de Senhas'), centerTitle: true),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PasswordForm(), // Widget do formulário principal
      ),
    );
  }
}
