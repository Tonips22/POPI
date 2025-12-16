import 'package:flutter/material.dart' hide Text;
import '../models/user_model.dart';
import '../services/app_service.dart';
import '../logic/voice_controller.dart';
import '../widgets/voice_text.dart';

class TutorEditProfileScreen4 extends StatefulWidget {
  final UserModel student;

  const TutorEditProfileScreen4({super.key, required this.student});

  @override
  State<TutorEditProfileScreen4> createState() =>
      _TutorEditProfileScreen4State();
}

class _TutorEditProfileScreen4State extends State<TutorEditProfileScreen4> {
  final AppService _appService = AppService();
  final VoiceController controller = VoiceController();

  late String activationMode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    activationMode =
        widget.student.preferences.voiceText ?? 'none';
  }

  Future<void> _saveAndFinish() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final updatedStudent = widget.student.copyWith(
      preferences: widget.student.preferences.copyWith(
        voiceText: activationMode == 'none' ? null : activationMode,
      ),
    );

    await _appService.saveUser(updatedStudent);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context, true);
    }
  }

  void _setMode(String mode) {
    setState(() => activationMode = mode);

    controller.setEnabled(mode != 'none');
    controller.setActivationMode(mode);

    switch (mode) {
      case 'none':
        controller.speak("Lectura por voz desactivada");
        break;
      case 'double':
        controller.speak("Modo doble toque activado");
        break;
      case 'long':
        controller.speak("Modo mantener pulsado activado");
        break;
    }
  }

  Widget _option(String text, String value) {
    final selected = activationMode == value;

    return GestureDetector(
      onTap: () => _setMode(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,
              width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text)),
            Icon(selected
                ? Icons.check_circle
                : Icons.radio_button_unchecked),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texto por voz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opciones:',
              style:
              TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _option('Ninguno', 'none'),
            _option('Doble toque', 'double'),
            _option('Mantener pulsado', 'long'),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveAndFinish,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Guardar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
