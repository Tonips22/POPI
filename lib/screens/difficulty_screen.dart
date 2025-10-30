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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dificultad"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecciona dificultad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Slider de 1 a 12
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 12,
                    divisions: 11,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        _controller.setDifficulty(value.toInt());
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      12,
                          (index) => Text('${index + 1}',
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Botones de rango
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: List.generate(_ranges.length, (index) {
                bool selected = _selectedRangeIndex == index;
                String label =
                    '${_ranges[index]['min']}-${_ranges[index]['max']}';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRangeIndex = index;
                      _controller.setRange(
                        _ranges[index]['min']!,
                        _ranges[index]['max']!,
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: selected ? Colors.grey[400] : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Guardar y volver"),
            ),
          ],
        ),
      ),
    );
  }
}
