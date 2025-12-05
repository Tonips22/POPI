import 'package:flutter/material.dart';
import '../logic/game_controller_ordenar.dart';
import '../services/app_service.dart';
// import '../widgets/preference_provider.dart';

class OrdenarDifficultyScreen extends StatefulWidget {
  const OrdenarDifficultyScreen({super.key});

  @override
  State<OrdenarDifficultyScreen> createState() => _OrdenarDifficultyScreenState();
}

class _OrdenarDifficultyScreenState extends State<OrdenarDifficultyScreen> {
  final OrdenarGameController _controller = OrdenarGameController();

  late double _sliderValue;
  int _selectedRangeIndex = 0;

  final List<Map<String, int>> _ranges = [
    {'min': 0, 'max': 10},
    {'min': 0, 'max': 20},
    {'min': 0, 'max': 100},
    {'min': 0, 'max': 1000},
  ];

  @override
  void initState() {
    super.initState();
    _sliderValue = _controller.difficulty.toDouble();

    for (int i = 0; i < _ranges.length; i++) {
      if (_ranges[i]['min'] == _controller.minRange &&
          _ranges[i]['max'] == _controller.maxRange) {
        _selectedRangeIndex = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final currentUser = AppService().currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
    final primaryColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.primaryColor))
        : Colors.blue;
    final titleFontSize = currentUser?.preferences.getFontSizeValue() ?? 20.0;
    final titleFontFamily = currentUser?.preferences.getFontFamilyName() ?? 'Roboto';

    double maxValue = (_ranges[_selectedRangeIndex]['max'] == 10) ? 10 : 12;

    return Scaffold(
      backgroundColor: backgroundColor,
      
      // === BARRA SUPERIOR ===
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
      
      // === CONTENIDO DE LA PANTALLA ===
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtítulo
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
                        onChanged: (v) {
                          setState(() {
                            _sliderValue = v;
                            _controller.setDifficulty(v.toInt());
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
                        (i) => Text(
                          "${i + 1}",
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
                bool selected = index == _selectedRangeIndex;
                String label = '${_ranges[index]['min']}-${_ranges[index]['max']}';
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRangeIndex = index;
                      _controller.setRange(
                        _ranges[index]['min']!,
                        _ranges[index]['max']!,
                      );

                      if (_ranges[index]['max'] == 10 && _sliderValue > 10) {
                        _sliderValue = 10;
                        _controller.setDifficulty(10);
                      }
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
                          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
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
    );
  }
}
