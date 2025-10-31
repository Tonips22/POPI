import 'package:flutter/material.dart';
import '../logic/game_controller.dart';

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
    // Calculamos el máximo permitido del slider según el rango seleccionado
    double maxValue = 12;
    if (_ranges[_selectedRangeIndex]['max'] == 10) {
      maxValue = 10;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecciona dificultad',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Slider más grande
            SizedBox(
              width: 400, // antes 300
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8, // aumenta el grosor de la barra
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14), // más grande
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
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
                  const SizedBox(height: 10),

                  // Números más grandes debajo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      maxValue.toInt(),
                          (index) => Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Botones de rango
            Wrap(
              spacing: 20,
              runSpacing: 15,
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: selected ? Colors.grey[400] : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),

            // Botón de retroceso con más espaciado
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: IconButton(
                iconSize: 45,
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(18),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
