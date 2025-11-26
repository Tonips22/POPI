import 'package:flutter/material.dart';
import 'package:popi/screens/voice_screen.dart';
import 'color_settings_screen.dart';
import 'fonts_settings_screen.dart';
import 'number_format_screen.dart';

import '../services/user_service.dart';
import '../widgets/preference_provider.dart';
import '../widgets/voice_text.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenceProvider.of(context);

    final double titleFontSize = prefs?.getFontSizeValue() ?? 18.0;
    final String titleFontFamily = prefs?.getFontFamilyName() ?? 'Roboto';

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: VoiceText(
          'Personalizar',
          style: TextStyle(
            fontSize: titleFontSize,
            fontFamily: titleFontFamily,
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
              _GridOptionCard(
                icon: Icons.palette,
                title: 'Colores',
                backgroundColor: Colors.blue,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ColorSettingsScreen(),
                    ),
                  );
                },
              ),

              _GridOptionCard(
                icon: Icons.text_fields,
                title: 'Tipografía',
                backgroundColor: Colors.purple,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () async {
                  const demoId = 'demo';
                  final userService = UserService();

                  try {
                    await userService.ensureUserExists(
                      demoId,
                      name: 'Alumno Demo',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FontSettingsScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text('Error al preparar el usuario demo: $e'),
                      ),
                    );
                  }
                },
              ),

              _GridOptionCard(
                icon: Icons.looks_one,
                title: 'Formato de números',
                backgroundColor: Colors.green,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NumberFormatScreen(),
                    ),
                  );
                },
              ),

              _GridOptionCard(
                icon: Icons.volume_up,
                title: 'Sonido',
                backgroundColor: Colors.orange,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VoiceScreen(),
                    ),
                  );
                },
              ),

              _GridOptionCard(
                icon: Icons.emoji_emotions,
                title: 'Reacciones',
                backgroundColor: Colors.pink,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Configuración de reacciones - Próximamente',
                      ),
                    ),
                  );
                },
              ),

              _GridOptionCard(
                icon: Icons.sports_esports,
                title: 'Juegos',
                backgroundColor: Colors.red,
                fontSize: titleFontSize,
                fontFamily: titleFontFamily,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Configuración de juegos - Próximamente',
                      ),
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
              Icon(
                icon,
                size: 56,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              VoiceText(
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