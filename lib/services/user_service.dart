// lib/services/user_service.dart
// Servicio sencillo para crear/asegurar perfil "demo" y obtener perfiles.
// Implementado de forma "lazy" para no acceder a Firestore antes de la inicialización.

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
      // Mensaje claro para debugging
      print('FirebaseException en ensureUserExists: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error genérico en ensureUserExists: $e');
      rethrow;
    }
  }

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

  Future<void> deleteUser(String userId) async {
    await _fs.collection(_collection).doc(userId).delete();
  }
}