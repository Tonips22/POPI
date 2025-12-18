import 'package:flutter/material.dart';

import '../services/app_service.dart';
import '../utils/accessible_routes.dart';
import 'equal_share_screen.dart';

class TutorialJuego3Screen extends StatefulWidget {
  const TutorialJuego3Screen({super.key});

  @override
  State<TutorialJuego3Screen> createState() => _TutorialJuego3ScreenState();
}

class _TutorialJuego3ScreenState extends State<TutorialJuego3Screen> {
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
        showTutorialJuego3: false,
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
        page: const EqualShareScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial - Reparte los números'),
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
                'Aprende a repartir',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/tutorial_juego3.gif',
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Añade el GIF del tutorial en assets/images/tutorial_juego3.gif',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
