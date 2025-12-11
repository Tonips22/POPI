import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ReactionOverlay extends StatefulWidget {
  const ReactionOverlay({
    super.key,
    required this.enabled,
    this.duration = const Duration(milliseconds: 1000),
  });

  final bool enabled;
  final Duration duration;

  @override
  State<ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<ReactionOverlay> {
  late final ConfettiController _controller;
  bool _shouldPlay = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    _shouldPlay = widget.enabled;
    if (_shouldPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.play());
    }
  }

  @override
  void didUpdateWidget(covariant ReactionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: 0,
        numberOfParticles: 25,
        maxBlastForce: 35,
        minBlastForce: 15,
        gravity: 0.7,
        shouldLoop: false,
      ),
    );
  }
}
