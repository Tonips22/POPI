import 'package:flutter/material.dart';
import 'screens/customization_screen.dart'; // Importa tu pantalla
import 'screens/sort_numbers_game.dart'; // Asegúrate de importar otras pantallas si es necesario

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POPI - Personalización',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // CAMBIA TEMPORALMENTE ESTA LÍNEA PARA PROBAR TU PANTALLA
      home: const SortNumbersGame(), // <-- Cambia esto temporalmente
      // home: const MyHomePage(title: 'POPI | Inicio'), // <-- Línea original
    );
  }
}

// ... resto del código igual