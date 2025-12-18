import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';
import 'equal_share_screen.dart';

class SumarDifficultyScreen extends StatefulWidget {
  final String? userId;

  const SumarDifficultyScreen({
    super.key,
    this.userId,
  });

  @override
  State<SumarDifficultyScreen> createState() =>
      _SumarDifficultyScreenState();
}

class _SumarDifficultyScreenState extends State<SumarDifficultyScreen> {
  final AppService _service = AppService();

  UserModel? _loadedUser;
  bool _isSaving = false;

  // Slider de número de bolas
  late double _ballsSliderValue;

  // Opciones para el valor máximo de las bolas
  final List<int> _maxValueOptions = [10, 20, 50, 100];
  int _selectedMaxIndex = 0;

  @override
  void initState() {
    super.initState();

    _ballsSliderValue = EqualShareController.ballsCount.toDouble();
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
    // 👉 Si no, usamos el usuario actual
    else {
      _loadedUser = _service.currentUser;
    }

    if (_loadedUser == null) return;

    final prefs = _loadedUser!.preferences;

    _ballsSliderValue = prefs.shareGameBallsCount.toDouble();

    int idx = _maxValueOptions.indexOf(prefs.shareGameMaxValue);
    if (idx == -1) {
      _maxValueOptions.insert(0, prefs.shareGameMaxValue);
      idx = 0;
    }

    _selectedMaxIndex = idx;

    // Aplicar al controller
    EqualShareController.setBallsCount(_ballsSliderValue.round());
    EqualShareController
        .setBallValueMax(_maxValueOptions[_selectedMaxIndex]);

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
      shareGameBallsCount: _ballsSliderValue.round(),
      shareGameMaxValue: _maxValueOptions[_selectedMaxIndex],
    );

    final success = await _service.updatePreferences(
      _loadedUser!.id,
      updatedPreferences,
    );

    // ⚠️ Solo actualizar currentUser si no estamos editando otro usuario
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

    const double minBalls = 2;
    const double maxBalls = 10;

    return WillPopScope(
      onWillPop: () async {
        await _saveSettings();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,

        // === APPBAR ===
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
                'Reparte las bolas en las jarras',
                style: TextStyle(
                  fontSize: titleFontSize * 1.2,
                  fontWeight: FontWeight.w600,
                  fontFamily: titleFontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Elige cuántas bolas quieres y qué números pueden aparecer.',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: titleFontFamily,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),

              // === CARD: CANTIDAD DE BOLAS ===
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
                        'Cantidad de bolas',
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
                          value:
                          _ballsSliderValue.clamp(minBalls, maxBalls),
                          min: minBalls,
                          max: maxBalls,
                          divisions:
                          (maxBalls - minBalls).toInt(),
                          label: _ballsSliderValue.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _ballsSliderValue = value;
                              EqualShareController
                                  .setBallsCount(value.toInt());
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          (maxBalls - minBalls + 1).toInt(),
                              (index) => Text(
                            '${minBalls.toInt() + index}',
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

              // === VALOR MÁXIMO ===
              const Text(
                'Valores máximos de las bolas',
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
                children: List.generate(_maxValueOptions.length,
                        (index) {
                      final selected = index == _selectedMaxIndex;
                      final label =
                      _maxValueOptions[index].toString();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMaxIndex = index;
                            EqualShareController.setBallValueMax(
                              _maxValueOptions[index],
                            );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? primaryColor
                                  : Colors.grey.shade300,
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
