// lib/models/user_profile.dart
// Modelo unificado de usuario con preferencias incluidas

/// Clase para manejar preferencias de visualización del usuario
class UserPreferences {
  final bool canCustomize;
  final String fontFamily;   // 'default', 'opendyslexic', 'comicneue'
  final String fontSize;      // 'small', 'medium', 'large', 'extra_large'
  final String primaryColor;  // Formato: "0xFFRRGGBB"
  final String secondaryColor; // Formato: "0xFFRRGGBB"

  UserPreferences({
    this.canCustomize = false,
    this.fontFamily = 'default',
    this.fontSize = 'medium',
    this.primaryColor = '0xFF4CAF50',
    this.secondaryColor = '0xFF2196F3',
  });

  Map<String, dynamic> toMap() {
    return {
      'canCustomize': canCustomize,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      canCustomize: map['canCustomize'] ?? map['permitir_personalizar'] ?? false,
      fontFamily: map['fontFamily'] ?? 'default',
      fontSize: map['fontSize'] ?? 'medium',
      primaryColor: _convertColor(map['primaryColor']) ?? '0xFF4CAF50',
      secondaryColor: _convertColor(map['secondaryColor']) ?? '0xFF2196F3',
    );
  }

  /// Convierte de #RRGGBB a 0xFFRRGGBB o mantiene 0xFFRRGGBB
  static String? _convertColor(String? color) {
    if (color == null) return null;
    if (color.startsWith('0x')) return color;
    if (color.startsWith('#')) {
      return '0xFF${color.substring(1)}';
    }
    return color;
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
        return 'Roboto';
    }
  }
}

/// Modelo principal de usuario
class UserProfile {
  final String id;
  final String name;
  final String role;          // 'student', 'tutor', 'admin'
  final int avatarIndex;      // Índice del avatar (0-3 para avatar1-avatar4)
  final String createdAt;     // String ISO 8601
  final int? edad;            // Edad del usuario (opcional)
  final int? tutorId;         // ID del tutor asignado (opcional)
  final UserPreferences preferences;

  UserProfile({
    required this.id,
    required this.name,
    this.role = 'student',
    this.avatarIndex = 0,
    String? createdAt,
    this.edad,
    this.tutorId,
    UserPreferences? preferences,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        preferences = preferences ?? UserPreferences();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'role': role,
      'avatarIndex': avatarIndex,
      'createdAt': createdAt,
      'preferences': preferences.toMap(),
    };
    
    // Añadir campos opcionales solo si no son nulos
    if (edad != null) map['edad'] = edad!;
    if (tutorId != null) map['tutorId'] = tutorId!;
    
    return map;
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    // Determinar si tiene estructura nueva (preferences anidado) o antigua (plano)
    final bool hasNestedPrefs = map['preferences'] is Map;

    return UserProfile(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Demo User',
      role: _normalizeRole(map['role']?.toString() ?? 'student'),
      avatarIndex: _parseAvatarIndex(map),
      createdAt: _parseCreatedAt(map['createdAt']),
      edad: map['edad'] as int?,
      tutorId: map['tutorId'] as int?,
      preferences: hasNestedPrefs
          ? UserPreferences.fromMap(map['preferences'] as Map<String, dynamic>)
          : UserPreferences.fromMap(map), // Compatibilidad: leer de nivel raíz
    );
  }

  /// Normaliza roles antiguos a nuevos
  static String _normalizeRole(String role) {
    final normalized = role.toLowerCase();
    if (normalized.contains('estudiante') || normalized == 'student') {
      return 'student';
    }
    if (normalized.contains('tutor')) return 'tutor';
    if (normalized.contains('admin')) return 'admin';
    return 'student';
  }

  /// Convierte avatar string antiguo a avatarIndex
  static int _parseAvatarIndex(Map<String, dynamic> map) {
    // Si existe avatarIndex, usarlo directamente
    if (map['avatarIndex'] is int) return map['avatarIndex'] as int;

    // Compatibilidad: convertir avatar string a índice
    final avatar = map['avatar']?.toString() ?? 'avatar1';
    if (avatar.startsWith('avatar')) {
      final num = int.tryParse(avatar.substring(6)) ?? 1;
      return num - 1; // avatar1 → index 0, avatar2 → index 1, etc.
    }
    return 0;
  }

  /// Parsea createdAt de diferentes formatos
  static String _parseCreatedAt(dynamic val) {
    if (val is String) return val;
    if (val is DateTime) return val.toIso8601String();
    // Si es Timestamp de Firestore
    try {
      return (val as dynamic).toDate().toIso8601String();
    } catch (_) {
      return DateTime.now().toIso8601String();
    }
  }

  /// Crea una copia con algunos campos modificados
  UserProfile copyWith({
    String? name,
    String? role,
    int? avatarIndex,
    int? edad,
    int? tutorId,
    UserPreferences? preferences,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      createdAt: createdAt,
      edad: edad ?? this.edad,
      tutorId: tutorId ?? this.tutorId,
      preferences: preferences ?? this.preferences,
    );
  }

  // Helpers de compatibilidad para acceso rápido a preferences
  bool get permitirPersonalizar => preferences.canCustomize;
  String get fontFamily => preferences.fontFamily;
  String get fontSize => preferences.fontSize;
  String get primaryColor => preferences.primaryColor;
  String get secondaryColor => preferences.secondaryColor;
  
  double getFontSizeValue() => preferences.getFontSizeValue();
  String getFontFamilyName() => preferences.getFontFamilyName();
  
  /// Obtiene el nombre del archivo de avatar (para compatibilidad)
  String get avatarName => 'avatar${avatarIndex + 1}';
}