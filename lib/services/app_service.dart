import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Servicio único que maneja usuarios y sesión
/// Patrón Singleton: solo existe UNA instancia en toda la app
class AppService {
  // Singleton
  static final AppService _instance = AppService._internal();
  factory AppService() => _instance;
  AppService._internal();

  // Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Usuario actual logueado
  UserModel? _currentUser;

  /// Obtiene el usuario actual
  UserModel?  get currentUser => _currentUser;

  /// Obtiene las preferencias del usuario actual
  UserPreferences? get preferences => _currentUser?.preferences;

  /// Comprueba si hay sesión activa
  bool get isLoggedIn => _currentUser != null;

  // =====================================================
  // MÉTODOS DE FIRESTORE
  // =====================================================

  /// Obtiene todos los alumnos desde Firestore
  Future<List<UserModel>> getStudents() async {
    try {
      print('📥 Cargando alumnos desde Firestore...');

      // Obtener TODOS los usuarios para depurar
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .get();

      print('🔍 Total documentos en users: ${snapshot.docs.length}');
      
      // Depuración: mostrar cada usuario
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        print('  📄 ${doc.id}: name="${data['name']}", role="${data['role']}", rol="${data['rol']}"');
      }

      List<UserModel> students = snapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((user) => user.role.toLowerCase() == 'student')
          .toList();

      print('✅ ${students.length} alumnos cargados (filtrados por role==student)');
      return students;
    } catch (e) {
      print('❌ Error al cargar alumnos: $e');
      return [];
    }
  }

  /// Obtiene un usuario específico por ID
  Future<UserModel? > getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('❌ Error al obtener usuario: $e');
      return null;
    }
  }

  /// Guarda o actualiza un usuario
  Future<bool> saveUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      print('✅ Usuario guardado: ${user.name}');
      return true;
    } catch (e) {
      print('❌ Error al guardar usuario: $e');
      return false;
    }
  }

  /// Actualiza solo las preferencias
  Future<bool> updatePreferences(
      String userId, UserPreferences preferences) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'preferences': preferences.toMap(),
      });
      print('✅ Preferencias actualizadas');
      return true;
    } catch (e) {
      print('❌ Error al actualizar preferencias: $e');
      return false;
    }
  }

  // =====================================================
  // MÉTODOS DE SESIÓN
  // =====================================================

  /// Inicia sesión con un usuario
  void login(UserModel user) {
    _currentUser = user;
    print('✅ Sesión iniciada: ${user. name} (${user.role})');
  }

  /// Cierra la sesión actual
  void logout() {
    print('👋 Sesión cerrada: ${_currentUser?.name}');
    _currentUser = null;
  }

  /// Actualiza las preferencias del usuario actual en memoria
  void updateCurrentUserPreferences(UserPreferences newPreferences) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser! .id,
        name: _currentUser!.name,
        role: _currentUser!.role,
        avatarIndex: _currentUser!.avatarIndex,
        preferences: newPreferences,
      );
      print('✅ Preferencias actualizadas en memoria');
    }
  }
}