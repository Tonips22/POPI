/// Modelos de datos para las preferencias de visualización de números
/// 
/// Estos modelos definen cómo el estudiante prefiere ver y escuchar
/// los números y objetos en los juegos

/// Tipos de visualización de números disponibles
enum NumberDisplayType {
  /// Muestra el número escrito (1, 2, 3...)
  grafia,
  
  /// Muestra un pictograma de ARASAAC representando el número
  pictograma,
  
  /// Reproduce el audio del número (síntesis de voz o grabación)
  audio,
  
  /// Muestra dibujos/imágenes representando la cantidad (ej: 3 manzanas)
  dibujo,
}

/// Extensión para obtener el nombre legible de cada tipo
extension NumberDisplayTypeExtension on NumberDisplayType {
  String get displayName {
    switch (this) {
      case NumberDisplayType.grafia:
        return 'Grafía de números';
      case NumberDisplayType.pictograma:
        return 'Pictograma';
      case NumberDisplayType.audio:
        return 'Audio';
      case NumberDisplayType.dibujo:
        return 'Dibujo';
    }
  }
}

/// Clase que almacena las preferencias de visualización del estudiante
class NumberFormatPreferences {
  // Tipo de visualización seleccionado
  final NumberDisplayType displayType;
  
  // URL de la imagen personalizada (si existe)
  final String? customImageUrl;
  
  // URL del audio personalizado (si existe)
  final String? customAudioUrl;
  
  const NumberFormatPreferences({
    required this.displayType,
    this.customImageUrl,
    this.customAudioUrl,
  });
  
  /// Crea una instancia con valores por defecto
  factory NumberFormatPreferences.defaultPreferences() {
    return const NumberFormatPreferences(
      displayType: NumberDisplayType.grafia,
      customImageUrl: null,
      customAudioUrl: null,
    );
  }
  
  /// Convierte a Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'displayType': displayType.name,
      'customImageUrl': customImageUrl,
      'customAudioUrl': customAudioUrl,
    };
  }
  
  /// Crea una instancia desde un Map de Firebase
  factory NumberFormatPreferences.fromMap(Map<String, dynamic> map) {
    return NumberFormatPreferences(
      displayType: NumberDisplayType.values.firstWhere(
        (e) => e.name == map['displayType'],
        orElse: () => NumberDisplayType.grafia,
      ),
      customImageUrl: map['customImageUrl'] as String?,
      customAudioUrl: map['customAudioUrl'] as String?,
    );
  }
  
  /// Crea una copia con algunos campos modificados
  NumberFormatPreferences copyWith({
    NumberDisplayType? displayType,
    String? customImageUrl,
    String? customAudioUrl,
  }) {
    return NumberFormatPreferences(
      displayType: displayType ?? this.displayType,
      customImageUrl: customImageUrl ?? this.customImageUrl,
      customAudioUrl: customAudioUrl ?? this.customAudioUrl,
    );
  }
}