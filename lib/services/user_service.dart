// lib/services/user_service.dart
// Servicio para gestionar usuarios y sus preferencias en la colección "users"

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  // Getter que accede a FirebaseFirestore.instance solo cuando se usa.
  FirebaseFirestore get _fs => FirebaseFirestore.instance;

  final String _collection = 'users';

  /// Asegura que exista un documento users/{userId}. Devuelve true si ya existía.
  ///
  /// IMPORTANTE:
  /// - Si Firestore está temporalmente no disponible (`unavailable`), NO relanzamos
  ///   la excepción para evitar que la app se caiga. En ese caso devolvemos `true`
  ///   asumiendo que el usuario "existe" o que ya se gestionará más adelante.
  Future<bool> ensureUserExists(String userId, {String? name, String? role}) async {
    try {
      final docRef = _fs.collection(_collection).doc(userId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        return true;
      } else {
        final profile = UserProfile(
          id: userId,
          name: name ?? 'Demo User',
          role: role ?? 'student',
          permitirPersonalizar: false,
        );
        await docRef.set(profile.toMap());
        return false;
      }
    } on FirebaseException catch (e) {
      print('FirebaseException en ensureUserExists: [${e.code}] ${e.message}');

      if (e.code == 'unavailable') {
        // Servicio no disponible (problema de red / Firestore temporalmente caído).
        // No relanzamos para que no se caiga la app.
        print('⚠️ Firestore unavailable en ensureUserExists. Se continúa sin fallar.');
        // Devolvemos true para no bloquear el flujo de la app.
        return true;
      }

      // Otros errores sí se relanzan (por ejemplo, permisos, configuración, etc.)
      rethrow;
    } catch (e) {
      print('Error genérico en ensureUserExists: $e');
      rethrow;
    }
  }

  /// Obtiene el perfil completo de un usuario (incluye preferencias)
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final docRef = _fs.collection(_collection).doc(userId);
      final snapshot = await docRef.get();
      if (!snapshot.exists) return null;
      return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      print('FirebaseException en getUserProfile: [${e.code}] ${e.message}');
      // Para errores de Firestore devolvemos null en lugar de reventar la app.
      return null;
    } catch (e) {
      print('Error genérico en getUserProfile: $e');
      return null;
    }
  }

  /// Actualiza las preferencias de un usuario
  ///
  /// Si Firestore está `unavailable`, se registra el error y se sale silenciosamente
  /// (la UI podría decidir mostrar un mensaje de "sin conexión").
  Future<void> updateUserPreferences(
      String userId, {
        String? fontFamily,
        String? fontSize,
        String? primaryColor,
        String? secondaryColor,
      }) async {
    try {
      final docRef = _fs.collection(_collection).doc(userId);

      // Construir el mapa de actualización solo con los campos proporcionados
      final Map<String, dynamic> updates = {};
      if (fontFamily != null) updates['fontFamily'] = fontFamily;
      if (fontSize != null) updates['fontSize'] = fontSize;
      if (primaryColor != null) updates['primaryColor'] = primaryColor;
      if (secondaryColor != null) updates['secondaryColor'] = secondaryColor;

      if (updates.isNotEmpty) {
        await docRef.update(updates);
        print('✅ Preferencias actualizadas para el usuario: $userId');
      }
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en updateUserPreferences: [${e.code}] ${e.message}');

      if (e.code == 'unavailable') {
        // No relanzamos para evitar crash; simplemente no se guardan los cambios.
        print('⚠️ Firestore unavailable en updateUserPreferences. Cambios no aplicados.');
        return;
      }

      rethrow;
    } catch (e) {
      print('❌ Error genérico en updateUserPreferences: $e');
      rethrow;
    }
  }

  /// Actualiza el perfil completo del usuario
  ///
  /// Igual que arriba: en caso de `unavailable`, se evita reventar la app.
  Future<void> updateUserProfile(String userId, UserProfile profile) async {
    try {
      final docRef = _fs.collection(_collection).doc(userId);
      await docRef.set(profile.toMap(), SetOptions(merge: true));
      print('✅ Perfil actualizado para el usuario: $userId');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en updateUserProfile: [${e.code}] ${e.message}');

      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en updateUserProfile. Cambios no aplicados.');
        return;
      }

      rethrow;
    } catch (e) {
      print('❌ Error genérico en updateUserProfile: $e');
      rethrow;
    }
  }

  /// Elimina un usuario
  ///
  /// Si Firestore está `unavailable`, se registra y no se relanza. En ese caso,
  /// el usuario no se llegará a borrar pero la app tampoco caerá.
  Future<void> deleteUser(String userId) async {
    try {
      await _fs.collection(_collection).doc(userId).delete();
      print('✅ Usuario eliminado: $userId');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en deleteUser: [${e.code}] ${e.message}');

      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en deleteUser. No se pudo borrar el usuario.');
        return;
      }

      rethrow;
    } catch (e) {
      print('❌ Error genérico en deleteUser: $e');
      rethrow;
    }
  }

  /// Escucha cambios en tiempo real del perfil de un usuario
  ///
  /// Si hay errores de conexión, estos se propagan por el stream, pero no como
  /// excepción sin capturar en el arranque de la app.
  Stream<UserProfile?> watchUserProfile(String userId) {
    return _fs
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  /// Obtiene todos los usuarios de la colección
  Future<List<UserProfile>> getAllUsers() async {
    try {
      final querySnapshot = await _fs.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en getAllUsers: [${e.code}] ${e.message}');
      if (e.code == 'unavailable') {
        print('⚠️ Firestore unavailable en getAllUsers. Devolviendo lista vacía.');
        return [];
      }
      rethrow;
    } catch (e) {
      print('❌ Error genérico en getAllUsers: $e');
      rethrow;
    }
  }
}