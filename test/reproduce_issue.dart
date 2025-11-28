
import 'package:flutter_test/flutter_test.dart';
import 'package:popi/models/user_profile.dart';

void main() {
  test('UserProfile.fromMap handles user provided data', () {
    final data = {
      "createdAt": "2025-11-25T11:36:05.204",
      "fontFamily": "opendyslexic",
      "fontSize": "small",
      "id": "demo",
      "name": "Alumno Demo",
      "permitir_personalizar": false,
      "primaryColor": "#4CAF50",
      "role": "student",
      "secondaryColor": "#2196F3"
    };

    try {
      final user = UserProfile.fromMap(data);
      print('User parsed successfully: ${user.name}');
      expect(user.id, 'demo');
      expect(user.createdAt.year, 2025);
      expect(user.permitirPersonalizar, false);
    } catch (e) {
      print('Error parsing user: $e');
      fail('Should not throw exception');
    }
  });

  test('UserProfile.fromMap handles int values in String fields', () {
    final data = {
      "createdAt": "2025-11-25T11:36:05.204",
      "fontFamily": 123, // Should be String
      "fontSize": 14, // Should be String
      "id": 101, // Should be String
      "name": "Alumno Int",
      "permitir_personalizar": false,
      "primaryColor": "#4CAF50",
      "role": "student",
      "secondaryColor": "#2196F3"
    };

    try {
      final user = UserProfile.fromMap(data);
      print('User parsed successfully: ${user.name}');
      expect(user.id, '101');
      expect(user.fontFamily, '123');
      expect(user.fontSize, '14');
    } catch (e) {
      print('Error parsing user with ints: $e');
      rethrow;
    }
  });
}
