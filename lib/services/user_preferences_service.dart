// lib/services/user_preferences_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_preferences.dart';

/// Servicio para gestionar las preferencias de usuario en Firebase
/// Permite guardar, leer y actualizar las preferencias visuales
class UserPreferencesService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Nombre de la colección en Firestore
  final String _collectionName = 'user_preferences';

  /// Guarda las preferencias de un usuario en Firestore
  /// 
  /// Parámetros:
  /// - userId: ID único del usuario
  /// - preferences: Objeto con las preferencias a guardar
  /// 
  /// Retorna: Future que se completa cuando se guardan los datos
  Future<void> savePreferences(String userId, UserPreferences preferences) async {
    try {
      // Convertimos el objeto a Map y lo guardamos en Firestore
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .set(preferences.toMap());
      
      print('✅ Preferencias guardadas correctamente para el usuario: $userId');
    } catch (e) {
      print('❌ Error al guardar preferencias: $e');
      throw Exception('No se pudieron guardar las preferencias');
    }
  }

  /// Lee las preferencias de un usuario desde Firestore
  /// 
  /// Parámetros:
  /// - userId: ID único del usuario
  /// 
  /// Retorna: Future con las preferencias del usuario
  /// Si no existen preferencias, devuelve preferencias por defecto
  Future<UserPreferences> getPreferences(String userId) async {
    try {
      // Obtenemos el documento del usuario
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      // Si el documento existe, convertimos los datos a UserPreferences
      if (doc.exists) {
        print('✅ Preferencias cargadas para el usuario: $userId');
        return UserPreferences.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        // Si no existe, creamos preferencias por defecto y las guardamos
        print('ℹ️ No hay preferencias para el usuario: $userId. Creando preferencias por defecto...');
        UserPreferences defaultPrefs = UserPreferences();
        await savePreferences(userId, defaultPrefs);
        return defaultPrefs;
      }
    } catch (e) {
      print('❌ Error al leer preferencias: $e');
      // En caso de error, devolvemos preferencias por defecto
      return UserPreferences();
    }
  }

  /// Actualiza solo algunos campos de las preferencias
  /// 
  /// Parámetros:
  /// - userId: ID único del usuario
  /// - updates: Map con los campos a actualizar
  /// 
  /// Ejemplo: updatePartialPreferences('user123', {'fontSize': 'large'})
  Future<void> updatePartialPreferences(
    String userId, 
    Map<String, dynamic> updates
  ) async {
    try {
      // Añadimos la fecha de actualización
      updates['lastUpdated'] = DateTime.now().toIso8601String();
      
      // Actualizamos solo los campos especificados
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .update(updates);
      
      print('✅ Preferencias actualizadas correctamente');
    } catch (e) {
      print('❌ Error al actualizar preferencias: $e');
      throw Exception('No se pudieron actualizar las preferencias');
    }
  }

  /// Escucha cambios en tiempo real de las preferencias de un usuario
  /// 
  /// Parámetros:
  /// - userId: ID único del usuario
  /// 
  /// Retorna: Stream que emite las preferencias cada vez que cambian
  Stream<UserPreferences> watchPreferences(String userId) {
    return _firestore
        .collection(_collectionName)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserPreferences.fromMap(
              snapshot.data() as Map<String, dynamic>
            );
          } else {
            return UserPreferences();
          }
        });
  }

  /// Elimina las preferencias de un usuario
  /// (Útil si se elimina una cuenta)
  Future<void> deletePreferences(String userId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .delete();
      
      print('✅ Preferencias eliminadas para el usuario: $userId');
    } catch (e) {
      print('❌ Error al eliminar preferencias: $e');
      throw Exception('No se pudieron eliminar las preferencias');
    }
  }
}