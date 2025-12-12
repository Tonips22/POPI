import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';
import '../screens/home_tutor_screen.dart';
import '../screens/admin_screen.dart';

class TutorLoginScreen extends StatefulWidget {
  const TutorLoginScreen({super.key});

  @override
  State<TutorLoginScreen> createState() => _TutorLoginScreenState();
}

class _TutorLoginScreenState extends State<TutorLoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AppService _service = AppService();

  bool _isLoading = false;
  String? _errorMessage;

  void _onCancel() => Navigator.pop(context);

  Future<void> _onContinue() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor completa todos los campos.';
        _isLoading = false;
      });
      return;
    }

    try {
      final user = await _service.validateTutorCredentials(name, password);

      if (user != null) {
        _service.login(user);

        // ------- Redirección según rol -------
        if (user.role.toLowerCase() == 'tutor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorHomeScreen()),
          );
        } else if (user.role.toLowerCase() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminScreen()),
          );
        }

        return;
      } else {
        setState(() => _errorMessage = 'Credenciales incorrectas');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error inesperado');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double cardPadding = 28;
    final double fieldSpacing = 18;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 12,
            shadowColor: const Color(0xFF2596BE).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Inicio de sesión Tutor y Admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2596BE),
                    ),
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  SizedBox(height: fieldSpacing),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  SizedBox(height: fieldSpacing),

                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading ? null : _onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade500,
                          minimumSize: const Size(120, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2596BE),
                          minimumSize: const Size(140, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Continuar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
