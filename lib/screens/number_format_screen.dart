import 'package:flutter/material.dart';
import '../services/app_service.dart';

/// Pantalla de configuración de formas de objetos
/// 
/// Permite al estudiante personalizar la forma en que se visualizan
/// los objetos en los juegos:
/// - Círculo
/// - Cuadrado (con bordes redondeados)
/// - Triángulo
/// 
/// Esta preferencia se guarda en Firebase y se aplica a todos los juegos
class NumberFormatScreen extends StatefulWidget {
  const NumberFormatScreen({super.key});

  @override
  State<NumberFormatScreen> createState() => _NumberFormatScreenState();
}

class _NumberFormatScreenState extends State<NumberFormatScreen> {
  final AppService _service = AppService();
  
  // === ESTADO DE LA PANTALLA ===
  String selectedShape = 'circle';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserShapePreference();
  }

  /// Carga la forma seleccionada desde las preferencias del usuario
  void _loadUserShapePreference() {
    final user = _service.currentUser;
    if (user != null) {
      setState(() {
        selectedShape = user.preferences.shape;
        _isLoading = false;
      });
    } else {
      setState(() {
        selectedShape = 'circle';
        _isLoading = false;
      });
    }
  }

  /// Guarda la forma seleccionada en Firebase
  Future<void> _saveShapePreference(String shape) async {
    final user = _service.currentUser;
    if (user == null) return;

    // Actualizar las preferencias con la nueva forma
    final updatedPreferences = user.preferences.copyWith(shape: shape);

    // Guardar en Firebase
    bool success = await _service.updatePreferences(user.id, updatedPreferences);
    
    if (success) {
      // Actualizar en memoria
      _service.updateCurrentUserPreferences(updatedPreferences);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Forma guardada correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error al guardar la forma'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final appService = AppService();
    final currentUser = appService.currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
    final titleFontSize = appService.fontSizeWithFallback();
    final titleFontFamily = appService.fontFamilyWithFallback();
        
    return Scaffold(
      backgroundColor: backgroundColor,
      
      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Formas de objetos',
          style: TextStyle(
            fontSize: titleFontSize * 1.2,
            fontWeight: FontWeight.bold,
            fontFamily: titleFontFamily,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      
      // === CONTENIDO DE LA PANTALLA ===
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === TÍTULO/INSTRUCCIÓN ===
              Text(
                'Elige la forma de los objetos',
                style: TextStyle(
                  fontSize: titleFontSize * 1.4,
                  fontWeight: FontWeight.bold,
                  fontFamily: titleFontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // === GRID DE OPCIONES (3 formas) ===
              _buildShapesGrid(titleFontSize, titleFontFamily),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el grid con las 3 opciones de forma
  Widget _buildShapesGrid(double fontSize, String fontFamily) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // OPCIÓN 1: Círculo
        Expanded(
          child: _buildShapeOption(
            shape: 'circle',
            label: 'Círculo',
            icon: Icons.circle,
            fontSize: fontSize,
            fontFamily: fontFamily,
          ),
        ),
        
        const SizedBox(width: 24),
        
        // OPCIÓN 2: Cuadrado
        Expanded(
          child: _buildShapeOption(
            shape: 'square',
            label: 'Cuadrado',
            icon: Icons.square_rounded,
            fontSize: fontSize,
            fontFamily: fontFamily,
          ),
        ),
        
        const SizedBox(width: 24),
        
        // OPCIÓN 3: Triángulo
        Expanded(
          child: _buildShapeOption(
            shape: 'triangle',
            label: 'Triángulo',
            icon: Icons.change_history,
            fontSize: fontSize,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }

  /// Construye una tarjeta de opción de forma
  Widget _buildShapeOption({
    required String shape,
    required String label,
    required IconData icon,
    required double fontSize,
    required String fontFamily,
  }) {
    final isSelected = selectedShape == shape;
    final currentUser = _service.currentUser;
    final primaryColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.primaryColor))
        : Colors.blue;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedShape = shape;
        });
        _saveShapePreference(shape);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de la forma
            Icon(
              icon,
              size: 80,
              color: isSelected ? primaryColor : Colors.grey.shade600,
            ),
            
            const SizedBox(height: 16),
            
            // Etiqueta
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : Colors.grey.shade800,
                fontFamily: fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Indicador de selección
            if (isSelected) ...[
              const SizedBox(height: 8),
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 28,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
