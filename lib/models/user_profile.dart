// lib/models/user_profile.dart
// Modelo unificado de usuario con preferencias incluidas
class UserProfile {
  final String id;
  final String name;
  final String role; // 'student', 'tutor', 'admin'
  final DateTime createdAt;
  
  // === PREFERENCIAS DE VISUALIZACIÓN ===
  final String fontFamily;   // 'default', 'opendyslexic', 'comicneue'
  final String fontSize;      // 'small', 'medium', 'large', 'extra_large'
  final String primaryColor;  // Formato hexadecimal "#4CAF50"
  final String secondaryColor; // Formato hexadecimal "#2196F3"

  UserProfile({
    required this.id,
    this.name = 'Demo User',
    this.role = 'student',
    DateTime? createdAt,
    this.fontFamily = 'default',
    this.fontSize = 'medium',
    this.primaryColor = '#4CAF50',
    this.secondaryColor = '#2196F3',
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Demo User',
      role: map['role'] ?? 'student',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      fontFamily: map['fontFamily'] ?? 'default',
      fontSize: map['fontSize'] ?? 'medium',
      primaryColor: map['primaryColor'] ?? '#4CAF50',
      secondaryColor: map['secondaryColor'] ?? '#2196F3',
    );
  }

  /// Crea una copia con algunos campos modificados
  UserProfile copyWith({
    String? name,
    String? role,
    String? fontFamily,
    String? fontSize,
    String? primaryColor,
    String? secondaryColor,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
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
      case 'comicneue':
        return 'ComicNeue';
      default:
        return 'Roboto'; // Fuente por defecto de Flutter
    }
  }
}