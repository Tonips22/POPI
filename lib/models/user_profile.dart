// lib/models/user_profile.dart
// Modelo unificado de usuario con preferencias incluidas
class UserProfile {
  final String id;
  final String name;
  final String role; // 'student', 'tutor', 'admin'
  final DateTime createdAt;
  
  final bool permitirPersonalizar;

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
    this.permitirPersonalizar = false,
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
      'permitir_personalizar': permitirPersonalizar,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    // Helper para parsear fecha (String o Timestamp)
    DateTime parseDate(dynamic val) {
      if (val == null) return DateTime.now();
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      // Si es Timestamp (de cloud_firestore), tiene método toDate()
      // Usamos dynamic para no obligar a importar cloud_firestore aquí si no queremos,
      // pero idealmente deberíamos importar si usamos el tipo explícito.
      // Como 'val' es dynamic, si tiene toDate() lo llamamos.
      try {
        return (val as dynamic).toDate();
      } catch (_) {
        return DateTime.now();
      }
    }

    return UserProfile(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Demo User',
      role: map['role']?.toString() ?? 'student',
      createdAt: parseDate(map['createdAt']),
      permitirPersonalizar: map['permitir_personalizar'] ?? false,
      fontFamily: map['fontFamily']?.toString() ?? 'default',
      fontSize: map['fontSize']?.toString() ?? 'medium',
      primaryColor: map['primaryColor']?.toString() ?? '#4CAF50',
      secondaryColor: map['secondaryColor']?.toString() ?? '#2196F3',
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