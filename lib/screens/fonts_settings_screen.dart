import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import '../widgets/preference_provider.dart';

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
  final UserService _userService = UserService();

  // Tipo de fuente seleccionado
  FontType selectedFontType = FontType.predeterminada;

  // Tamaño de letra (de 0.0 a 1.0)
  // 0.0 = pequeño, 0.5 = medio, 1.0 = grande
  double fontSizeValue = 0.5;
  
  bool _isLoading = true;
  bool _isSaving = false;

  // userId efectivo (fallback a 'demo')
  String get effectiveUserId => widget.userId ?? 'demo';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Carga las preferencias desde Firebase (tabla users)
  Future<void> _loadPreferences() async {
    try {
      final userProfile = await _userService.getUserProfile(effectiveUserId);
      if (userProfile != null) {
        setState(() {
          // Convertir fontFamily a FontType
          selectedFontType = _fontFamilyToType(userProfile.fontFamily);
          // Convertir fontSize a valor del slider
          fontSizeValue = _fontSizeToSliderValue(userProfile.fontSize);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar preferencias: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Convierte el fontFamily del modelo a FontType
  FontType _fontFamilyToType(String fontFamily) {
    switch (fontFamily) {
      case 'opendyslexic':
        return FontType.lecturaFacil;
      case 'comicneue':
        return FontType.amigable;
      default:
        return FontType.predeterminada;
    }
  }

  /// Convierte el fontSize del modelo a valor del slider
  double _fontSizeToSliderValue(String fontSize) {
    switch (fontSize) {
      case 'small':
        return 0.0;
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

  /// Convierte el FontType a fontFamily del modelo
  String _fontTypeToFamily(FontType type) {
    switch (type) {
      case FontType.lecturaFacil:
        return 'opendyslexic';
      case FontType.amigable:
        return 'comicneue';
      default:
        return 'default';
    }
  }

  /// Convierte el valor del slider a fontSize del modelo
  String _sliderValueToFontSize(double value) {
    if (value <= 0.25) return 'small';
    if (value <= 0.6) return 'medium';
    if (value <= 0.85) return 'large';
    return 'extra_large';
  }

  /// Guarda las preferencias en Firebase (tabla users)
  Future<void> _savePreferences() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Actualizar las preferencias en la tabla users
      await _userService.updateUserPreferences(
        effectiveUserId,
        fontFamily: _fontTypeToFamily(selectedFontType),
        fontSize: _sliderValueToFontSize(fontSizeValue),
      );

      // Recargar las preferencias en toda la aplicación
      if (mounted) {
        await PreferenceProvider.reload(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Preferencias guardadas correctamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error al guardar preferencias: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al guardar preferencias: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final prefs = PreferenceProvider.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Tipografía',
            style: TextStyle(
              fontSize: prefs?.getFontSizeValue() ?? 32,
              fontWeight: FontWeight.bold,
              fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tipografía',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 32,
            fontWeight: FontWeight.bold,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
            // Botón para guardar preferencias
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Guardar cambios',
                        style: TextStyle(
                          fontSize: prefs?.getFontSizeValue() ?? 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                          color: Colors.white,
                        ),
                      ),
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