// lib/services/sesion_juego_service.dart
// Servicio para gestionar sesiones de juego en la colección "juegos"

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sesion_juego.dart';

class SesionJuegoService {
  // Getter que accede a FirebaseFirestore.instance solo cuando se usa.
  FirebaseFirestore get _fs => FirebaseFirestore.instance;

  final String _collection = 'juegos';

  /// Obtiene todas las sesiones de juego de la colección
  Future<List<SesionJuego>> getAllSesiones() async {
    try {
      print('🔍 Intentando obtener sesiones de la colección "$_collection"...');
      
      // Habilitar red explícitamente
      try {
        await _fs.enableNetwork();
        print('✅ Red de Firestore habilitada');
      } catch (e) {
        print('⚠️ Error al habilitar red: $e');
      }
      
      // Forzar lectura desde el servidor
      final querySnapshot = await _fs
          .collection(_collection)
          .get(const GetOptions(source: Source.server));
      
      print('📊 Documentos encontrados: ${querySnapshot.docs.length}');
      
      if (querySnapshot.docs.isEmpty) {
        print('⚠️ No se encontraron documentos. Verificando conexión...');
        print('   Metadata: ${querySnapshot.metadata}');
      }
      
      final sesiones = querySnapshot.docs.map((doc) {
        try {
          print('📄 Procesando documento: ${doc.id}');
          print('   Datos: ${doc.data()}');
          return SesionJuego.fromFirestore(doc);
        } catch (e) {
          print('❌ Error al parsear documento ${doc.id}: $e');
          rethrow;
        }
      }).toList();
      
      print('✅ Total de sesiones cargadas: ${sesiones.length}');
      return sesiones;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getAllSesiones: [${e.code}] ${e.message}');
      print('   Stack trace: ${e.stackTrace}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en getAllSesiones. Devolviendo lista vacía.');
        return [];
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getAllSesiones: $e');
      rethrow;
    }
  }

  /// Obtiene una sesión específica por su ID de documento
  Future<SesionJuego?> getSesionById(String docId) async {
    try {
      final docSnapshot = await _fs.collection(_collection).doc(docId).get();
      
      if (docSnapshot.exists) {
        return SesionJuego.fromFirestore(docSnapshot);
      } else {
        print('⚠️ No se encontró la sesión con ID: $docId');
        return null;
      }
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getSesionById: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en getSesionById.');
        return null;
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getSesionById: $e');
      rethrow;
    }
  }

  /// Obtiene sesiones filtradas por ID de usuario
  Future<List<SesionJuego>> getSesionesByUsuario(int idUsuario) async {
    try {
      final querySnapshot = await _fs
          .collection(_collection)
          .where('id_usuario', isEqualTo: idUsuario)
          .get();
      
      return querySnapshot.docs
          .map((doc) => SesionJuego.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getSesionesByUsuario: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en getSesionesByUsuario. Devolviendo lista vacía.');
        return [];
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getSesionesByUsuario: $e');
      rethrow;
    }
  }

  /// Obtiene sesiones filtradas por tipo de juego
  Future<List<SesionJuego>> getSesionesByTipoJuego(int tipoJuego) async {
    try {
      final querySnapshot = await _fs
          .collection(_collection)
          .where('tipo_juego', isEqualTo: tipoJuego)
          .get();
      
      return querySnapshot.docs
          .map((doc) => SesionJuego.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getSesionesByTipoJuego: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en getSesionesByTipoJuego. Devolviendo lista vacía.');
        return [];
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getSesionesByTipoJuego: $e');
      rethrow;
    }
  }

  /// Stream para escuchar cambios en todas las sesiones
  Stream<List<SesionJuego>> watchAllSesiones() {
    return _fs
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SesionJuego.fromFirestore(doc))
          .toList();
    });
  }

  /// Crea una nueva sesión de juego
  Future<void> createSesion(SesionJuego sesion) async {
    try {
      await _fs.collection(_collection).add({
        'id_sesion': sesion.idSesion,
        'id_usuario': sesion.idUsuario,
        'tipo_juego': sesion.tipoJuego,
        'n_aciertos': sesion.nAciertos,
        'n_fallos': sesion.nFallos,
        'fecha_sesion': Timestamp.fromDate(sesion.fechaSesion),
      });
      print('✅ Sesión creada: ${sesion.idSesion}');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en createSesion: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en createSesion. Sesión no creada.');
        return;
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en createSesion: $e');
      rethrow;
    }
  }
}
