import 'package:flutter/material.dart';
import '../widgets/customization_option_card.dart';
import 'color_settings_screen.dart';
import 'fonts_settings_screen.dart'; // 👈 AÑADE ESTA IMPORTACIÓN

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
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // === OPCIÓN 1: COLORES ===
          CustomizationOptionCard(
            icon: Icons.palette,
            title: 'Colores',
            iconBackgroundColor: Colors.blue,
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
          CustomizationOptionCard(
            icon: Icons.text_fields,
            title: 'Tipografía',
            iconBackgroundColor: Colors.blue,
            onTap: () {
              // 👇 ACTUALIZA ESTA FUNCIÓN
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FontSettingsScreen(),
                ),
              );
            },
          ),

          // === OPCIÓN 3: FORMATO DE NÚMEROS ===
          CustomizationOptionCard(
            icon: Icons.looks_one,
            title: 'Formato de números',
            iconBackgroundColor: Colors.blue,
            onTap: () {
              // TODO: Navegar a la pantalla de formato de números
              print('Navegar a Formato de números');
            },
          ),
        ],
      ),
    );
  }
}