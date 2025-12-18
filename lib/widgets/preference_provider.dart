// lib/widgets/preference_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

/// Widget que provee las preferencias del usuario a toda la app
/// Usa InheritedWidget para que cualquier pantalla pueda acceder a ellas
class PreferenceProvider extends InheritedWidget {
  final UserModel preferences;

  const PreferenceProvider({
    Key? key,
    required this.preferences,
    required Widget child,
  }) : super(key: key, child: child);

  /// Método estático para acceder a las preferencias desde cualquier parte
  static UserModel? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PreferenceProvider>()
        ?.preferences;
  }

  /// Método estático para recargar las preferencias
  static Future<void> reload(BuildContext context) async {
    final state = context.findAncestorStateOfType<_PreferenceLoaderState>();
    if (state != null) {
      await state.reloadPreferences();
    }
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
  final UserService _userService = UserService();
  UserModel? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    // Primero aseguramos que el usuario exista
    await _userService.ensureUserExists(widget.userId, name: 'Alumno Demo');
    
    // Luego cargamos sus preferencias
    UserModel? prefs = await _userService.getUserProfile(widget.userId);
    setState(() {
      _preferences = prefs ??
          UserModel(
            id: widget.userId,
            name: 'Alumno Demo',
            role: 'student',
            avatarIndex: 0,
            preferences: UserPreferences(),
            isActive: true,
          );
      _isLoading = false;
    });
  }

  /// Método público para recargar las preferencias
  Future<void> reloadPreferences() async {
    await _loadPreferences();
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
