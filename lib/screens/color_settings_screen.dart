import 'package:flutter/material.dart';
import '../widgets/color_setting_card.dart';
import '../utils/color_constants.dart';

/// Pantalla de configuración de colores
///
/// Permite al usuario personalizar:
/// - Color primario: usado en botones, elementos importantes
/// - Color secundario: usado en elementos de apoyo
/// - Color de fondo: color de fondo de las pantallas de los juegos
///
/// Los colores seleccionados se guardarán en el perfil del estudiante
class ColorSettingsScreen extends StatefulWidget {
  const ColorSettingsScreen({super.key});

  @override
  State<ColorSettingsScreen> createState() => _ColorSettingsScreenState();
}

class _ColorSettingsScreenState extends State<ColorSettingsScreen> {
  final AppService _service = AppService();
  
  // === COLORES SELECCIONADOS (estado de la pantalla) ===
  Color? primaryColor;
  Color? secondaryColor;
  Color? backgroundColor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserColors();
  }

  /// Carga los colores desde las preferencias del usuario
  void _loadUserColors() {
    final user = _service.currentUser;
    if (user != null) {
      setState(() {
        primaryColor = _parseColor(user.preferences.primaryColor);
        secondaryColor = _parseColor(user.preferences.secondaryColor);
        backgroundColor = _parseColor(user.preferences.backgroundColor);
        _isLoading = false;
      });
    } else {
      setState(() {
        primaryColor = Colors.blue;
        secondaryColor = Colors.green;
        backgroundColor = Colors.white;
        _isLoading = false;
      });
    }
  }

  /// Convierte un String hexadecimal a Color
  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex));
    } catch (e) {
      return Colors.blue; // fallback
    }
  }

  /// Convierte un Color a String hexadecimal
  String _colorToHex(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  /// Guarda los colores en Firebase y actualiza el usuario en memoria
  Future<void> _saveColors() async {
    final user = _service.currentUser;
    if (user == null) return;

    // Crear nuevas preferencias con los colores actualizados
    final updatedPreferences = user.preferences.copyWith(
      primaryColor: _colorToHex(primaryColor!),
      secondaryColor: _colorToHex(secondaryColor!),
      backgroundColor: _colorToHex(backgroundColor!),
    );

    // Actualizar en Firebase
    bool success = await _service.updatePreferences(user.id, updatedPreferences);
    
    if (success) {
      // Actualizar en memoria
      _service.updateCurrentUserPreferences(updatedPreferences);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Colores guardados correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error al guardar los colores'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: userBackgroundColor,

      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Color',
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // === OPCIÓN 1: COLOR PRIMARIO ===
          ColorSettingCard(
            icon: Icons.palette,
            iconBackgroundColor: Colors.blue,
            title: 'Color primario',
            selectedColor: primaryColor,
            availableColors: AppColors.availableColors,
            dialogTitle: 'Elige un color primario',
            onColorSelected: (color) {
              setState(() {
                primaryColor = color;
              });
              _saveColors();
            },
          ),

          // === OPCIÓN 2: COLOR SECUNDARIO ===
          ColorSettingCard(
            icon: Icons.water_drop,
            iconBackgroundColor: Colors.green,
            title: 'Color secundario',
            selectedColor: secondaryColor,
            availableColors: AppColors.availableColors,
            dialogTitle: 'Elige un color secundario',
            onColorSelected: (color) {
              setState(() {
                secondaryColor = color;
              });
              _saveColors();
            },
          ),

          // === OPCIÓN 3: COLOR DE FONDO ===
          ColorSettingCard(
            icon: Icons.format_color_fill,
            iconBackgroundColor: Colors.grey.shade600,
            title: 'Color de fondo',
            selectedColor: backgroundColor,
            availableColors: AppColors.backgroundColors,
            dialogTitle: 'Elige un color de fondo',
            onColorSelected: (color) {
              setState(() {
                backgroundColor = color;
              });
              _saveColors();
            },
          ),
        ],
      ),
    );
  }
}