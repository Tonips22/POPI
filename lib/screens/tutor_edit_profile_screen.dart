import 'package:flutter/material.dart';
import 'tutor_edit_profile_screen_2.dart';

class TutorEditProfileScreen extends StatefulWidget {
  final String studentName;
  final String avatarPath;

  const TutorEditProfileScreen({
    super.key,
    required this.studentName,
    required this.avatarPath,
  });

  @override
  State<TutorEditProfileScreen> createState() => _TutorEditProfileScreenState();
}

class _TutorEditProfileScreenState extends State<TutorEditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAvatarIndex;

  final List<String> _avatars = List.generate(
    16,
        (i) => "assets/images/avatar${(i % 4) + 1}.png",
  );

  static const double avatarSize = 40; // Reducido de 60 a 40

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.studentName;
    _selectedAvatarIndex = _avatars.indexOf(widget.avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "TUTOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Reducido de 26 a 20
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8), // Reducido
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12), // Reducido de 20
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---- Cabecera del alumno ----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reducido
              decoration: BoxDecoration(
                color: const Color(0xFFAAD2FF),
                borderRadius: BorderRadius.circular(10), // Reducido
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.avatarPath),
                    radius: 16, // Reducido de 20
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.studentName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16, // Reducido de 18
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reducido
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10), // Reducido
                    ),
                    child: const Text(
                      "Configurar perfil",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Reducido
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12), // Reducido

            // ---- Tarjeta de edición ----
            Container(
              padding: const EdgeInsets.all(12), // Reducido
              decoration: BoxDecoration(
                color: const Color(0xFF5CA7FF),
                borderRadius: BorderRadius.circular(12), // Reducido
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nombre y avatar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Reducido
                    ),
                  ),

                  const Divider(color: Colors.black, thickness: 1),

                  const SizedBox(height: 8), // Reducido

                  // Campo nombre
                  const Text(
                    "Nombre del alumno",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Reducido
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reducido
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6), // Reducido
                      ),
                    ),
                  ),

                  const SizedBox(height: 12), // Reducido

                  // Avatares
                  const Text(
                    "Avatar del alumno:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Reducido
                  ),
                  const SizedBox(height: 6), // Reducido

                  Wrap(
                    spacing: 6, // Reducido
                    runSpacing: 6, // Reducido
                    children: List.generate(_avatars.length, (i) {
                      final bool selected = _selectedAvatarIndex == i;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatarIndex = i;
                          });
                        },
                        child: Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6), // Reducido
                            border: Border.all(
                              color: selected ? Colors.black : Colors.grey,
                              width: selected ? 2 : 1, // Reducido
                            ),
                            image: DecorationImage(
                              image: AssetImage(_avatars[i]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12), // Reducido

                  // Avatar seleccionado
                  Row(
                    children: [
                      const Text(
                        "Imagen seleccionada:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Reducido
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(6), // Reducido
                          image: _selectedAvatarIndex != null
                              ? DecorationImage(
                            image: AssetImage(
                                _avatars[_selectedAvatarIndex!]),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 24), // Reducido
                        onPressed: () {
                          setState(() {
                            _selectedAvatarIndex = null;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15), // Reducido

            // ---- Botones inferior ----
// ... resto del código idéntico ...

// Dentro de Row de botones inferiores:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancelar
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Continuar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TutorEditProfileScreen2(
                          studentName: widget.studentName,
                          avatarPath: widget.avatarPath,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
