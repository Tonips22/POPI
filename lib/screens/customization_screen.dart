// lib/screens/customization_screen.dart
// Modificamos el onTap de la opción "Tipografía" para crear/asegurar usuario demo y pasarlo.

import 'package:flutter/material.dart';
import 'color_settings_screen.dart';
import 'fonts_settings_screen.dart';
import 'number_format_screen.dart';

// Añadir import del servicio
import '../services/user_service.dart';
import '../widgets/preference_provider.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las preferencias del usuario
    final prefs = PreferenceProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Personalizar',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18.0,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
            fontWeight: FontWeight.bold,
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
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración de sonido - Próximamente')),
                  );
                },
              ),

              // === OPCIÓN 5: REACCIONES ===
              _GridOptionCard(
                icon: Icons.emoji_emotions,
                title: 'Reacciones',
                backgroundColor: Colors.pink,
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración de reacciones - Próximamente')),
                  );
                },
              ),

              // === OPCIÓN 6: JUEGOS ===
              _GridOptionCard(
                icon: Icons.sports_esports,
                title: 'Juegos',
                backgroundColor: Colors.red,
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración de juegos - Próximamente')),
                  );
                },
              ),
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
  final double fontSize;
  final String fontFamily;
  final VoidCallback onTap;

  const _GridOptionCard({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontFamily,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono grande en blanco
              Icon(
                icon,
                size: 56,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              // Título debajo del icono
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}