import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
// import '../widgets/preference_provider.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  final GameController _controller = GameController();
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

    // Encuentra el rango actual si coincide
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
    
    // Calculamos el máximo permitido del slider según el rango seleccionado
    double maxValue = 12;
    if (_ranges[_selectedRangeIndex]['max'] == 10) {
      maxValue = 10;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dificultad',
          style: TextStyle(
            fontSize: 18.0 * 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
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
              'Toca el número que suena',
              style: TextStyle(
                fontSize: 18.0 * 1.2,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona la cantidad de números',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Roboto',
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
                        activeTrackColor: Colors.blue,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.blue,
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
                String label = '${_ranges[index]['min']}-${_ranges[index]['max']}';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRangeIndex = index;
                      _controller.setRange(
                        _ranges[index]['min']!,
                        _ranges[index]['max']!,
                      );

                      // Ajusta el slider si queda fuera del rango
                      if (_ranges[index]['max'] == 10 && _sliderValue > 10) {
                        _sliderValue = 10;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? Colors.blue : Colors.grey.shade300,
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