import 'package:flutter/material.dart';
import '../widgets/preference_provider.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos las preferencias del usuario
    final prefs = PreferenceProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ejemplo con Preferencias',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18.0,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Este texto usa las preferencias del usuario',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18.0,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
          ),
        ),
      ),
    );
  }
}