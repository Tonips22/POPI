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

  /// Obtiene el siguiente id_sesion incremental
  Future<int> getNextSessionId() async {
    try {
      final snapshot = await _fs
          .collection(_collection)
          .orderBy('id_sesion', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return 1;
      }

      final data = snapshot.docs.first.data();
      final dynamic currentId = data['id_sesion'];
      if (currentId is int) return currentId + 1;
      if (currentId is num) return currentId.toInt() + 1;
      if (currentId is String) {
        final parsed = int.tryParse(currentId);
        if (parsed != null) return parsed + 1;
      }
      return 1;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getNextSessionId: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') return 1;
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getNextSessionId: $e');
      return 1;
    }
  }

  /// Obtiene el siguiente contador de sesión para un usuario específico sin requerir índices compuestos.
  Future<int> getNextSessionCounter(int userId) async {
    try {
      final snapshot = await _fs
          .collection(_collection)
          .where('id_usuario', isEqualTo: userId)
          .get();

      int maxCounter = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final dynamic current = data['sesion_contador'];
        if (current is int) {
          if (current > maxCounter) maxCounter = current;
        } else if (current is num) {
          final value = current.toInt();
          if (value > maxCounter) maxCounter = value;
        } else if (current is String) {
          final value = int.tryParse(current);
          if (value != null && value > maxCounter) {
            maxCounter = value;
          }
        }
      }

      return maxCounter + 1;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getNextSessionCounter: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') return 1;
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getNextSessionCounter: $e');
      return 1;
    }
  }

  /// Crea una sesión vacía para registrar resultados posteriormente
  Future<String> createEmptySession({
    required int sessionId,
    required int userNumericId,
    required int gameType,
    required int sessionCounter,
  }) async {
    try {
      final doc = await _fs.collection(_collection).add({
        'id_sesion': sessionId,
        'id_usuario': userNumericId,
        'tipo_juego': gameType,
        'n_aciertos': 0,
        'n_fallos': 0,
        'fecha_sesion': Timestamp.fromDate(DateTime.now()),
        'sesion_contador': sessionCounter,
      });
      print('✅ Sesión creada: $sessionId (doc ${doc.id})');
      return doc.id;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en createEmptySession: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en createEmptySession.');
        rethrow;
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en createEmptySession: $e');
      rethrow;
    }
  }

  /// Actualiza los contadores de una sesión existente
  Future<void> updateSessionStats({
    required String docId,
    required int hits,
    required int fails,
  }) async {
    try {
      await _fs.collection(_collection).doc(docId).update({
        'n_aciertos': hits,
        'n_fallos': fails,
        'fecha_sesion': Timestamp.fromDate(DateTime.now()),
      });
      print('✅ Sesión actualizada ($docId): hits=$hits, fails=$fails');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en updateSessionStats: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en updateSessionStats.');
        return;
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en updateSessionStats: $e');
      rethrow;
    }
  }

  /// Elimina por completo la sesión indicada
  Future<void> deleteSessionByDoc(String docId) async {
    try {
      await _fs.collection(_collection).doc(docId).delete();
      print('🗑️ Sesión eliminada: $docId');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en deleteSessionByDoc: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') return;
      rethrow;
    } catch (e) {
      print('❌ Error genérico en deleteSessionByDoc: $e');
      rethrow;
    }
  }
}
