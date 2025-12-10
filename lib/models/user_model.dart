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
  final String backgroundColor;
  final String fontFamily;
  final String fontSize; // 'extra_small', 'small', 'medium', 'large', 'extra_large'
  final String shape; // 'circle', 'square', 'triangle'
  final bool canCustomize;

  UserPreferences({
    this.primaryColor = '0xFF2196F3',
    this.secondaryColor = '0xFFFFC107',
    this.backgroundColor = '0xFFFFFFFF',
    this.fontFamily = 'default',
    this.fontSize = 'default',
    this.shape = 'circle',
    this.canCustomize = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'backgroundColor': backgroundColor,
      'fontFamily': fontFamily,
      'fontSize': fontSize, // Ahora es String directamente
      'shape': shape,
      'canCustomize': canCustomize,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    // Manejar fontSize: puede ser String o número (legacy)
    String fontSize = 'default'; // default
    if (map['fontSize'] != null) {
      if (map['fontSize'] is String) {
        String value = map['fontSize'] as String;
        // Convertir valores antiguos a nuevos
        if (value == 'medium') {
          fontSize = 'default';
        } else {
          fontSize = value;
        }
      } else if (map['fontSize'] is num) {
        // Convertir números antiguos a String
        double value = (map['fontSize'] as num).toDouble();
        if (value <= 12.0) {
          fontSize = 'extra_small';
        } else if (value <= 16.0) {
          fontSize = 'small';
        } else if (value <= 20.0) {
          fontSize = 'default';
        } else if (value <= 28.0) {
          fontSize = 'large';
        } else {
          fontSize = 'extra_large';
        }
      }
    }
    
    // Manejar fontFamily: convertir valores antiguos a nuevos
    String fontFamily = 'default';
    if (map['fontFamily'] != null) {
      String value = map['fontFamily'] as String;
      if (value == 'Roboto') {
        fontFamily = 'default';
      } else if (value == 'ComicNeue') {
        fontFamily = 'friendly';
      } else if (value == 'OpenDyslexic') {
        fontFamily = 'easy-reading';
      } else {
        fontFamily = value;
      }
    }
    
    // Manejar shape: validar valores
    String shape = 'circle';
    if (map['shape'] != null) {
      String value = map['shape'] as String;
      if (value == 'circle' || value == 'square' || value == 'triangle') {
        shape = value;
      }
    }
    
    return UserPreferences(
      primaryColor: map['primaryColor'] ?? '0xFF2196F3',
      secondaryColor: map['secondaryColor'] ?? '0xFFFFC107',
      backgroundColor: map['backgroundColor'] ?? '0xFFFFFFFF',
      fontFamily: fontFamily,
      fontSize: fontSize,
      shape: shape,
      canCustomize: map['canCustomize'] ?? false,
    );
  }

  /// Crea una copia modificando algunos campos
  UserPreferences copyWith({
    String? primaryColor,
    String? secondaryColor,
    String? backgroundColor,
    String? fontFamily,
    String? fontSize,
    String? shape,
    bool?  canCustomize,
  }) {
    return UserPreferences(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this. secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      shape: shape ?? this.shape,
      canCustomize: canCustomize ?? this.canCustomize,
    );
  }

  /// Convierte el tamaño de fuente String a valor numérico
  double getFontSizeValue() {
    switch (fontSize) {
      case 'extra_small':
        return 12.0;
      case 'small':
        return 16.0;
      case 'default':
        return 20.0;
      case 'large':
        return 24.0;
      case 'extra_large':
        return 32.0;
      default:
        return 20.0;
    }
  }
  
  /// Convierte el fontFamily a nombre de fuente real para Flutter
  String getFontFamilyName() {
    switch (fontFamily) {
      case 'default':
        return 'Roboto';
      case 'friendly':
        return 'ComicNeue';
      case 'easy-reading':
        return 'OpenDyslexic';
      default:
        return 'Roboto';
    }
  }
}