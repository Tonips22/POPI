import 'package:flutter/material.dart';

/// Pantalla de configuración de tipografía
///
/// Permite al estudiante personalizar:
/// - Tipo de fuente: Predeterminada, Amigable (Comic Sans), Lectura Fácil (OpenDyslexic)
/// - Tamaño de letra: mediante un slider de pequeño a grande
///
/// Estos ajustes mejorarán la accesibilidad para estudiantes con
/// discapacidad visual o dificultades de lectura
class FontSettingsScreen extends StatefulWidget {
  const FontSettingsScreen({super.key});

  @override
  State<FontSettingsScreen> createState() => _FontSettingsScreenState();
}

class _FontSettingsScreenState extends State<FontSettingsScreen> {
  // === ESTADO DE LA PANTALLA ===
  // Estos valores deberían cargarse y guardarse en Firebase más adelante

  // Tipo de fuente seleccionado
  FontType selectedFontType = FontType.predeterminada;

  // Tamaño de letra (de 0.0 a 1.0)
  // 0.0 = pequeño, 0.5 = medio, 1.0 = grande
  double fontSizeValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tipografía',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === SECCIÓN 1: SELECCIÓN DE TIPO DE FUENTE ===
            _buildFontTypeSelector(),

            const SizedBox(height: 40),

            // === SECCIÓN 2: TAMAÑO DE LETRA ===
            _buildFontSizeSelector(),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de selección de tipo de fuente
  Widget _buildFontTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // No necesitamos título, los botones se explican solos

        // === FILA DE BOTONES ===
        Row(
          children: [
            // BOTÓN 1: Predeterminada
            Expanded(
              child: _FontTypeButton(
                label: 'Predeterminada',
                fontFamily: 'Roboto', // Fuente por defecto de Flutter
                isSelected: selectedFontType == FontType.predeterminada,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.predeterminada;
                  });
                  // TODO: Guardar en Firebase
                  print('Fuente seleccionada: Predeterminada');
                },
              ),
            ),

            const SizedBox(width: 16),

            // BOTÓN 2: Amigable
            Expanded(
              child: _FontTypeButton(
                label: 'Amigable',
                fontFamily: 'ComicNeue', // Fuente amigable (similar a Comic Sans)
                isSelected: selectedFontType == FontType.amigable,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.amigable;
                  });
                  // TODO: Guardar en Firebase
                  print('Fuente seleccionada: Amigable');
                },
              ),
            ),

            const SizedBox(width: 16),

            // BOTÓN 3: Lectura Fácil
            Expanded(
              child: _FontTypeButton(
                label: 'Lectura Fácil',
                fontFamily: 'OpenDyslexic', // Fuente para dislexia
                isSelected: selectedFontType == FontType.lecturaFacil,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.lecturaFacil;
                  });
                  // TODO: Guardar en Firebase
                  print('Fuente seleccionada: Lectura Fácil');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección del selector de tamaño de letra
  Widget _buildFontSizeSelector() {
    // Calculamos el tamaño de letra actual basándonos en el valor del slider
    // Rango: 16px (pequeño) hasta 32px (grande)
    final currentFontSize = 16.0 + (fontSizeValue * 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === TÍTULO DE LA SECCIÓN ===
        const Text(
          'Tamaño de letra',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        // === TARJETA CON EL SLIDER ===
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                // === FILA CON ICONOS Y SLIDER ===
                Row(
                  children: [
                    // ICONO IZQUIERDA: Letra pequeña
                    const Icon(
                      Icons.text_fields,
                      size: 32,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 24),

                    // === SLIDER ===
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.blue,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16, // Pulgar grande para accesibilidad
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 28, // Área táctil grande
                          ),
                          trackHeight: 8, // Barra más gruesa
                        ),
                        child: Slider(
                          value: _fontSizeToSlider(fontSizeValue),
                          min: 0.0,
                          max: 1.0,
                          // Dividimos en 4 pasos: muy pequeño, pequeño, medio, grande, muy grande
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              fontSizeValue = _sliderToFontSize(value);
                            });
                          },
                          onChangeEnd: (value) {
                            // Cuando el usuario suelte el slider, guardamos el valor
                            // TODO: Guardar en Firebase
                            print('Tamaño de letra: ${currentFontSize.toInt()}px');
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // ICONO DERECHA: Letra grande
                    const Icon(
                      Icons.text_fields,
                      size: 56,
                      color: Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // === VISTA PREVIA DEL TAMAÑO ===
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Texto de ejemplo',
                    style: TextStyle(
                      fontSize: currentFontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// === ENUMERACIÓN PARA LOS TIPOS DE FUENTE ===
/// Representa los diferentes tipos de fuente disponibles
enum FontType {
  predeterminada,
  amigable,
  lecturaFacil,
}

// === WIDGET PARA LOS BOTONES DE TIPO DE FUENTE ===
/// Botón que permite seleccionar un tipo de fuente
///
/// Características:
/// - Muestra el texto en la fuente correspondiente
/// - Cambia de estilo cuando está seleccionado (borde azul)
/// - Es táctil y accesible
class _FontTypeButton extends StatelessWidget {
  final String label;
  final String fontFamily;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontTypeButton({
    required this.label,
    required this.fontFamily,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // Si está seleccionado, borde azul grueso; si no, borde gris fino
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              // Aquí aplicamos la fuente correspondiente
              fontFamily: fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}