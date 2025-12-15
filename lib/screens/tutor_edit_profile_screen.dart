import 'package:flutter/material.dart';
import 'tutor_edit_profile_screen_2.dart';
import 'allow_personalization.dart';

class TutorEditProfileScreen extends StatefulWidget {
  final String studentName;
  final String avatarPath;
  final String studentId;

  const TutorEditProfileScreen({
    super.key,
    required this.studentName,
    required this.avatarPath,
    required this.studentId,
  });

  @override
  State<TutorEditProfileScreen> createState() =>
      _TutorEditProfileScreenState();
}

class _TutorEditProfileScreenState extends State<TutorEditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  int _selectedAvatarIndex = 0;
  final List<String> _avatarNames = ['avatar1', 'avatar2', 'avatar3', 'avatar4'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.studentName;
    for (int i = 0; i < _avatarNames.length; i++) {
      if (widget.avatarPath.contains(_avatarNames[i])) {
        _selectedAvatarIndex = i;
        break;
      }
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF5CA7FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 220,
          child: Column(
            children: [
              const Text(
                'Elige un avatar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _avatarNames.length,
                  itemBuilder: (context, index) {
                    final avatarName = _avatarNames[index];
                    final isSelected = _selectedAvatarIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatarIndex = index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/$avatarName.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cabecera
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/${_avatarNames[_selectedAvatarIndex]}.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _nameController.text.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nombre
          const Text("Nombre del alumno", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(height: 16),

          // Avatar
          const Text("Avatar del alumno", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: _showAvatarSelection,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/${_avatarNames[_selectedAvatarIndex]}.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('Toca para cambiar avatar', style: TextStyle(fontSize: 12))),

          const SizedBox(height: 24),
          

          const SizedBox(height: 24),

          // Botones inferiores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TutorEditProfileScreen2(
                          studentName: _nameController.text,
                          avatarPath: 'assets/images/${_avatarNames[_selectedAvatarIndex]}.png',
                        ),
                      ),
                    );
                  },
                  child: const Text("Continuar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
