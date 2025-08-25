import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PasswordGeneratorApp());
}

/// Widget raiz do app, define tema e tela inicial.
class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Senhas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
