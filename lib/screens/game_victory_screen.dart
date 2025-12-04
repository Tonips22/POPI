import 'package:flutter/material.dart';
// import '../widgets/preference_provider.dart';
import '../services/app_service.dart';

/// Pantalla de victoria que se muestra al completar un juego
class GameVictoryScreen extends StatelessWidget {
  final VoidCallback? onRestart;
  final VoidCallback? onHome;

  const GameVictoryScreen({
    super.key,
    this.onRestart,
    this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final userColor = AppService().currentUser != null
        ? Color(int.parse(AppService().currentUser!.preferences.primaryColor))
        : Colors.blue.shade400;
    
    return Scaffold(
      backgroundColor: userColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mensaje de victoria
            Text(
              '¡Has ganado!',
              style: const TextStyle(
                fontSize: 18.0 * 2.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 80),
            
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón de reiniciar
                _VictoryButton(
                  icon: Icons.refresh,
                  label: 'Reiniciar',
                  onPressed: () {
                    if (onRestart != null) {
                      onRestart!();
                    }
                  },
                ),
                
                const SizedBox(width: 40),
                
                // Botón de inicio/casa
                _VictoryButton(
                  icon: Icons.home,
                  label: 'Inicio',
                  onPressed: () {
                    if (onHome != null) {
                      onHome!();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget personalizado para los botones de la pantalla de victoria
class _VictoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _VictoryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón circular con icono
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 8,
            child: Builder(
              builder: (context) {
                final userColor = AppService().currentUser != null
                    ? Color(int.parse(AppService().currentUser!.preferences.primaryColor))
                    : Colors.blue.shade400;
                return InkWell(
                  onTap: () {
                    print('Button tapped: $label'); // Debug
                    onPressed();
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Icon(
                      icon,
                      size: 60,
                      color: userColor,
                    ),
                  ),
                );
              },
            ),
        ),
        
        const SizedBox(height: 16),
        
        // Etiqueta del botón
        Builder(
          builder: (context) {
            // final prefs = PreferenceProvider.of(context);
            return Text(
              label,
              style: TextStyle(
                fontSize: 18.0 * 1.1,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}
