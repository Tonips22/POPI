import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/registro_usuarios_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        useMaterial3: true,
      ),
      home: const RegistroUsuariosScreen(),
    );
  }
}