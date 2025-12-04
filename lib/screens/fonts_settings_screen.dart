import 'package:flutter/material.dart';
import '../services/app_service.dart';

/// Pantalla de configuración de tipografía (solo visual, sin persistencia)
class FontSettingsScreen extends StatefulWidget {
  final String? userId;

  const FontSettingsScreen({super.key, this.userId});

  @override
  State<FontSettingsScreen> createState() => _FontSettingsScreenState();
}

class _FontSettingsScreenState extends State<FontSettingsScreen> {
  // Tipo de fuente seleccionado
  FontType selectedFontType = FontType.predeterminada;

  // Tamaño de letra como String
  String fontSizeValue = 'medium';

  /// Convierte el String a valor del slider (0.0 a 1.0)
  double _fontSizeToSlider(String fontSize) {
    switch (fontSize) {
      case 'extra_small':
        return 0.0;
      case 'small':
        return 0.25;
      case 'medium':
        return 0.5;
      case 'large':
        return 0.75;
      case 'extra_large':
        return 1.0;
      default:
        return 0.5;
    }
  }

  /// Convierte el valor del slider a String
  String _sliderToFontSize(double value) {
    if (value <= 0.125) return 'extra_small';
    if (value <= 0.375) return 'small';
    if (value <= 0.625) return 'medium';
    if (value <= 0.875) return 'large';
    return 'extra_large';
  }

  /// Obtiene el valor numérico para preview
  double _getFontSizePreview(String fontSize) {
    switch (fontSize) {
      case 'extra_small':
        return 12.0;
      case 'small':
        return 16.0;
      case 'medium':
        return 20.0;
      case 'large':
        return 24.0;
      case 'extra_large':
        return 32.0;
      default:
        return 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppService().currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
        
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
            fontSize: 24,
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

  Widget _buildFontTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _FontTypeButton(
                label: 'Predeterminada',
                fontFamily: 'Roboto', // Esta es la fuente por defecto
                isSelected: selectedFontType == FontType.predeterminada,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.predeterminada;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FontTypeButton(
                label: 'Amigable',
                fontFamily: 'ComicNeue', // Esta es la fuente ComicNeue
                isSelected: selectedFontType == FontType.amigable,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.amigable;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FontTypeButton(
                label: 'Lectura Fácil',
                fontFamily: 'OpenDyslexic', // Esta es la fuente OpenDyslexic
                isSelected: selectedFontType == FontType.lecturaFacil,
                onTap: () {
                  setState(() {
                    selectedFontType = FontType.lecturaFacil;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFontSizeSelector() {
    final currentFontSize = _getFontSizePreview(fontSizeValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tamaño de letra',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.text_fields,
                      size: 32,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.blue,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 28,
                          ),
                          trackHeight: 8,
                        ),
                        child: Slider(
                          value: _fontSizeToSlider(fontSizeValue),
                          min: 0.0,
                          max: 1.0,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              fontSizeValue = _sliderToFontSize(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Icon(
                      Icons.text_fields,
                      size: 56,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
enum FontType {
  predeterminada,
  amigable,
  lecturaFacil,
}

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
              fontFamily: fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}