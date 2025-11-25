// lib/screens/customization_screen.dart
// Modificamos el onTap de la opción "Tipografía" para crear/asegurar usuario demo y pasarlo.

import 'package:flutter/material.dart';
import 'color_settings_screen.dart';
import 'fonts_settings_screen.dart';
import 'number_format_screen.dart';
import 'example_screen.dart';

// Añadir import del servicio
import '../services/user_service.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService(); // instancia sencilla

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Personalizar',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // === OPCIÓN 1: COLORES ===
              _GridOptionCard(
                icon: Icons.palette,
                title: 'Colores',
                backgroundColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ColorSettingsScreen(),
                    ),
                  );
                },
              ),

              // === OPCIÓN 2: TIPOGRAFÍA ===
              _GridOptionCard(
                icon: Icons.text_fields,
                title: 'Tipografía',
                backgroundColor: Colors.purple,
                onTap: () async {
                  const demoId = 'demo';
                  final userService = UserService(); // creado aquí, no como campo del widget

                  try {
                    // Aseguramos que exista el usuario demo en Firestore (crea el documento si no existe)
                    await userService.ensureUserExists(demoId, name: 'Alumno Demo');

                    // Navegamos a la pantalla de tipografías pasando el userId demo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FontSettingsScreen(userId: demoId), // quita const
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al preparar el usuario demo: $e')),
                    );
                  }
                },
              ),

              // === OPCIÓN 3: FORMATO DE NÚMEROS ===
              _GridOptionCard(
                icon: Icons.looks_one,
                title: 'Formato de números',
                backgroundColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NumberFormatScreen(),
                    ),
                  );
                },
              ),
              // === OPCIÓN 4: SONIDO ===
              _GridOptionCard(
                icon: Icons.volume_up,
                title: 'Sonido',
                backgroundColor: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExampleScreen(),
                    ),
                  );
                },
              ),

              // ... resto sin cambios ...
            ],
          ),
        ),
      ),
    );
  }
}

class _GridOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _GridOptionCard({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: backgroundColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}