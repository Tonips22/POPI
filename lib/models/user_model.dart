/// Modelo simplificado de usuario para el sistema de login
class UserModel {
  final String id;
  final String name;
  final String role;
  final int avatarIndex;
  final UserPreferences preferences;

  UserModel({
    required this.id,
    required this. name,
    required this.role,
    required this.avatarIndex,
    required this.preferences,
  });

  /// Convierte el usuario a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'avatarIndex': avatarIndex,
      'preferences': preferences.toMap(),
    };
  }

  /// Crea un usuario desde Firestore
  factory UserModel. fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      role: map['role'] ?? 'student',
      avatarIndex: map['avatarIndex'] ??  0,
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
    );
  }
}

/// Preferencias visuales del usuario (SOLO LO BÁSICO)
class UserPreferences {
  final String primaryColor;
  final String secondaryColor;
  final String fontFamily;
  final double fontSize;
  final bool canCustomize;

  UserPreferences({
    this.primaryColor = '0xFF2196F3',
    this. secondaryColor = '0xFFFFC107',
    this. fontFamily = 'Roboto',
    this.fontSize = 24.0,
    this. canCustomize = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'canCustomize': canCustomize,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      primaryColor: map['primaryColor'] ?? '0xFF2196F3',
      secondaryColor: map['secondaryColor'] ?? '0xFFFFC107',
      fontFamily: map['fontFamily'] ?? 'Roboto',
      fontSize: (map['fontSize'] ??  24.0).toDouble(),
      canCustomize: map['canCustomize'] ?? false,
    );
  }

  /// Crea una copia modificando algunos campos
  UserPreferences copyWith({
    String? primaryColor,
    String? secondaryColor,
    String? fontFamily,
    double? fontSize,
    bool?  canCustomize,
  }) {
    return UserPreferences(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this. secondaryColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      canCustomize: canCustomize ?? this.canCustomize,
    );
  }
}