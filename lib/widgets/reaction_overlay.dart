import 'package:flutter/material.dart';

/// Overlay para mostrar animaciones de refuerzo positivo.
/// Soporta varios estilos (confeti, estrellas, burbujas) y se activa cuando
/// [enabled] pasa de false a true.
class ReactionOverlay extends StatelessWidget {
  const ReactionOverlay({
    super.key,
    required this.enabled,
    this.duration = const Duration(milliseconds: 1200),
    this.type,
  });

  final bool enabled;
  final Duration duration;
  final String? type;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    final String animationType = type ?? 'confetti';

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _buildReaction(animationType),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buildReaction(animationType, mirrored: true),
        ),
      ],
    );
  }

  Widget _buildReaction(String animationType, {bool mirrored = false}) {
    switch (animationType) {
      case 'stars':
        return _StarBurstReaction(
          enabled: enabled,
          duration: duration,
          mirrored: mirrored,
        );
      case 'bubbles':
        return _BubblesReaction(
          enabled: enabled,
          duration: duration,
          mirrored: mirrored,
        );
      default:
        return _ConfettiReaction(
          enabled: enabled,
          duration: duration,
          mirrored: mirrored,
        );
    }
  }
}

class _ConfettiReaction extends StatefulWidget {
  const _ConfettiReaction({
    required this.enabled,
    required this.duration,
    this.mirrored = false,
  });

  final bool enabled;
  final Duration duration;
  final bool mirrored;

  @override
  State<_ConfettiReaction> createState() => _ConfettiReactionState();
}

class _ConfettiReactionState extends State<_ConfettiReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiPiece> _pieces = const [
    _ConfettiPiece(
      targetOffset: Offset(150, -30),
      size: Size(14, 32),
      rotation: -0.2,
      color: Color(0xFFFFB74D),
    ),
    _ConfettiPiece(
      targetOffset: Offset(110, 50),
      size: Size(18, 24),
      rotation: 0.7,
      color: Color(0xFFEF5350),
    ),
    _ConfettiPiece(
      targetOffset: Offset(170, 20),
      size: Size(16, 30),
      rotation: -0.5,
      color: Color(0xFFFFEB3B),
    ),
    _ConfettiPiece(
      targetOffset: Offset(130, -70),
      size: Size(12, 26),
      rotation: 0.3,
      color: Color(0xFF4FC3F7),
    ),
    _ConfettiPiece(
      targetOffset: Offset(190, 60),
      size: Size(14, 34),
      rotation: -0.9,
      color: Color(0xFFAB47BC),
    ),
    _ConfettiPiece(
      targetOffset: Offset(120, 90),
      size: Size(18, 20),
      rotation: 0.4,
      color: Color(0xFF66BB6A),
    ),
    _ConfettiPiece(
      targetOffset: Offset(160, -50),
      size: Size(12, 22),
      rotation: -0.1,
      color: Color(0xFFFF8A80),
    ),
    _ConfettiPiece(
      targetOffset: Offset(180, -10),
      size: Size(16, 28),
      rotation: 1.0,
      color: Color(0xFF29B6F6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _ConfettiReaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.forward(from: 0);
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.reset();
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
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return IgnorePointer(
      ignoring: true,
      child: SizedBox(
        width: 220,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final value = animation.value;
            return Opacity(
              opacity: 1 - value * 0.5,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: _pieces.map((piece) {
                  final horizontalDirection = widget.mirrored ? -1 : 1;
                  final double dx =
                      horizontalDirection * (piece.targetOffset.dx * value);
                  final double dy =
                      piece.targetOffset.dy * value + value * 25;
                  final double rotation =
                      piece.rotation + (horizontalDirection * value * 1.2);
                  final double scale = 0.8 + value * 0.4;
                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: Transform.rotate(
                      angle: rotation,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: piece.size.width,
                          height: piece.size.height,
                          decoration: BoxDecoration(
                            color: piece.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StarBurstReaction extends StatefulWidget {
  const _StarBurstReaction({
    required this.enabled,
    required this.duration,
    this.mirrored = false,
  });

  final bool enabled;
  final Duration duration;
  final bool mirrored;

  @override
  State<_StarBurstReaction> createState() => _StarBurstReactionState();
}

class _StarBurstReactionState extends State<_StarBurstReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ParticleConfig> _particles = const [
    _ParticleConfig(offset: Offset(-70, -20), color: Color(0xFFFFD54F)),
    _ParticleConfig(offset: Offset(60, -15), color: Color(0xFFFFB300)),
    _ParticleConfig(offset: Offset(-40, 50), color: Color(0xFFFF8A65)),
    _ParticleConfig(offset: Offset(30, -70), color: Color(0xFFFFB6C1)),
    _ParticleConfig(offset: Offset(80, 30), color: Color(0xFF80DEEA)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _StarBurstReaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.forward(from: 0);
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.reset();
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
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final value = animation.value;
          return Opacity(
            opacity: 1 - value * 0.6,
            child: Stack(
              alignment: Alignment.center,
              children: _particles.map((particle) {
                Offset offset = particle.offset * value;
                if (widget.mirrored) {
                  offset = Offset(-offset.dx, offset.dy);
                }
                final double scale = 0.5 + (value * 0.8);
                return Transform.translate(
                  offset: offset,
                  child: Transform.scale(
                    scale: scale,
                    child: Icon(
                      Icons.star,
                      color: particle.color,
                      size: 32,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _BubblesReaction extends StatefulWidget {
  const _BubblesReaction({
    required this.enabled,
    required this.duration,
    this.mirrored = false,
  });

  final bool enabled;
  final Duration duration;
  final bool mirrored;

  @override
  State<_BubblesReaction> createState() => _BubblesReactionState();
}

class _BubblesReactionState extends State<_BubblesReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ParticleConfig> _bubbles = const [
    _ParticleConfig(offset: Offset(-40, 80), color: Color(0xFF81D4FA)),
    _ParticleConfig(offset: Offset(0, 90), color: Color(0xFF4DD0E1)),
    _ParticleConfig(offset: Offset(50, 100), color: Color(0xFFB39DDB)),
    _ParticleConfig(offset: Offset(-10, 110), color: Color(0xFF80CBC4)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant _BubblesReaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.forward(from: 0);
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.reset();
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
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final value = animation.value;
          return Opacity(
            opacity: 1 - value * 0.7,
            child: Stack(
              alignment: Alignment.center,
              children: _bubbles.map((bubble) {
                double dy = bubble.offset.dy * (1 - value) - 60 * value;
                double dx = bubble.offset.dx * (1 - value * 0.5);
                if (widget.mirrored) {
                  dx = -dx;
                }
                final double scale = 0.5 + value * 0.8;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bubble.color.withValues(alpha: 0.7),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final Offset targetOffset;
  final Size size;
  final double rotation;
  final Color color;

  const _ConfettiPiece({
    required this.targetOffset,
    required this.size,
    required this.rotation,
    required this.color,
  });
}

class _ParticleConfig {
  final Offset offset;
  final Color color;
  const _ParticleConfig({
    required this.offset,
    required this.color,
  });
}
