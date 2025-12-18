import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/app_service.dart';
import '../utils/color_constants.dart';
import '../widgets/color_picker_dialog.dart';

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
  late Color _touchColor;
  late Color _sortColor;
  late Color _shareColor;
  late Color _subtractColor;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prefs = _service.currentUser?.preferences ?? UserPreferences();
    _touchRounds = prefs.touchGameRounds.clamp(1, 12).toInt();
    _sortRounds = prefs.sortGameRounds.clamp(1, 12).toInt();
    _shareRounds = prefs.shareGameRounds.clamp(1, 12).toInt();
    _subtractRounds = prefs.subtractGameRounds.clamp(1, 12).toInt();
    _touchColor = _colorFromHex(prefs.touchGameColor, const Color(0xFF2196F3));
    _sortColor = _colorFromHex(prefs.sortGameColor, const Color(0xFF4CAF50));
    _shareColor = _colorFromHex(prefs.shareGameColor, const Color(0xFFFF9800));
    _subtractColor =
        _colorFromHex(prefs.subtractGameColor, const Color(0xFF9C27B0));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _service.currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.white;
    final titleFontSize = _service.fontSizeWithFallback();
    final titleFontFamily = _service.fontFamilyWithFallback();

    return WillPopScope(
      onWillPop: () async {
        await _savePreferences(showFeedback: false);
        return true;
      },
      child: Scaffold(
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
          onPressed: () async {
            await _handleExit();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Elige cuántas rondas debe completar cada juego y asigna un color personalizado para que aparezca en el selector.',
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
            color: _touchColor,
            onColorTap: () => _selectColor(
              'Toca el número que suena',
              _touchColor,
              (color) => _touchColor = color,
            ),
            onChanged: (value) => setState(() => _touchRounds = value),
          ),
          _RoundsCard(
            icon: Icons.format_list_numbered,
            title: 'Ordena la secuencia',
            description: 'Número de secuencias completas antes de terminar.',
            value: _sortRounds,
            color: _sortColor,
            onColorTap: () => _selectColor(
              'Ordena la secuencia',
              _sortColor,
              (color) => _sortColor = color,
            ),
            onChanged: (value) => setState(() => _sortRounds = value),
          ),
          _RoundsCard(
            icon: Icons.catching_pokemon,
            title: 'Reparte los números',
            description: 'Rondas correctas en el juego de reparto.',
            value: _shareRounds,
            color: _shareColor,
            onColorTap: () => _selectColor(
              'Reparte los números',
              _shareColor,
              (color) => _shareColor = color,
            ),
            onChanged: (value) => setState(() => _shareRounds = value),
          ),
          _RoundsCard(
            icon: Icons.balance,
            title: 'Deja el mismo número',
            description: 'Rondas ganadas en el juego de resta igualitaria.',
            value: _subtractRounds,
            color: _subtractColor,
            onColorTap: () => _selectColor(
              'Deja el mismo número',
              _subtractColor,
              (color) => _subtractColor = color,
            ),
            onChanged: (value) => setState(() => _subtractRounds = value),
          ),
        ],
      ),
    ),
    );
  }

  Future<void> _selectColor(
    String title,
    Color initialColor,
    ValueChanged<Color> onSelected,
  ) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: initialColor,
        colors: AppColors.availableColors,
        title: 'Color para $title',
      ),
    );
    if (newColor != null) {
      setState(() => onSelected(newColor));
    }
  }

  Color _colorFromHex(String? value, Color fallback) {
    if (value == null) return fallback;
    final parsed = int.tryParse(value);
    if (parsed == null) return fallback;
    return Color(parsed);
  }

  String _colorToHex(Color color) {
    final hex = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    return '0x$hex';
  }

  Future<void> _handleExit() async {
    await _savePreferences(showFeedback: false);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _savePreferences({bool showFeedback = true}) async {
    final currentUser = _service.currentUser;
    if (currentUser == null || _isSaving) return;

    setState(() => _isSaving = true);
    final updated = currentUser.preferences.copyWith(
      touchGameRounds: _touchRounds,
      sortGameRounds: _sortRounds,
      shareGameRounds: _shareRounds,
      subtractGameRounds: _subtractRounds,
      touchGameColor: _colorToHex(_touchColor),
      sortGameColor: _colorToHex(_sortColor),
      shareGameColor: _colorToHex(_shareColor),
      subtractGameColor: _colorToHex(_subtractColor),
    );

    final success =
        await _service.updatePreferences(currentUser.id, updated);

    if (success) {
      _service.updateCurrentUserPreferences(updated);
      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferencias de juegos guardadas'),
          ),
        );
      }
    } else if (showFeedback && mounted) {
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
    required this.color,
    required this.onColorTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final int value;
  final ValueChanged<int> onChanged;
  final Color color;
  final VoidCallback onColorTap;

  static const int _minRounds = 1;
  static const int _maxRounds = 12;

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
            const SizedBox(height: 20),
            Text(
              'Color del botón en el selector',
              style: TextStyle(
                fontSize: fontSize * 0.7,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: onColorTap,
                  icon: const Icon(Icons.palette),
                  label: const Text('Cambiar color'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
