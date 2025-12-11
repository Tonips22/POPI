import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../services/app_service.dart';
import 'equal_subtraction_screen.dart';

class RestarDifficultyScreen extends StatefulWidget {
  const RestarDifficultyScreen({super.key});

  @override
  State<RestarDifficultyScreen> createState() => _RestarDifficultyScreenState();
}

class _RestarDifficultyScreenState extends State<RestarDifficultyScreen> {
  // sliders locales, inicializados con los valores actuales del controlador
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

    // Clamp por si acaso
    _jarsSlider = _jarsSlider.clamp(_minJars.toDouble(), _maxJars.toDouble());
    _minBallsSlider = _minBallsSlider.clamp(
        _minBallsGlobal.toDouble(), _maxBallsGlobal.toDouble());
    _maxBallsSlider = _maxBallsSlider.clamp(
        _minBallsSlider, _maxBallsGlobal.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppService().currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
    final primaryColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.primaryColor))
        : Colors.blue;
    final titleFontSize = currentUser?.preferences.getFontSizeValue() ?? 20.0;
    final titleFontFamily =
        currentUser?.preferences.getFontFamilyName() ?? 'Roboto';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
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
            // subtítulo
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

            // === CARD: NÚMERO DE JARRAS ===
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
                        overlayShape: const RoundSliderOverlayShape(
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
                                .containersCountSetting = v.round();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _maxJars - _minJars + 1,
                            (index) {
                          final value = _minJars + index;
                          return Text(
                            '$value',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // === CARD: RANGO BOLAS INICIALES ===
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
                    const SizedBox(height: 8),
                    Text(
                      'Elige el mínimo y máximo de bolas con las que puede empezar cada jarra.',
                      style: TextStyle(
                        fontSize: titleFontSize * 0.9,
                        fontFamily: titleFontFamily,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    RangeSlider(
                      values: RangeValues(_minBallsSlider, _maxBallsSlider),
                      min: _minBallsGlobal.toDouble(),
                      max: _maxBallsGlobal.toDouble(),
                      divisions: _maxBallsGlobal - _minBallsGlobal,
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
                          EqualSubtractionController.minInitialBallsSetting =
                              _minBallsSlider.round();
                          EqualSubtractionController.maxInitialBallsSetting =
                              _maxBallsSlider.round();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mínimo: ${_minBallsSlider.round()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          'Máximo: ${_maxBallsSlider.round()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
