import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';
import 'equal_subtraction_screen.dart';

class RestarDifficultyScreen extends StatefulWidget {
  final String? userId;

  const RestarDifficultyScreen({
    super.key,
    this.userId,
  });

  @override
  State<RestarDifficultyScreen> createState() =>
      _RestarDifficultyScreenState();
}

class _RestarDifficultyScreenState extends State<RestarDifficultyScreen> {
  final AppService _service = AppService();

  UserModel? _loadedUser;
  bool _isSaving = false;

  // sliders locales
  late double _jarsSlider;
  late double _minBallsSlider;
  late double _maxBallsSlider;

  final int _minJars = 2;
  final int _maxJars = 6;

  final int _minBallsGlobal = 1;
  final int _maxBallsGlobal = 20;

  @override
  void initState() {
    super.initState();

    _jarsSlider =
        EqualSubtractionController.containersCountSetting.toDouble();
    _minBallsSlider =
        EqualSubtractionController.minInitialBallsSetting.toDouble();
    _maxBallsSlider =
        EqualSubtractionController.maxInitialBallsSetting.toDouble();

    _loadUserAndPreferences();
  }

  // =====================================================
  // CARGA DE USUARIO Y PREFERENCIAS
  // =====================================================
  Future<void> _loadUserAndPreferences() async {
    if (widget.userId != null) {
      _loadedUser = await _service.getUserById(widget.userId!);
    } else {
      _loadedUser = _service.currentUser;
    }

    if (_loadedUser == null) return;

    final prefs = _loadedUser!.preferences;

    _jarsSlider =
        prefs.subtractGameJarsCount.clamp(_minJars, _maxJars).toDouble();
    _minBallsSlider = prefs.subtractGameMinBalls
        .clamp(_minBallsGlobal, _maxBallsGlobal)
        .toDouble();
    _maxBallsSlider = prefs.subtractGameMaxBalls
        .clamp(_minBallsGlobal, _maxBallsGlobal)
        .toDouble();

    if (_maxBallsSlider < _minBallsSlider) {
      _maxBallsSlider = _minBallsSlider;
    }

    EqualSubtractionController.containersCountSetting =
        _jarsSlider.round();
    EqualSubtractionController.minInitialBallsSetting =
        _minBallsSlider.round();
    EqualSubtractionController.maxInitialBallsSetting =
        _maxBallsSlider.round();

    if (mounted) {
      setState(() {});
    }
  }

  // =====================================================
  // GUARDADO DE PREFERENCIAS
  // =====================================================
  Future<void> _saveSettings() async {
    if (_loadedUser == null || _isSaving) return;

    if (mounted) {
      setState(() => _isSaving = true);
    }

    final updatedPreferences = _loadedUser!.preferences.copyWith(
      subtractGameJarsCount: _jarsSlider.round(),
      subtractGameMinBalls: _minBallsSlider.round(),
      subtractGameMaxBalls: _maxBallsSlider.round(),
    );

    final success = await _service.updatePreferences(
      _loadedUser!.id,
      updatedPreferences,
    );

    // ⚠️ Solo actualizar currentUser si es el propio usuario
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

    return WillPopScope(
      onWillPop: () async {
        await _saveSettings();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resta para igualar',
                style: TextStyle(
                  fontSize: titleFontSize * 1.2,
                  fontWeight: FontWeight.w600,
                  fontFamily: titleFontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ajusta el número de jarras y las bolas iniciales por jarra.',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: titleFontFamily,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),

              // === NÚMERO DE JARRAS ===
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de jarras',
                        style: TextStyle(
                          fontSize: titleFontSize * 1.05,
                          fontWeight: FontWeight.w600,
                          fontFamily: titleFontFamily,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: primaryColor,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: primaryColor,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16,
                          ),
                          overlayShape:
                          const RoundSliderOverlayShape(
                            overlayRadius: 28,
                          ),
                          trackHeight: 8,
                        ),
                        child: Slider(
                          value: _jarsSlider,
                          min: _minJars.toDouble(),
                          max: _maxJars.toDouble(),
                          divisions: _maxJars - _minJars,
                          label: _jarsSlider.round().toString(),
                          onChanged: (v) {
                            setState(() {
                              _jarsSlider = v;
                              EqualSubtractionController
                                  .containersCountSetting =
                                  v.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // === RANGO DE BOLAS ===
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bolas iniciales por jarra',
                        style: TextStyle(
                          fontSize: titleFontSize * 1.05,
                          fontWeight: FontWeight.w600,
                          fontFamily: titleFontFamily,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RangeSlider(
                        values: RangeValues(
                            _minBallsSlider, _maxBallsSlider),
                        min: _minBallsGlobal.toDouble(),
                        max: _maxBallsGlobal.toDouble(),
                        divisions:
                        _maxBallsGlobal - _minBallsGlobal,
                        labels: RangeLabels(
                          _minBallsSlider.round().toString(),
                          _maxBallsSlider.round().toString(),
                        ),
                        activeColor: primaryColor,
                        inactiveColor: Colors.grey[300],
                        onChanged: (values) {
                          setState(() {
                            _minBallsSlider = values.start;
                            _maxBallsSlider = values.end;
                            EqualSubtractionController
                                .minInitialBallsSetting =
                                _minBallsSlider.round();
                            EqualSubtractionController
                                .maxInitialBallsSetting =
                                _maxBallsSlider.round();
                          });
                        },
                      ),
                    ],
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
