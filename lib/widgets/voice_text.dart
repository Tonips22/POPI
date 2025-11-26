// lib/widgets/voice_text.dart
import 'package:flutter/material.dart';
import '../logic/voice_controller.dart';

class VoiceText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const VoiceText(
      this.text, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    final controller = VoiceController();

    final baseText = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    // Si la lectura está desactivada o en modo 'none', se comporta como Text normal
    if (!controller.isEnabled || controller.activationMode == 'none') {
      return baseText;
    }

    // Si está activado, envolvemos en GestureDetector según el modo:
    // - 'double'  -> tap (y doble tap por si acaso, más fiable en desktop)
    // - 'long'    -> mantener pulsado
    return GestureDetector(
      onTap: controller.activationMode == 'double'
          ? () => controller.speak(text)
          : null,
      onDoubleTap: controller.activationMode == 'double'
          ? () => controller.speak(text)
          : null,
      onLongPress: controller.activationMode == 'long'
          ? () => controller.speak(text)
          : null,
      child: baseText,
    );
  }
}