import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'tutor_edit_profile_screen_2.dart';

class TutorEditProfileScreen extends StatefulWidget {
  final String studentId;

  const TutorEditProfileScreen({super.key, required this.studentId});

  @override
  State<TutorEditProfileScreen> createState() =>
      _TutorEditProfileScreenState();
}

class _TutorEditProfileScreenState extends State<TutorEditProfileScreen> {
  final AppService _appService = AppService();
  final UserService _userService = UserService();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

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

  final List<int> _password = [];
  bool _noPassword = false;
  final List<_Animal> _animals = const [
    _Animal('🦁', Color(0xFFFFF3CD)),
    _Animal('🧸', Color(0xFFF5E6FF)),
    _Animal('🐯', Color(0xFFFFE0B2)),
    _Animal('🦓', Color(0xFFE0E0E0)),
    _Animal('🐊', Color(0xFFD4EDDA)),
    _Animal('🐸', Color(0xFFDFF5FF)),
    _Animal('🦥', Color(0xFFFCE4EC)),
    _Animal('🦒', Color(0xFFE8F5E9)),
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

  void _addAnimal(int index) {
    if (_noPassword || _password.length >= 4) return;
    setState(() => _password.add(index));
  }

  void _backspace() {
    if (_password.isEmpty) return;
    setState(() => _password.removeLast());
  }

  void _toggleNoPassword(bool value) {
    setState(() {
      _noPassword = value;
      if (value) {
        _password.clear();
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_student == null) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce el nombre del alumno'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!_noPassword && _password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Selecciona de 1 a 4 emojis o marca la opción sin contraseña'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final password = _noPassword ? null : _password.join('');

    setState(() => _isSaving = true);

    try {
      final updatedStudent = _student!.copyWith(
        name: name,
        avatarIndex: _selectedAvatarIndex,
        password: password,
      );

      await _userService.updateUserProfile(_student!.id, updatedStudent);
      await _userService.updatePassword(_student!.id, password);

      if (!mounted) return;

      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => TutorEditProfileScreen2(student: updatedStudent),
        ),
      );

      if (result == true && mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar cambios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildPasswordSlots() {
    const double slotSize = 56;
    return Opacity(
      opacity: _noPassword ? 0.4 : 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 4; i++) ...[
            Container(
              width: slotSize,
              height: slotSize,
              decoration: BoxDecoration(
                color: i < _password.length
                    ? _animals[_password[i]].bg
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              alignment: Alignment.center,
              child: i < _password.length
                  ? Text(
                      _animals[_password[i]].emoji,
                      style: const TextStyle(fontSize: 26),
                    )
                  : null,
            ),
            if (i < 3) const SizedBox(width: 8),
          ],
          const SizedBox(width: 8),
          InkWell(
            onTap: _noPassword ? null : _backspace,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: slotSize,
              height: slotSize,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.backspace_outlined, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalsGrid() {
    const double gridSpacing = 6;
    return IgnorePointer(
      ignoring: _noPassword,
      child: Opacity(
        opacity: _noPassword ? 0.35 : 1,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: gridSpacing,
              crossAxisSpacing: gridSpacing,
              mainAxisExtent: 80,
            ),
            itemCount: _animals.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final animal = _animals[index];
              return InkWell(
                onTap: _password.length < 4 ? () => _addAnimal(index) : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: animal.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    animal.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
          const SizedBox(height: 24),
          const Text(
            "Contraseña del alumno",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Selecciona entre 1 y 4 emojis en orden o deja al alumno sin contraseña.",
          ),
          const SizedBox(height: 14),
          _buildPasswordSlots(),
          const SizedBox(height: 12),
          _buildAnimalsGrid(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Sin contraseña',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Se podrá asignar una contraseña nueva desde este panel cuando lo necesites.',
            ),
            value: _noPassword,
            onChanged: _toggleNoPassword,
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
                  onPressed: _isSaving ? null : _saveAndContinue,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        )
                      : const Text("Continuar"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Animal {
  final String emoji;
  final Color bg;
  const _Animal(this.emoji, this.bg);
}
