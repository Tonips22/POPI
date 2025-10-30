import 'package:flutter/material.dart';
import '../widgets/customization_option_card.dart';

/// Pantalla de Personalización
/// 
/// Permite al usuario acceder a diferentes opciones para personalizar
/// la experiencia de la aplicación:
/// - Colores favoritos
/// - Tipo y tamaño de letra (Tipografía)
/// - Formato de visualización de números
class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo claro
      backgroundColor: Colors.grey[100],
      
      // === BARRA SUPERIOR ===
      appBar: AppBar(
        // Botón de retroceso
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () {
            // Vuelve a la pantalla anterior
            Navigator.pop(context);
          },
        ),
        // Título de la pantalla
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
      
      // === CONTENIDO DE LA PANTALLA ===
      body: ListView(
        // Añade espacio arriba y abajo
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // === OPCIÓN 1: COLORES ===
          CustomizationOptionCard(
            icon: Icons.palette,
            title: 'Colores',
            iconBackgroundColor: Colors.blue,
            onTap: () {
              // TODO: Navegar a la pantalla de colores
              // Tus compañeros implementarán esta pantalla
              print('Navegar a Colores');
              
              // Ejemplo de cómo navegar (cuando exista la pantalla):
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ColorsScreen()),
              // );
            },
          ),
          
          // === OPCIÓN 2: TIPOGRAFÍA ===
          CustomizationOptionCard(
            icon: Icons.text_fields,
            title: 'Tipografía',
            iconBackgroundColor: Colors.blue,
            onTap: () {
              // TODO: Navegar a la pantalla de tipografía
              print('Navegar a Tipografía');
              
              // Ejemplo de cómo navegar (cuando exista la pantalla):
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => TypographyScreen()),
              // );
            },
          ),
          
          // === OPCIÓN 3: FORMATO DE NÚMEROS ===
          CustomizationOptionCard(
            icon: Icons.looks_one,
            title: 'Preferencias de visualización',
            iconBackgroundColor: Colors.blue,
            onTap: () {
              // TODO: Navegar a la pantalla de formato de números
              print('Preferencias de visualización');
              
              // Ejemplo de cómo navegar (cuando exista la pantalla):
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NumberFormatScreen()),
              // );
            },
          ),
        ],
      ),
    );
  }
}