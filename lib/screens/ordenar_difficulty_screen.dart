import 'package:flutter/material.dart';
import '../logic/game_controller_ordenar.dart';
import '../widgets/preference_provider.dart';

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
    final prefs = PreferenceProvider.of(context);

    double maxValue = (_ranges[_selectedRangeIndex]['max'] == 10) ? 10 : 12;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ordena la secuencia',
              style: TextStyle(
                fontSize: (prefs?.getFontSizeValue() ?? 18.0) * 1.4,
                fontWeight: FontWeight.bold,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
              ),
            ),
            Text(
              'Selecciona dificultad',
              style: TextStyle(
                fontSize: (prefs?.getFontSizeValue() ?? 18.0),
                fontWeight: FontWeight.bold,
                fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 400,
              child: Column(
                children: [
                  Slider(
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      maxValue.toInt(),
                          (i) => Text("${i + 1}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Wrap(
              spacing: 20,
              runSpacing: 15,
              children: List.generate(_ranges.length, (index) {
                bool selected = index == _selectedRangeIndex;

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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? Colors.grey[400] : Colors.white,
                      border: Border.all(color: Colors.black, width: 1.8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${_ranges[index]['min']}-${_ranges[index]['max']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
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
