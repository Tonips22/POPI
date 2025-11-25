// lib/utils/migrate_preferences.dart
// Script de migración para mover preferencias de user_preferences a users

import 'package:cloud_firestore/cloud_firestore.dart';

/// Migra las preferencias de la colección user_preferences a la colección users
/// Este script solo se debe ejecutar una vez durante la migración
class PreferencesMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ejecuta la migración
  Future<void> migrate() async {
    print('🔄 Iniciando migración de preferencias...');
    
    try {
      // Obtener todas las preferencias de la colección antigua
      final prefsSnapshot = await _firestore.collection('user_preferences').get();
      
      if (prefsSnapshot.docs.isEmpty) {
        print('ℹ️ No hay preferencias para migrar');
        return;
      }

      int migratedCount = 0;
      int errorCount = 0;

      // Por cada documento de preferencias
      for (var prefDoc in prefsSnapshot.docs) {
        try {
          final userId = prefDoc.id;
          final prefData = prefDoc.data();
          
          // Obtener el documento de usuario correspondiente
          final userDoc = await _firestore.collection('users').doc(userId).get();
          
          if (!userDoc.exists) {
            print('⚠️ Usuario $userId no existe, saltando...');
            errorCount++;
            continue;
          }

          // Actualizar el documento de usuario con las preferencias
          await _firestore.collection('users').doc(userId).update({
            'fontFamily': prefData['fontFamily'] ?? 'default',
            'fontSize': prefData['fontSize'] ?? 'medium',
            'primaryColor': prefData['primaryColor'] ?? '#4CAF50',
            'secondaryColor': prefData['secondaryColor'] ?? '#2196F3',
          });

          print('✅ Migrado: $userId');
          migratedCount++;
          
        } catch (e) {
          print('❌ Error migrando usuario ${prefDoc.id}: $e');
          errorCount++;
        }
      }

      print('');
      print('📊 Migración completada:');
      print('   ✅ Exitosos: $migratedCount');
      print('   ❌ Errores: $errorCount');
      print('');
      print('⚠️ NOTA: Puedes eliminar la colección user_preferences manualmente desde Firebase Console');
      
    } catch (e) {
      print('❌ Error general en la migración: $e');
      rethrow;
    }
  }

  /// Verifica si hay datos en la colección antigua
  Future<bool> needsMigration() async {
    try {
      final snapshot = await _firestore
          .collection('user_preferences')
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando migración: $e');
      return false;
    }
  }
}
