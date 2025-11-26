// lib/services/user_service.dart
// Servicio para gestionar usuarios y sus preferencias en la colección "users"

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  // Getter que accede a FirebaseFirestore.instance solo cuando se usa.
  FirebaseFirestore get _fs => FirebaseFirestore.instance;

  final String _collection = 'users';

  /// Asegura que exista un documento users/{userId}. Devuelve true si ya existía.
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
        );
        await docRef.set(profile.toMap());
        return false;
      }
    } on FirebaseException catch (e) {
      print('FirebaseException en ensureUserExists: ${e.message}');

      // 🔴 Si Firestore no está disponible (sin red / servicio caído),
      // NO reventamos la app: dejamos seguir y devolvemos false.
      if (e.code == 'unavailable') {
        print('Firestore unavailable en ensureUserExists, continúo sin relanzar.');
        return false;
      }

      // Para otros códigos de error, sí relanzamos para no ocultar bugs de lógica.
      rethrow;
    } catch (e) {
      print('Error genérico en ensureUserExists: $e');
      // Si quieres que absolutamente nunca crashee aquí, puedes devolver false en vez de rethrow:
      // return false;
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
      print('FirebaseException en getUserProfile: ${e.message}');
      return null;
    } catch (e) {
      print('Error genérico en getUserProfile: $e');
      return null;
    }
  }

  /// Actualiza las preferencias de un usuario
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
      print('❌ FirebaseException en updateUserPreferences: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error genérico en updateUserPreferences: $e');
      rethrow;
    }
  }

  /// Actualiza el perfil completo del usuario
  Future<void> updateUserProfile(String userId, UserProfile profile) async {
    try {
      final docRef = _fs.collection(_collection).doc(userId);
      await docRef.set(profile.toMap(), SetOptions(merge: true));
      print('✅ Perfil actualizado para el usuario: $userId');
    } on FirebaseException catch (e) {
      print('❌ FirebaseException en updateUserProfile: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ Error genérico en updateUserProfile: $e');
      rethrow;
    }
  }

  /// Elimina un usuario
  Future<void> deleteUser(String userId) async {
    await _fs.collection(_collection).doc(userId).delete();
  }

  /// Escucha cambios en tiempo real del perfil de un usuario
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
}