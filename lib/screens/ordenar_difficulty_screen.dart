import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../logic/game_controller_ordenar.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';

class OrdenarDifficultyScreen extends StatefulWidget {
  final String? userId;

  const OrdenarDifficultyScreen({
    super.key,
    this.userId,
  });

  @override
  State<OrdenarDifficultyScreen> createState() =>
      _OrdenarDifficultyScreenState();
}

class _OrdenarDifficultyScreenState extends State<OrdenarDifficultyScreen> {
  final OrdenarGameController _controller = OrdenarGameController();
  final AppService _service = AppService();

  UserModel? _loadedUser;

  late double _sliderValue;
  int _selectedRangeIndex = 0;
  bool _isSaving = false;

  final List<Map<String, int>> _ranges = [
    {'min': 0, 'max': 10},
    {'min': 0, 'max': 20},
    {'min': 0, 'max': 100},
    {'min': 0, 'max': 1000},
  ];

  Map<String, int> get _currentRange => _ranges[_selectedRangeIndex];

  double get _currentMaxDifficulty =>
      (_currentRange['max'] == 10) ? 10 : 12;

  @override
  void initState() {
    super.initState();
    _sliderValue = _controller.difficulty.toDouble();
    _loadUserAndPreferences();
  }

  // =====================================================
  // CARGA DE USUARIO Y PREFERENCIAS
  // =====================================================
  Future<void> _loadUserAndPreferences() async {
    // 👉 Si se pasa userId, cargamos ese usuario
    if (widget.userId != null) {
      _loadedUser = await _service.getUserById(widget.userId!);
    }
    // 👉 Si no, usamos el usuario en sesión
    else {
      _loadedUser = _service.currentUser;
    }

    if (_loadedUser == null) return;

    final prefs = _loadedUser!.preferences;

    _sliderValue = prefs.sortGameDifficulty.toDouble();

    final index = _ranges.indexWhere(
          (range) =>
      range['min'] == prefs.sortGameRangeMin &&
          range['max'] == prefs.sortGameRangeMax,
    );

    if (index != -1) {
      _selectedRangeIndex = index;
    }

    _sliderValue =
        _sliderValue.clamp(1, _currentMaxDifficulty).toDouble();

    _applyValuesToController();

    if (mounted) {
      setState(() {});
    }
  }

  // =====================================================
  // APLICAR VALORES AL CONTROLLER
  // =====================================================
  void _applyValuesToController() {
    final range = _currentRange;
    _controller.setRange(range['min']!, range['max']!);
    _controller.setDifficulty(_sliderValue.round());
  }

  // =====================================================
  // GUARDADO DE PREFERENCIAS
  // =====================================================
  Future<void> _saveSettings() async {
    if (_loadedUser == null || _isSaving) return;

    if (mounted) {
      setState(() => _isSaving = true);
    }

    final range = _currentRange;

    final updatedPreferences = _loadedUser!.preferences.copyWith(
      sortGameDifficulty: _sliderValue.round(),
      sortGameRangeMin: range['min'],
      sortGameRangeMax: range['max'],
    );

    final success = await _service.updatePreferences(
      _loadedUser!.id,
      updatedPreferences,
    );

    // ⚠️ SOLO actualizar currentUser si NO estamos editando a otro usuario
    if (success && widget.userId == null) {
      _service.updateCurrentUserPreferences(updatedPreferences);
    }

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    final appService = AppService();
    final currentUser = appService.currentUser;

    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;

    final primaryColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.primaryColor))
        : Colors.blue;

    final titleFontSize = appService.fontSizeWithFallback();
    final titleFontFamily = appService.fontFamilyWithFallback();

    final double maxValue = _currentMaxDifficulty;

    return WillPopScope(
      onWillPop: () async {
        await _saveSettings();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,

        // === APP BAR ===
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 32),
            onPressed: () async {
              await _saveSettings();
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Dificultad',
            style: TextStyle(
              fontSize: titleFontSize * 1.35,
              fontWeight: FontWeight.bold,
              fontFamily: titleFontFamily,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        // === CONTENIDO ===
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ordena la secuencia',
                style: TextStyle(
                  fontSize: titleFontSize * 1.2,
                  fontWeight: FontWeight.w600,
                  fontFamily: titleFontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona la cantidad de números',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: titleFontFamily,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),

              // === SLIDER DE DIFICULTAD ===
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: primaryColor,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: primaryColor,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 28,
                          ),
                          trackHeight: 8,
                        ),
                        child: Slider(
                          value: _sliderValue.clamp(1, maxValue),
                          min: 1,
                          max: maxValue,
                          divisions: (maxValue - 1).toInt(),
                          label: _sliderValue.round().toString(),
                          onChanged: (v) {
                            setState(() {
                              _sliderValue = v;
                              _controller.setDifficulty(v.toInt());
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          maxValue.toInt(),
                              (i) => Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // === RANGO DE NÚMEROS ===
              const Text(
                'Rango de números',
                style: TextStyle(
                  fontSize: 19.8,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: List.generate(_ranges.length, (index) {
                  final selected = index == _selectedRangeIndex;
                  final label =
                      '${_ranges[index]['min']}-${_ranges[index]['max']}';

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRangeIndex = index;
                        _sliderValue = _sliderValue
                            .clamp(1, _currentMaxDifficulty)
                            .toDouble();
                        _applyValuesToController();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          selected ? primaryColor : Colors.grey.shade300,
                          width: selected ? 3 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
