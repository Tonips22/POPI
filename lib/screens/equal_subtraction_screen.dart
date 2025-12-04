import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popi/screens/settings_screen.dart';
import '../widgets/check_icon_overlay.dart';
// import '../widgets/preference_provider.dart';
import '../services/app_service.dart';

/// ---------------------------------------------------------------------------
/// CONTROLADOR DEL JUEGO: RESTAS PARA IGUALAR RECIPIENTES
/// ---------------------------------------------------------------------------
class EqualSubtractionController {
  final Random _random = Random();

  static const int _containersCount = 3; // nº de recipientes
  late List<List<int>> containers;       // ids de bolas en cada jarra
  late List<int> initialCounts;          // nº inicial de bolas en cada jarra
  late int targetCount;                  // objetivo (mínimo inicial)

  int _nextBallId = 0;

  void initGame() {
    _startNewRound();
  }

  void nextRound() {
    _startNewRound();
  }

  void _startNewRound() {
    // Generamos cantidades iniciales entre 3 y 8, asegurando que no todas sean iguales
    while (true) {
      initialCounts = List<int>.generate(
        _containersCount,
            (_) => 3 + _random.nextInt(6), // 3..8
      );
      final unique = initialCounts.toSet();
      if (unique.length > 1) break; // evitamos empezar ya igualados
    }

    // El objetivo será el menor de los recipientes
    targetCount = initialCounts.reduce((a, b) => a < b ? a : b);

    containers = List<List<int>>.generate(
      _containersCount,
          (_) => <int>[],
    );
    _nextBallId = 0;

    // Creamos las bolas
    for (int j = 0; j < _containersCount; j++) {
      for (int k = 0; k < initialCounts[j]; k++) {
        containers[j].add(_nextBallId++);
      }
    }
  }

  int get containersCount => _containersCount;
  int get target => targetCount;

  List<int> ballsInJar(int jarIndex) =>
      List.unmodifiable(containers[jarIndex]);

  int countForJar(int jarIndex) => containers[jarIndex].length;

  void removeBallFromJar(int jarIndex, int ballId) {
    containers[jarIndex].remove(ballId);
  }

  bool get allJarsEqual {
    final counts = containers.map((c) => c.length).toSet();
    return counts.length == 1 && containers[0].length == targetCount;
  }

  /// Construye algo del estilo:
  /// "5 - 2 = 3     6 - 3 = 3     4 - 1 = 3"
  String buildEquation() {
    if (!allJarsEqual) return '';

    final int finalCount = targetCount;
    final List<String> parts = [];

    for (int j = 0; j < containersCount; j++) {
      final int start = initialCounts[j];
      final int removed = start - finalCount;
      parts.add('$start - $removed = $finalCount');
    }

    return parts.join('          ');
  }
}

/// ---------------------------------------------------------------------------
/// TABLERO VISUAL: SOLO JARRAS + TAP PARA QUITAR BOLAS
/// ---------------------------------------------------------------------------
class EqualSubtractionBoard extends StatefulWidget {
  const EqualSubtractionBoard({
    super.key,
    required this.controller,
    required this.onRoundUpdate,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final EqualSubtractionController controller;
  /// Se llama en cada acción:
  /// - isCorrect = true  -> todas las jarras iguales al objetivo (nivel completado)
  /// - isCorrect = false -> todavía no están igualadas
  final void Function(bool isCorrect, String equation) onRoundUpdate;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<EqualSubtractionBoard> createState() => _EqualSubtractionBoardState();
}

class _EqualSubtractionBoardState extends State<EqualSubtractionBoard> {
  bool _roundLocked = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final size = MediaQuery.of(context).size;
    final jarWidth = size.width * 0.22;
    final jarHeight = size.height * 0.4;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            controller.containersCount,
                (index) => _buildJar(
              index: index,
              width: jarWidth,
              height: jarHeight,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJar({
    required int index,
    required double width,
    required double height,
    required EqualSubtractionController controller,
  }) {
    final ballsInJar = controller.ballsInJar(index);
    final int currentCount = controller.countForJar(index);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade400, width: 3),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: ballsInJar
                  .map((id) => _buildBall(id, index))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Debajo mostramos la cantidad actual en grande
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$currentCount',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBall(int id, int jarIndex) {
    final controller = widget.controller;

    final visual = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: widget.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        if (_roundLocked) return;

        final currentCount = controller.countForJar(jarIndex);
        final target = controller.target;

        // No permitir bajar de la cantidad objetivo
        if (currentCount <= target) return;

        setState(() {
          controller.removeBallFromJar(jarIndex, id);
        });
        _checkCompletion();
      },
      child: visual,
    );
  }

  void _checkCompletion() {
    final controller = widget.controller;

    if (controller.allJarsEqual) {
      if (_roundLocked) return;
      _roundLocked = true;
      final equation = controller.buildEquation();
      widget.onRoundUpdate(true, equation);
    } else {
      widget.onRoundUpdate(false, '');
    }
  }
}

/// ---------------------------------------------------------------------------
/// PANTALLA PRINCIPAL DEL JUEGO DE RESTAS
/// ---------------------------------------------------------------------------
class EqualSubtractionScreen extends StatefulWidget {
  const EqualSubtractionScreen({super.key});

  @override
  State<EqualSubtractionScreen> createState() =>
      _EqualSubtractionScreenState();
}

class _EqualSubtractionScreenState extends State<EqualSubtractionScreen> {
  final EqualSubtractionController _controller = EqualSubtractionController();
  final AppService _service = AppService();

  bool _showCheckIcon = false;

  int _attempts = 0;     // nº de acciones (taps) en la ronda
  int _successes = 0;    // nº de rondas completadas
  late DateTime _roundStart;
  int _roundIndex = 0;   // para reconstruir el tablero entre rondas

  @override
  void initState() {
    super.initState();
    _controller.initGame();
    _roundStart = DateTime.now();
  }

  void _restartRound() {
    setState(() {
      _controller.nextRound();
      _showCheckIcon = false;
      _roundStart = DateTime.now();
      _roundIndex++;
      _attempts = 0;
    });
  }

  void _handleRoundUpdate(bool isCorrect, String equation) {
    _attempts++;
    final elapsed = DateTime.now().difference(_roundStart);

    if (isCorrect) {
      setState(() {
        _successes++;
        _showCheckIcon = true;
      });

      // Registro de progreso
      debugPrint(
        'Restas - acierto $_successes, intentos en la ronda: $_attempts, '
            'tiempo: ${elapsed.inSeconds}s',
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _restartRound();
      });
    } else {
      // Sin pista visual, solo registro interno
      debugPrint(
        'Restas - intento $_attempts, tiempo actual: ${elapsed.inSeconds}s',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final userColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.primaryColor))
        : Colors.blue.shade400;
    final secondaryColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.secondaryColor))
        : Colors.green;
    final backgroundColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.backgroundColor))
        : Colors.grey[50]!;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          'Resta para igualar',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
              setState(() {
                _controller.initGame();
                _showCheckIcon = false;
                _roundStart = DateTime.now();
                _roundIndex++;
                _attempts = 0;
              });
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EqualSubtractionBoard(
                  key: ValueKey(_roundIndex),
                  controller: _controller,
                  onRoundUpdate: _handleRoundUpdate,
                  primaryColor: userColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            ),
          ),

          if (_showCheckIcon)
            CheckIconOverlay(color: secondaryColor),
        ],
      ),
    );
  }
}
