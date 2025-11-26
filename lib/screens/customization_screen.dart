import 'package:flutter/material.dart';
import 'package:popi/screens/voice_screen.dart';
import 'color_settings_screen.dart';
import 'fonts_settings_screen.dart';
import 'number_format_screen.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FontSettingsScreen(),
                  ),
                );
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
                    builder: (context) => const VoiceScreen(),
                  ),
                );
              },
            ),

            // === OPCIÓN 5: REACCIONES ===
            _GridOptionCard(
              icon: Icons.emoji_emotions,
              title: 'Reacciones',
              backgroundColor: Colors.pink,
              onTap: () {
                // TODO: Navegar a pantalla de configuración de reacciones
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
              onTap: () {
                // TODO: Navegar a pantalla de configuración de juegos
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

/// Widget personalizado para cada opción del grid
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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