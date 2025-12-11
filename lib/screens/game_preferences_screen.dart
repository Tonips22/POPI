import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/app_service.dart';

class GamePreferencesScreen extends StatefulWidget {
  const GamePreferencesScreen({super.key});

  @override
  State<GamePreferencesScreen> createState() => _GamePreferencesScreenState();
}

class _GamePreferencesScreenState extends State<GamePreferencesScreen> {
  final AppService _service = AppService();

  late int _touchRounds;
  late int _sortRounds;
  late int _shareRounds;
  late int _subtractRounds;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prefs = _service.currentUser?.preferences ?? UserPreferences();
    _touchRounds = prefs.touchGameRounds;
    _sortRounds = prefs.sortGameRounds;
    _shareRounds = prefs.shareGameRounds;
    _subtractRounds = prefs.subtractGameRounds;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _service.currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.white;
    final titleFontSize = _service.fontSizeWithFallback();
    final titleFontFamily = _service.fontFamilyWithFallback();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Rondas por juego',
          style: TextStyle(
            fontSize: titleFontSize,
            fontFamily: titleFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Elige cuántas rondas debe completar cada juego antes de mostrar la pantalla de victoria.',
            style: TextStyle(
              fontSize: titleFontSize * 0.75,
              fontFamily: titleFontFamily,
            ),
          ),
          const SizedBox(height: 24),
          _RoundsCard(
            icon: Icons.touch_app,
            title: 'Toca el número que suena',
            description: 'Veces que se debe acertar el número que habla la app.',
            value: _touchRounds,
            onChanged: (value) => setState(() => _touchRounds = value),
          ),
          _RoundsCard(
            icon: Icons.format_list_numbered,
            title: 'Ordena la secuencia',
            description: 'Número de secuencias completas antes de terminar.',
            value: _sortRounds,
            onChanged: (value) => setState(() => _sortRounds = value),
          ),
          _RoundsCard(
            icon: Icons.catching_pokemon,
            title: 'Reparte los números',
            description: 'Rondas correctas en el juego de reparto.',
            value: _shareRounds,
            onChanged: (value) => setState(() => _shareRounds = value),
          ),
          _RoundsCard(
            icon: Icons.balance,
            title: 'Deja el mismo número',
            description: 'Rondas ganadas en el juego de resta igualitaria.',
            value: _subtractRounds,
            onChanged: (value) => setState(() => _subtractRounds = value),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: _isSaving ? null : _savePreferences,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(
              _isSaving ? 'Guardando...' : 'Guardar',
              style: TextStyle(
                fontSize: titleFontSize * 0.8,
                fontFamily: titleFontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePreferences() async {
    final currentUser = _service.currentUser;
    if (currentUser == null) return;

    setState(() => _isSaving = true);
    final updated = currentUser.preferences.copyWith(
      touchGameRounds: _touchRounds,
      sortGameRounds: _sortRounds,
      shareGameRounds: _shareRounds,
      subtractGameRounds: _subtractRounds,
    );

    final success =
        await _service.updatePreferences(currentUser.id, updated);

    if (success) {
      _service.updateCurrentUserPreferences(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferencias de juegos guardadas'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudieron guardar las preferencias'),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }
}

class _RoundsCard extends StatelessWidget {
  const _RoundsCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final int value;
  final ValueChanged<int> onChanged;

  static const int _minRounds = 1;
  static const int _maxRounds = 10;

  @override
  Widget build(BuildContext context) {
    final appService = AppService();
    final fontSize = appService.fontSizeWithFallback();
    final fontFamily = appService.fontFamilyWithFallback();

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade100,
                  child: Icon(icon, color: Colors.blueGrey.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$value rondas',
                  style: TextStyle(
                    fontSize: fontSize * 0.75,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: fontSize * 0.7,
                fontFamily: fontFamily,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: value > _minRounds
                      ? () => onChanged(value - 1)
                      : null,
                ),
                Expanded(
                  child: Slider(
                    value: value.toDouble(),
                    min: _minRounds.toDouble(),
                    max: _maxRounds.toDouble(),
                    divisions: _maxRounds - _minRounds,
                    label: '$value',
                    onChanged: (double newValue) =>
                        onChanged(newValue.round()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: value < _maxRounds
                      ? () => onChanged(value + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
