import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../logic/voice_controller.dart';
import '../widgets/voice_text.dart';
import '../services/app_service.dart';

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
    // Cargamos el estado desde las preferencias del usuario si existe
    final currentUser = AppService().currentUser;
    if (currentUser != null && currentUser.preferences.voiceText != null) {
      activationMode = currentUser.preferences.voiceText!;
      // Sincronizamos el controlador
      controller.initFromPreferences(currentUser.preferences);
    } else {
      activationMode = controller.isEnabled ? controller.activationMode : 'none';
    }
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

    // Guardar en preferencias del usuario
    final currentUser = AppService().currentUser;
    if (currentUser != null) {
      // Actualizar en Firestore
      AppService().updatePreferences(
        currentUser.id, 
        currentUser.preferences.copyWith(voiceText: mode == 'none' ? null : mode)
      );
      
      // Actualizar en memoria local
      AppService().updateCurrentUserPreferences(
        currentUser.preferences.copyWith(voiceText: mode == 'none' ? null : mode)
      );
    }

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
              child: Text(
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
    final currentUser = AppService()?.currentUser;
    final titleFontSize = currentUser?.preferences.getFontSizeValue() ?? 20.0;
    final titleFontFamily = currentUser?.preferences.getFontFamilyName() ?? 'Roboto';
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Texto de voz",
          style: TextStyle(
            fontSize: titleFontSize * 1.3,
            fontWeight: FontWeight.bold,
            fontFamily: titleFontFamily,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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