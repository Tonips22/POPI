// lib/models/user_profile.dart
// Modelo simple de perfil de usuario (para la colección "users")
class UserProfile {
  final String id;
  final String name;
  final String role; // 'student', 'tutor', 'admin' (por ejemplo)
  final DateTime createdAt;

  UserProfile({
    required this.id,
    this.name = 'Demo User',
    this.role = 'student',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Demo User',
      role: map['role'] ?? 'student',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}