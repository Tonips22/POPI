import 'package:flutter/material.dart';

import '../services/app_service.dart';
import '../utils/accessible_routes.dart';
import 'sort_numbers_game.dart';

class TutorialJuego2Screen extends StatefulWidget {
  const TutorialJuego2Screen({super.key});

  @override
  State<TutorialJuego2Screen> createState() => _TutorialJuego2ScreenState();
}

class _TutorialJuego2ScreenState extends State<TutorialJuego2Screen> {
  final AppService _appService = AppService();
  bool _dontShowAgain = false;
  bool _isSavingPreference = false;

  Future<void> _handleContinue() async {
    final user = _appService.currentUser;

    if (_dontShowAgain && user != null) {
      setState(() {
        _isSavingPreference = true;
      });

      final updatedPreferences = user.preferences.copyWith(
        showTutorialJuego2: false,
      );

      await _appService.updatePreferences(user.id, updatedPreferences);
      _appService.updateCurrentUserPreferences(updatedPreferences);
      if (!mounted) return;
      setState(() {
        _isSavingPreference = false;
      });
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      buildAccessibleFadeRoute(
        context: context,
        page: const SortNumbersGame(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial - Ordena los números'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aprende cómo ordenar',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Arrastra los números para colocarlos en orden correcto. '
                'Si te equivocas, siempre puedes volver a intentarlo.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Consejos:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16),
                      _TutorialTip(text: 'Empieza por el número más pequeño.'),
                      _TutorialTip(
                        text: 'Coloca cada ficha en su lugar para formar la secuencia.',
                      ),
                      _TutorialTip(
                        text: 'Si un número no encaja, vuelve a dejarlo en la fila principal.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
                value: _dontShowAgain,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _dontShowAgain = value);
                },
                title: const Text('No volver a mostrar este tutorial'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSavingPreference ? null : _handleContinue,
                  icon: _isSavingPreference
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.arrow_forward),
                  label: Text(
                    _isSavingPreference ? 'Guardando...' : 'Empezar a jugar',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialTip extends StatelessWidget {
  const _TutorialTip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2596BE)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
