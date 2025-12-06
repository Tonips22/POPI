import 'package:cloud_firestore/cloud_firestore.dart';

class SesionJuego {
  final int idSesion;
  final int idUsuario;
  final int tipoJuego;
  final int nAciertos;
  final int nFallos;
  final DateTime fechaSesion;

  SesionJuego({
    required this.idSesion,
    required this.idUsuario,
    required this.tipoJuego,
    required this.nAciertos,
    required this.nFallos,
    required this.fechaSesion,
  });

  factory SesionJuego.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    
    if (data == null) {
      throw Exception('Documento sin datos');
    }
    
    // Helper para convertir a int de forma segura
    int toInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }
    
    // Helper para convertir a DateTime
    DateTime toDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }
    
    return SesionJuego(
      idSesion: toInt(data['id_sesion'], 0),
      idUsuario: toInt(data['id_usuario'], 0),
      tipoJuego: toInt(data['tipo_juego'], 0),
      nAciertos: toInt(data['n_aciertos'], 0),
      nFallos: toInt(data['n_fallos'], 0),
      fechaSesion: toDateTime(data['fecha_sesion']),
    );
  }

  factory SesionJuego.fromMap(Map<String, dynamic> data) {
    // Helper para convertir a int de forma segura
    int toInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }
    
    // Helper para convertir a DateTime
    DateTime toDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }
    
    return SesionJuego(
      idSesion: toInt(data['id_sesion'], 0),
      idUsuario: toInt(data['id_usuario'], 0),
      tipoJuego: toInt(data['tipo_juego'], 0),
      nAciertos: toInt(data['n_aciertos'], 0),
      nFallos: toInt(data['n_fallos'], 0),
      fechaSesion: toDateTime(data['fecha_sesion']),
    );
  }

  String get fechaFormateada {
    return '${fechaSesion.day.toString().padLeft(2, '0')}/${fechaSesion.month.toString().padLeft(2, '0')}/${fechaSesion.year}';
  }

  String get horaFormateada {
    return '${fechaSesion.hour.toString().padLeft(2, '0')}:${fechaSesion.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'SesionJuego(id: $idSesion, usuario: $idUsuario, tipo: $tipoJuego, aciertos: $nAciertos, fallos: $nFallos, fecha: $fechaFormateada)';
  }
}
