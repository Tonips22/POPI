import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';
import 'tutor_edit_password_screen.dart';

class TutorEditProfileScreen extends StatefulWidget {
  final String studentId;

  const TutorEditProfileScreen({super.key, required this.studentId});

  @override
  State<TutorEditProfileScreen> createState() =>
      _TutorEditProfileScreenState();
}

class _TutorEditProfileScreenState extends State<TutorEditProfileScreen> {
  final AppService _appService = AppService();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;

  UserModel? _student;

  int _selectedAvatarIndex = 0;
  final List<String> _avatarNames = [
    'avatar0',
    'avatar1',
    'avatar2',
    'avatar3',
    'avatar4',
    'avatar5',
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentFromDb();
  }

  Future<void> _loadStudentFromDb() async {
    final student = await _appService.getUserById(widget.studentId);

    if (student != null && mounted) {
      setState(() {
        _student = student;
        _nameController.text = student.name;
        _selectedAvatarIndex = student.avatarIndex;
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF5CA7FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 240,
          child: Column(
            children: [
              const Text(
                'Elige un avatar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _avatarNames.length,
                  itemBuilder: (context, index) {
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
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/${_avatarNames[index]}.jpg',
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

  Future<void> _goToPasswordScreen() async {
    if (_student == null) return;

    final updatedStudent = _student!.copyWith(
      name: _nameController.text.trim(),
      avatarIndex: _selectedAvatarIndex,
    );

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TutorEditPasswordScreen(student: updatedStudent),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
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
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(
                  'assets/images/${_avatarNames[_selectedAvatarIndex]}.jpg',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _nameController.text.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Nombre del alumno",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Avatar del alumno",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                    'assets/images/${_avatarNames[_selectedAvatarIndex]}.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Toca para cambiar avatar',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  onPressed: _goToPasswordScreen,
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
