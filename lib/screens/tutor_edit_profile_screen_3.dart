import 'package:flutter/material.dart';
import 'package:popi/screens/home_tutor_screen.dart';

class TutorEditProfileScreen3 extends StatefulWidget {
  final String studentName;
  final String avatarPath;

  const TutorEditProfileScreen3({
    super.key,
    required this.studentName,
    required this.avatarPath,
  });

  @override
  State<TutorEditProfileScreen3> createState() => _TutorEditProfileScreen3State();
}

class _TutorEditProfileScreen3State extends State<TutorEditProfileScreen3> {
  bool allowStudentCustomization = false; // Alterna entre Sí/No

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "TUTOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cabecera del alumno
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFAAD2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.avatarPath),
                    radius: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.studentName.toUpperCase(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Opción Permitir personalización
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF5CA7FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Permitir personalización por parte del estudiante?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: allowStudentCustomization,
                    onChanged: (value) {
                      setState(() {
                        allowStudentCustomization = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botones Inferiores
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TutorHomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: const Color(0xFF5CA7FF),
                  ),
                  child: const Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
