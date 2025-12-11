import 'package:flutter/material.dart';
import 'sumar_difficulty_screen.dart';
import 'customization_screen.dart';
import '../services/app_service.dart';

class SettingsScreenSumar extends StatelessWidget {
  const SettingsScreenSumar({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = AppService();
    final currentUser = appService.currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
    final titleFontSize = appService.fontSizeWithFallback();
    final titleFontFamily = appService.fontFamilyWithFallback();

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ajustes',
          style: TextStyle(
            fontSize: titleFontSize * 1.35,
            fontFamily: titleFontFamily,
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
              // === OPCIÓN 1: DIFICULTAD (Sumar) ===
              _SettingsOptionCard(
                icon: Icons.tune,
                title: 'Dificultad',
                backgroundColor: Colors.blue,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const SumarDifficultyScreen(),
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
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const CustomizationScreen(),
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
              Icon(
                icon,
                size: 56,
                color: Colors.white,
              ),
              const SizedBox(width: 24),
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
