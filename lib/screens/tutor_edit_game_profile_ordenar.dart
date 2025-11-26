import 'package:flutter/material.dart';
import 'package:popi/screens/home_tutor_screen.dart';
import 'ordenar_difficulty_screen.dart'; // Importamos la pantalla de dificultad

class TutorEditGameProfileOrdenar extends StatefulWidget {
  final String studentName;
  final String avatarPath;

  const TutorEditGameProfileOrdenar({
    super.key,
    required this.studentName,
    required this.avatarPath,
  });

  @override
  State<TutorEditGameProfileOrdenar> createState() =>
      _TutorEditGameProfileOrdenarState();
}

class _TutorEditGameProfileOrdenarState
    extends State<TutorEditGameProfileOrdenar> {
  double repeticiones = 3;
  bool rondasInfinitas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "TUTOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔷 Caja superior con avatar + nombre + texto
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8DBDFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(widget.avatarPath),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF71B1FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Configurar perfil de juegos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Ordena los números",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Cantidad de repeticiones",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Slider(
              value: repeticiones,
              min: 1,
              max: 12,
              divisions: 11,
              label: repeticiones.round().toString(),
              onChanged: (value) {
                setState(() {
                  repeticiones = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: rondasInfinitas,
                  onChanged: (value) {
                    setState(() {
                      rondasInfinitas = value!;
                    });
                  },
                ),
                const Text(
                  "Rondas infinitas",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  onPressed: () {
                    // Navegar a la pantalla de ajustar dificultad
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TutorHomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  onPressed: () {
                    // Navegar a la pantalla de ajustar dificultad
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdenarDifficultyScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Ajustar dificultad",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
