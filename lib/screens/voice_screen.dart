import 'package:flutter/material.dart';
import '../logic/voice_controller.dart';
import '../widgets/voice_text.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final controller = VoiceController();
  late String activationMode;

  @override
  void initState() {
    super.initState();
    // Cargamos el estado global actual
    activationMode =
    controller.isEnabled ? controller.activationMode : 'none';
  }

  void _setActivationMode(String mode) {
    setState(() {
      activationMode = mode;
      controller.setEnabled(mode != 'none');
      if (mode != 'none') {
        controller.setActivationMode(mode);
      } else {
        controller.setActivationMode('none');
      }
    });

    // Mensaje de confirmación hablado
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

  Widget _buildOptionCard(String text, String value) {
    final bool selected = activationMode == value;
    return GestureDetector(
      onTap: () => _setActivationMode(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: VoiceText(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: VoiceText(
          "Texto de voz",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VoiceText(
              "Opciones:",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionCard("Ninguno", 'none'),
            _buildOptionCard("Doble toque", 'double'),
            _buildOptionCard("Mantener pulsado", 'long'),
          ],
        ),
      ),
    );
  }
}