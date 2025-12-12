import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'tutor_login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cards = [
            _AccessCard(
              title: 'Estudiantes',
              subtitle: 'Accede a tus perfiles y juegos',
              icon: Icons.school_rounded,
              colors: const [Color(0xFF1F8CF1), Color(0xFF1271D1)],
              onTap: () => _openLogin(context),
            ),
            _AccessCard(
              title: 'Tutores / Admin',
              subtitle: 'Gestión y resultados',
              icon: Icons.admin_panel_settings_rounded,
              colors: [Color(0xFF9498A5), Color(0xFF6B6E78)],
              onTap: () => _openLoginTutorAdmin(context),
            ),
          ];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'POPI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Color(0xFF1C1D22),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Selecciona el tipo de acceso',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 36),
                      cards[0],
                      const SizedBox(height: 32),
                      cards[1],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _openLoginTutorAdmin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TutorLoginScreen()),
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    this.onTap,
    this.disabled = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      elevation: 8,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.white24,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: disabled ? 0.6 : 1,
          child: Container(
            height: 260,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: _applyOpacity(colors.last, 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: _applyOpacity(Colors.white, 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _applyOpacity(Colors.white, 0.24),
                      width: 2,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 38),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _applyOpacity(Colors.white, 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _applyOpacity(Color color, double opacity) {
  final double clamped = opacity.clamp(0, 1);
  return color.withAlpha((clamped * 255).round());
}
