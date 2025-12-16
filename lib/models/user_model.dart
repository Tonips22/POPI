/// Modelo simplificado de usuario para el sistema de login
class UserModel {
  final String id;
  final String name;
  final String role;
  final int avatarIndex;
  final String? password; // Password de 4 dígitos (opcional)
  final String? tutorId;
  final UserPreferences preferences;

  UserModel({
    required this.id,
    required this. name,
    required this.role,
    required this.avatarIndex,
    this.password,
    this.tutorId,
    required this.preferences,
  });

  /// Convierte el usuario a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'avatarIndex': avatarIndex,
      'password': password,
      'tutorId': tutorId,
      'preferences': preferences.toMap(),
    };
  }

  /// Crea un usuario desde Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    String? tutorId;

    final dynamic rawTutorId = map['tutorId'];
    if (rawTutorId != null) {
      tutorId = rawTutorId.toString(); //
    }

    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      role: map['role'] ?? 'student',
      avatarIndex: map['avatarIndex'] ?? 0,
      password: map['password'],
      tutorId: tutorId,
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
    );
  }

  /// Crea una copia del UserModel con campos opcionalmente modificados
  UserModel copyWith({
    String? name,
    int? avatarIndex,
    UserPreferences? preferences,
    String? role,
    String? password,
    String? tutorId,
  }) {
    return UserModel(
      id: id, // el id nunca cambia
      name: name ?? this.name,
      role: role ?? this.role,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      password: password ?? this.password,
      tutorId: tutorId ?? this.tutorId,
      preferences: preferences ?? this.preferences,
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
  final String? voiceText; // 'none', 'double', 'long' or null (default)
  final String? reactionType; // tipo de reacción seleccionada
  final int touchGameRounds;
  final int sortGameRounds;
  final int shareGameRounds;
  final int subtractGameRounds;
  final bool showTutorialJuego1;
  final bool showTutorialJuego2;
  final bool showTutorialJuego3;
  final bool showTutorialJuego4;

  UserPreferences({
    this.primaryColor = '0xFF2196F3',
    this.secondaryColor = '0xFFFFC107',
    this.backgroundColor = '0xFFFFFFFF',
    this.fontFamily = 'default',
    this.fontSize = 'default',
    this.shape = 'circle',
    this.canCustomize = false,
    this.voiceText,
    this.reactionType,
    this.touchGameRounds = 5,
    this.sortGameRounds = 5,
    this.shareGameRounds = 5,
    this.subtractGameRounds = 5,
    this.showTutorialJuego1 = true,
    this.showTutorialJuego2 = true,
    this.showTutorialJuego3 = true,
    this.showTutorialJuego4 = true,
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
      'voiceText': voiceText,
      'tipo_reaccion': reactionType,
      'touchGameRounds': touchGameRounds,
      'sortGameRounds': sortGameRounds,
      'shareGameRounds': shareGameRounds,
      'subtractGameRounds': subtractGameRounds,
      'showTutorialJuego1': showTutorialJuego1,
      'showTutorialJuego2': showTutorialJuego2,
      'showTutorialJuego3': showTutorialJuego3,
      'showTutorialJuego4': showTutorialJuego4,
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
      voiceText: map['voiceText'],
      reactionType: map['tipo_reaccion'],
      touchGameRounds: _parseRounds(map['touchGameRounds']),
      sortGameRounds: _parseRounds(map['sortGameRounds']),
      shareGameRounds: _parseRounds(map['shareGameRounds']),
      subtractGameRounds: _parseRounds(map['subtractGameRounds']),
      showTutorialJuego1:
          map['showTutorialJuego1'] is bool ? map['showTutorialJuego1'] as bool : true,
      showTutorialJuego2:
          map['showTutorialJuego2'] is bool ? map['showTutorialJuego2'] as bool : true,
      showTutorialJuego3:
          map['showTutorialJuego3'] is bool ? map['showTutorialJuego3'] as bool : true,
      showTutorialJuego4:
          map['showTutorialJuego4'] is bool ? map['showTutorialJuego4'] as bool : true,
    );
  }

  static const _unset = Object();

  static int _parseRounds(dynamic value, {int fallback = 5}) {
    if (value is int) {
      return value.clamp(1, 20);
    }
    if (value is num) {
      return value.toInt().clamp(1, 20);
    }
    return fallback;
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
    Object? voiceText = _unset,
    Object? reactionType = _unset,
    int? touchGameRounds,
    int? sortGameRounds,
    int? shareGameRounds,
    int? subtractGameRounds,
    bool? showTutorialJuego1,
    bool? showTutorialJuego2,
    bool? showTutorialJuego3,
    bool? showTutorialJuego4,
  }) {
    return UserPreferences(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this. secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      shape: shape ?? this.shape,
      canCustomize: canCustomize ?? this.canCustomize,
      voiceText: identical(voiceText, _unset) ? this.voiceText : voiceText as String?,
      reactionType: identical(reactionType, _unset)
          ? this.reactionType
          : reactionType as String?,
      touchGameRounds: touchGameRounds ?? this.touchGameRounds,
      sortGameRounds: sortGameRounds ?? this.sortGameRounds,
      shareGameRounds: shareGameRounds ?? this.shareGameRounds,
      subtractGameRounds: subtractGameRounds ?? this.subtractGameRounds,
      showTutorialJuego1: showTutorialJuego1 ?? this.showTutorialJuego1,
      showTutorialJuego2: showTutorialJuego2 ?? this.showTutorialJuego2,
      showTutorialJuego3: showTutorialJuego3 ?? this.showTutorialJuego3,
      showTutorialJuego4: showTutorialJuego4 ?? this.showTutorialJuego4,
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
