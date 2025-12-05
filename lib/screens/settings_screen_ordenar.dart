import 'package:flutter/material.dart';
import 'package:popi/screens/ordenar_difficulty_screen.dart';
import 'difficulty_screen.dart';
import 'customization_screen.dart';
// import '../widgets/preference_provider.dart';

class SettingsScreenOrdenar extends StatelessWidget {
  const SettingsScreenOrdenar({super.key});

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);

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
          'Ajustes',
          style: const TextStyle(
            fontSize: 18.0 * 1.5,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === OPCIÓN 1: DIFICULTAD ===
              _SettingsOptionCard(
                icon: Icons.tune,
                title: 'Dificultad',
                backgroundColor: Colors.blue,
                fontSize: 18.0,
                fontFamily: 'Roboto',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdenarDifficultyScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // === OPCIÓN 2: PERSONALIZACIÓN ===
              _SettingsOptionCard(
                icon: Icons.palette,
                title: 'Personalización',
                backgroundColor: Colors.purple,
                fontSize: 18.0,
                fontFamily: 'Roboto',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomizationScreen(),
                    ),
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

/// Widget personalizado para cada opción de ajustes
class _SettingsOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final double fontSize;
  final String fontFamily;
  final VoidCallback onTap;

  const _SettingsOptionCard({
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
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono grande en blanco
              Icon(
                icon,
                size: 56,
                color: Colors.white,
              ),
              const SizedBox(width: 24),
              // Título al lado del icono
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize * 1.2,
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