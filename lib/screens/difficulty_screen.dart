import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../logic/game_controller.dart';
import '../services/app_service.dart';
// import '../widgets/preference_provider.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  final GameController _controller = GameController();
  final AppService _service = AppService();
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
    _loadPreferences();
  }

  void _loadPreferences() {
    final prefs = _service.currentUser?.preferences;
    if (prefs != null) {
      _sliderValue = prefs.touchGameDifficulty.toDouble();
      final index = _ranges.indexWhere(
        (range) =>
            range['min'] == prefs.touchGameRangeMin &&
            range['max'] == prefs.touchGameRangeMax,
      );
      if (index != -1) {
        _selectedRangeIndex = index;
      }
    } else {
      for (int i = 0; i < _ranges.length; i++) {
        if (_ranges[i]['min'] == _controller.minRange &&
            _ranges[i]['max'] == _controller.maxRange) {
          _selectedRangeIndex = i;
        }
      }
    }
    _sliderValue =
        _sliderValue.clamp(1, _currentMaxDifficulty).toDouble();
    _applyValuesToController();
  }

  void _applyValuesToController() {
    final range = _currentRange;
    _controller.setRange(range['min']!, range['max']!);
    _controller.setDifficulty(_sliderValue.round());
  }

  Future<void> _saveSettings() async {
    final user = _service.currentUser;
    if (user == null || _isSaving) return;
    if (mounted) {
      setState(() => _isSaving = true);
    }
    final range = _currentRange;
    final updated = user.preferences.copyWith(
      touchGameDifficulty: _sliderValue.round(),
      touchGameRangeMin: range['min'],
      touchGameRangeMax: range['max'],
    );
    final success =
        await _service.updatePreferences(user.id, updated);
    if (success) {
      _service.updateCurrentUserPreferences(updated);
    }
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
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
    
    // Calculamos el máximo permitido del slider según el rango seleccionado
    double maxValue = _currentMaxDifficulty;

    return WillPopScope(
      onWillPop: () async {
        await _saveSettings();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        
        // === BARRA SUPERIOR ===
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
        
        // === CONTENIDO DE LA PANTALLA ===
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toca el número que suena',
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

            // === SECCIÓN: SLIDER DE DIFICULTAD ===
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
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                            _controller.setDifficulty(value.toInt());
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Números más grandes debajo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        maxValue.toInt(),
                        (index) => Text(
                          '${index + 1}',
                          style: TextStyle(
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

            // === SECCIÓN: RANGO DE NÚMEROS ===
            Text(
              'Rango de números',
              style: TextStyle(
                fontSize: 18.0 * 1.1,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            
            // Botones de rango en grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: List.generate(_ranges.length, (index) {
                  bool selected = _selectedRangeIndex == index;
                  String label =
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
                          color: selected ? primaryColor : Colors.grey.shade300,
                          width: selected ? 3 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w500,
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
