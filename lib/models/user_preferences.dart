// lib/models/user_preferences.dart

/// Modelo que representa las preferencias visuales de un usuario
/// Incluye tamaño de fuente, tipo de fuente y colores preferidos
class UserPreferences {
  // Tamaños disponibles: small, medium, large, extra_large
  final String fontSize;
  
  // Tipos de fuente: default, opendyslexic, arial
  final String fontFamily;
  
  // Colores en formato hexadecimal (ejemplo: "#4CAF50")
  final String primaryColor;
  final String secondaryColor;
  
  // Fecha de última actualización
  final DateTime lastUpdated;

  /// Constructor con valores por defecto
  UserPreferences({
    this.fontSize = 'medium',
    this.fontFamily = 'default',
    this.primaryColor = '#4CAF50',
    this.secondaryColor = '#2196F3',
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Convierte el objeto a un Map para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Crea un objeto UserPreferences desde un Map de Firestore
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      fontSize: map['fontSize'] ?? 'medium',
      fontFamily: map['fontFamily'] ?? 'default',
      primaryColor: map['primaryColor'] ?? '#4CAF50',
      secondaryColor: map['secondaryColor'] ?? '#2196F3',
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated'])
          : DateTime.now(),
    );
  }

  /// Crea una copia con algunos campos modificados
  UserPreferences copyWith({
    String? fontSize,
    String? fontFamily,
    String? primaryColor,
    String? secondaryColor,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convierte el tamaño de fuente a un valor numérico
  double getFontSizeValue() {
    switch (fontSize) {
      case 'small':
        return 14.0;
      case 'medium':
        return 18.0;
      case 'large':
        return 24.0;
      case 'extra_large':
        return 32.0;
      default:
        return 18.0;
    }
  }

  /// Obtiene el nombre de la familia de fuente para Flutter
  String getFontFamilyName() {
    switch (fontFamily) {
      case 'opendyslexic':
        return 'OpenDyslexic';
      case 'arial':
        return 'Arial';
      default:
        return 'Roboto'; // Fuente por defecto de Flutter
    }
  }
}