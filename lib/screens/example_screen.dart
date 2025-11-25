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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Vista Previa de Preferencias',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18.0,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información actual de preferencias
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferencias actuales:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Fuente',
                      prefs?.fontFamily ?? 'default',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Tamaño',
                      prefs?.fontSize ?? 'medium',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Tamaño en px',
                      '${prefs?.getFontSizeValue() ?? 18.0}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Texto de ejemplo
            const Text(
              'Texto de ejemplo:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Este texto usa las preferencias del usuario. Puedes modificar el tamaño y tipo de fuente desde la configuración de Tipografía.',
                style: TextStyle(
                  fontSize: prefs?.getFontSizeValue() ?? 18.0,
                  fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Más ejemplos con diferentes tamaños
            Text(
              'Título Grande',
              style: TextStyle(
                fontSize: (prefs?.getFontSizeValue() ?? 18.0) * 1.5,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Texto mediano con la fuente seleccionada',
              style: TextStyle(
                fontSize: prefs?.getFontSizeValue() ?? 18.0,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Texto pequeño',
              style: TextStyle(
                fontSize: (prefs?.getFontSizeValue() ?? 18.0) * 0.8,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}