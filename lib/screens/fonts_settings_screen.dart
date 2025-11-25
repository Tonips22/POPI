import 'package:flutter/material.dart';

/// Pantalla de configuración de tipografía
class FontSettingsScreen extends StatefulWidget {
  // userId ahora es opcional; si es null usamos 'demo' para pruebas.
  final String? userId;

  const FontSettingsScreen({super.key, this.userId});

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

  // userId efectivo (fallback a 'demo')
  String get effectiveUserId => widget.userId ?? 'demo';

  @override
  void initState() {
    super.initState();
    // Aquí podrías cargar las preferencias desde Firestore usando effectiveUserId
    // por ejemplo: PreferencesService.getPreferences(effectiveUserId)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // === BARRA SUPERIOR ===
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

      // === CONTENIDO DE LA PANTALLA ===
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

            const SizedBox(height: 24),
            // Botón de ejemplo para guardar (aquí debes conectar con tu servicio de preferencias)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ejemplo: guardar usando effectiveUserId
                  // await preferencesService.savePreferences(effectiveUserId, ...);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Guardar preferencias para: $effectiveUserId')),
                  );
                },
                child: const Text('Guardar (demo)'),
              ),
            ),
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
                fontFamily: 'Roboto',
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
                fontFamily: 'ComicNeue',
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
                fontFamily: 'OpenDyslexic',
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
    final currentFontSize = 16.0 + (fontSizeValue * 16.0);

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
                          value: fontSizeValue,
                          min: 0.0,
                          max: 1.0,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              fontSizeValue = value;
                            });
                          },
                          onChangeEnd: (value) {
                            print('Tamaño de letra: ${currentFontSize.toInt()}px');
                            // Aquí podrías guardar el valor con effectiveUserId
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