// lib/widgets/preference_provider.dart

import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../services/user_preferences_service.dart';

/// Widget que provee las preferencias del usuario a toda la app
/// Usa InheritedWidget para que cualquier pantalla pueda acceder a ellas
class PreferenceProvider extends InheritedWidget {
  final UserPreferences preferences;

  const PreferenceProvider({
    Key? key,
    required this.preferences,
    required Widget child,
  }) : super(key: key, child: child);

  /// Método estático para acceder a las preferencias desde cualquier parte
  static UserPreferences? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PreferenceProvider>()
        ?.preferences;
  }

  @override
  bool updateShouldNotify(PreferenceProvider oldWidget) {
    // Se notifica si las preferencias han cambiado
    return oldWidget.preferences != preferences;
  }
}

/// Widget Stateful que carga y gestiona las preferencias
class PreferenceLoader extends StatefulWidget {
  final String userId;
  final Widget child;

  const PreferenceLoader({
    Key? key,
    required this.userId,
    required this.child,
  }) : super(key: key);

  @override
  State<PreferenceLoader> createState() => _PreferenceLoaderState();
}

class _PreferenceLoaderState extends State<PreferenceLoader> {
  final UserPreferencesService _service = UserPreferencesService();
  UserPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    UserPreferences prefs = await _service.getPreferences(widget.userId);
    setState(() {
      _preferences = prefs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _preferences == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return PreferenceProvider(
      preferences: _preferences!,
      child: widget.child,
    );
  }
}