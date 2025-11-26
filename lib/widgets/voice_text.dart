import 'package:flutter/material.dart';
import '../logic/voice_controller.dart';

class VoiceText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const VoiceText(this.text, {super.key, this.style});

  @override
  State<VoiceText> createState() => _VoiceTextState();
}

class _VoiceTextState extends State<VoiceText> {
  final controller = VoiceController();
  int tapCount = 0;

  void _handleTap() {
    if (!controller.isEnabled) return;

    if (controller.activationMode == 'double') {
      tapCount++;
      if (tapCount == 2) {
        controller.speak(widget.text);
        tapCount = 0;
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        tapCount = 0;
      });
    }
  }

  void _handleLongPress() {
    if (!controller.isEnabled) return;

    if (controller.activationMode == 'long') {
      controller.speak(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: Text(widget.text, style: widget.style),
    );
  }
}