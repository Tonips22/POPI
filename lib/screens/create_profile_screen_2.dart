import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class CreateProfileScreen2 extends StatefulWidget {
  final String studentName;
  final int avatarIndex;
  final String tutorId;

  const CreateProfileScreen2({
    super.key,
    required this.studentName,
    required this.avatarIndex,
    required this.tutorId,
  });

  @override
  State<CreateProfileScreen2> createState() => _CreateProfileScreen2State();
}

class _CreateProfileScreen2State extends State<CreateProfileScreen2> {
  static const _blueAppBar = Color(0xFF5CA7FF);
  static const _tileBg = Color(0xFFD9D9D9);

  final List<int> _password = [];

  final List<_Animal> _animals = const [
    _Animal('🦁', Color(0xFFFFF3CD)), // 0
    _Animal('🧸', Color(0xFFF5E6FF)), // 1
    _Animal('🐯', Color(0xFFFFE0B2)), // 2
    _Animal('🦓', Color(0xFFE0E0E0)), // 3
    _Animal('🐊', Color(0xFFD4EDDA)), // 4
    _Animal('🐸', Color(0xFFDFF5FF)), // 5
    _Animal('🦥', Color(0xFFFCE4EC)), // 6
    _Animal('🦒', Color(0xFFE8F5E9)), // 7
  ];

  void _addAnimal(int index) {
    if (_password.length >= 4) return;
    setState(() => _password.add(index));
  }

  void _backspace() {
    if (_password.isEmpty) return;
    setState(() => _password.removeLast());
  }

  /// Convierte [0,1,2,3] → "0123"
  String _passwordToNumbers() {
    return _password.join('');
  }

  @override
  Widget build(BuildContext context) {
    const double gridSpacing = 6;
    const double slotSize = 60;
    const double slotGap = 8;

    Widget header() {
      return Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar${widget.avatarIndex}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.studentName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ],
      );
    }

    Widget passwordSlots() {
      return Row(
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
                style: const TextStyle(fontSize: 28),
              )
                  : null,
            ),
            if (i < 3) const SizedBox(width: slotGap),
          ],
          const SizedBox(width: 8),
          InkWell(
            onTap: _backspace,
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
      );
    }

    Widget animalsGrid() {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _tileBg,
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
              return InkWell(
                onTap: _password.length < 4
                    ? () => _addAnimal(index)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: _animals[index].bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _animals[index].emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _blueAppBar,
        centerTitle: true,
        title: const Text(
          'Crear perfil de alumno',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            header(),
            const SizedBox(height: 20),
            const Text(
              'Contraseña seleccionada',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            passwordSlots(),
            const SizedBox(height: 20),
            const Text(
              'Selecciona de 1 a 4 emojis en orden',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            animalsGrid(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _password.isNotEmpty
                      ? () async {
                    final password = _passwordToNumbers();

                    try {
                      final student = UserModel(
                        id: '',
                        name: widget.studentName,
                        role: 'student',
                        avatarIndex: widget.avatarIndex,
                        tutorId: widget.tutorId,
                        preferences: UserPreferences(canCustomize: true),
                      );

                      final userId =
                      await UserService().createUser(student);
                      await UserService()
                          .updatePassword(userId, password);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alumno creado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Avisamos al TutorHomeScreen
                      Navigator.pop(context, true);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al crear alumno: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                      : null,
                  child: const Text(
                    'Crear usuario',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

class _Animal {
  final String emoji;
  final Color bg;
  const _Animal(this.emoji, this.bg);
}
