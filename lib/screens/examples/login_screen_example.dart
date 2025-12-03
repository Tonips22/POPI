import 'package:flutter/material.dart';
import '/services/app_service.dart';
import '/models/user_model.dart';

class LoginScreenExample extends StatefulWidget {
  const LoginScreenExample({Key? key}) : super(key: key);

  @override
  State<LoginScreenExample> createState() => _LoginScreenExampleState();
}

class _LoginScreenExampleState extends State<LoginScreenExample> {
  final AppService _service = AppService();

  List<UserModel> _students = [];
  bool _isLoading = true;
  String?  _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  /// Carga los alumnos desde Firestore
  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<UserModel> students = await _service.getStudents();

      setState(() {
        _students = students;
        _isLoading = false;

        if (students.isEmpty) {
          _errorMessage = 'No hay alumnos registrados';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  /// Cuando se selecciona un alumno
  void _onStudentSelected(UserModel student) {
    // Por ahora, loguear directamente (después añadirás la pantalla de contraseña)
    _service.login(student);

    // Navegar a la siguiente pantalla
    Navigator.pushReplacementNamed(context, '/games');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Título
              const Text(
                '👋 ¡Hola!  ¿Quién eres?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Contenido
              Expanded(
                child: _buildContent(),
              ),

              // Botón reintentar
              if (_errorMessage != null)
                ElevatedButton. icon(
                  onPressed: _loadStudents,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Cargando...
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando alumnos... ', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    // Error
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors. red),
            ),
          ],
        ),
      );
    }

    // Grid de alumnos
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 columnas para tablets
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return _StudentCard(
          student: student,
          onTap: () => _onStudentSelected(student),
        );
      },
    );
  }
}

/// Tarjeta de alumno
class _StudentCard extends StatelessWidget {
  final UserModel student;
  final VoidCallback onTap;

  const _StudentCard({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                student.name[0]. toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Nombre
            Text(
              student.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}