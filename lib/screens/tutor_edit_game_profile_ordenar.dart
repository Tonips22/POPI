import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popi/screens/home_tutor_screen.dart';
import 'ordenar_difficulty_screen.dart';
import '../services/app_service.dart';

class TutorEditGameProfileOrdenar extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String avatarPath;

  const TutorEditGameProfileOrdenar({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.avatarPath,
  });

  @override
  State<TutorEditGameProfileOrdenar> createState() =>
      _TutorEditGameProfileOrdenarState();
}

class _TutorEditGameProfileOrdenarState
    extends State<TutorEditGameProfileOrdenar> {
  final AppService _appService = AppService();

  double repeticiones = 3; // valor del slider (1–12)
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // 📥 Cargar preferencias desde Firestore
  Future<void> _loadPreferences() async {
    final user = await _appService.getUserById(widget.studentId);
    if (user == null) return;

    final rounds = user.preferences?.sortGameRounds ?? 3;

    setState(() {
      repeticiones = rounds.clamp(1, 12).toDouble(); // slider seguro
      _loading = false;
    });
  }

  // 💾 Guardar en Firestore
  Future<void> _saveSortGameRounds() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentId)
        .update({
      'preferences.sortGameRounds': repeticiones.round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            // 🔷 CABECERA
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Ordena los números",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Cantidad de rondas",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 10),

            // 🔢 SLIDER
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

            const Spacer(),

            // 🔘 BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    await _saveSortGameRounds();

                    if (context.mounted) {
                      Navigator.pop(context,true);
                    }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdenarDifficultyScreen(),
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
