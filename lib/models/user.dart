import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String role;
  final String tutor;
  final bool activo;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.tutor,
    required this.activo,
    required this.createdAt,
  });

  factory UserProfile.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      id: doc.id,
      name: data['nombre'] ?? '',
      role: data['rol'] ?? '',
      tutor: data['tutor'] ?? '',
      activo: data['activo'] ?? false,
      createdAt: (data['fechaCreacion'] as Timestamp).toDate(),
    );
  }

  static Future<List<UserProfile>> fetchAllUsers() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('usuarios').get();

    return snapshot.docs.map((doc) => UserProfile.fromFirebase(doc)).toList();
  }
}