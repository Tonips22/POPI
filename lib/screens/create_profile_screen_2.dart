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
  bool _createWithoutPassword = false;

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

  bool get _canSubmit => _createWithoutPassword || _password.isNotEmpty;

  /// Convierte [0,1,2,3] → "0123"
  String _passwordToNumbers() {
    return _password.join('');
  }
  
  void _toggleCreateWithoutPassword(bool value) {
    setState(() {
      _createWithoutPassword = value;
      if (value) {
        _password.clear();
      }
    });
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
                'assets/images/avatar${widget.avatarIndex}.jpg',
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
      final row = Row(
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
      return Opacity(
        opacity: _createWithoutPassword ? 0.4 : 1,
        child: row,
      );
    }

    Widget animalsGrid() {
      final grid = Center(
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
                onTap: (!_createWithoutPassword && _password.length < 4)
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
      return IgnorePointer(
        ignoring: _createWithoutPassword,
        child: Opacity(
          opacity: _createWithoutPassword ? 0.35 : 1,
          child: grid,
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
              'Selecciona de 1 a 4 emojis en orden (opcional).',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'También puedes crear el alumno sin contraseña y configurarla más tarde desde Tutor o Admin.',
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            animalsGrid(),
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Crear sin contraseña',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'La contraseña se podrá asignar después desde los ajustes del tutor o administrador.',
              ),
              value: _createWithoutPassword,
              onChanged: _toggleCreateWithoutPassword,
            ),
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
                  onPressed: _canSubmit
                      ? () async {
                          final String? password =
                              _createWithoutPassword ? null : _passwordToNumbers();

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

                            if (password != null && password.isNotEmpty) {
                              await UserService()
                                  .updatePassword(userId, password);
                            }

                            if (!context.mounted) return;

                            final message = password == null
                                ? 'Alumno creado sin contraseña. Puedes configurarla más tarde.'
                                : 'Alumno creado correctamente';

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
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
