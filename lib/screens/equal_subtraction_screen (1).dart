import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popi/screens/settings_screen_restar.dart';
import '../widgets/check_icon_overlay.dart';
import '../services/app_service.dart';


/// ---------------------------------------------------------------------------
/// CONTROLADOR DEL JUEGO: RESTAS PARA IGUALAR RECIPIENTES
/// ---------------------------------------------------------------------------
class EqualSubtractionController {
  final Random _random = Random();
  // Parámetros configurables de dificultad (se cambian en RestarDifficultyScreen)
  static int containersCountSetting = 3;      // nº de jarras (2–6)
  static int minInitialBallsSetting = 3;      // mínimo de bolas iniciales por jarra
  static int maxInitialBallsSetting = 20;      // máximo de bolas iniciales por jarra


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
        containersCountSetting,
            (_) => minInitialBallsSetting +
            _random.nextInt(
              (maxInitialBallsSetting - minInitialBallsSetting + 1)
                  .clamp(1, 100), // por seguridad
            ),
      );
      final unique = initialCounts.toSet();
      if (unique.length > 1) break; // evitamos empezar ya igualados
    }


    // El objetivo será el menor de los recipientes
    targetCount = initialCounts.reduce((a, b) => a < b ? a : b);

    containers = List<List<int>>.generate(
      containersCountSetting,
          (_) => <int>[],
    );
    _nextBallId = 0;

    // Creamos las bolas
    for (int j = 0; j < containersCountSetting; j++) {
      for (int k = 0; k < initialCounts[j]; k++) {
        containers[j].add(_nextBallId++);
      }
    }

  }

  int get containersCount => containersCountSetting;
  int get target => targetCount;

  List<int> ballsInJar(int jarIndex) =>
      List.unmodifiable(containers[jarIndex]);

  int countForJar(int jarIndex) => containers[jarIndex].length;

  void removeBallFromJar(int jarIndex, int ballId) {
    containers[jarIndex].remove(ballId);
  }

  void removeBallAnywhere(int ballId) {
    for (final jar in containers) {
      jar.remove(ballId);
    }
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
    final int totalJars = controller.containersCount;

    // Decidimos cómo repartir las jarras en filas
    final List<List<int>> rows = _computeRows(totalJars);

    // Para calcular el tamaño de cada jarra, miramos cuántas hay en la fila más larga
    final int maxJarsInRow = rows
        .map((r) => r.length)
        .fold<int>(0, (prev, len) => len > prev ? len : prev);

    // Anchura y altura de cada jarra según cuántas haya
    final double jarWidth = size.width / (maxJarsInRow * 1.6);
    final double jarHeight = rows.length == 1
        ? size.height * 0.40
        : size.height * 0.20;   // (antes 0.26)


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final index in row)
                  _buildJar(
                    index: index,
                    width: jarWidth,
                    height: jarHeight,
                    controller: controller,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  List<List<int>> _computeRows(int total) {
    if (total <= 3) {
      // 1, 2 o 3 jarras: todas en una fila
      return [
        List<int>.generate(total, (i) => i),
      ];
    } else if (total == 4) {
      // 2 y 2
      return [
        [0, 1],
        [2, 3],
      ];
    } else if (total == 5) {
      // 3 arriba, 2 abajo
      return [
        [0, 1, 2],
        [3, 4],
      ];
    } else {
      // 6 jarras: 3 y 3
      return [
        [0, 1, 2],
        [3, 4, 5],
      ];
    }
  }

  Widget _buildJar({
    required int index,
    required double width,
    required double height,
    required EqualSubtractionController controller,
  }) {
    final ballsInJar = controller.ballsInJar(index);
    final int currentCount = controller.countForJar(index);
    final int initial = controller.initialCounts[index];
    // Calculamos el tamaño de las bolas en función del espacio disponible
    // y del número máximo de bolas que hay en cualquier jarra.
    final int maxBalls = controller.initialCounts
        .reduce((a, b) => a > b ? a : b); // máximo nº de bolas entre todas las jarras
    final int approxRows = (maxBalls / 2).ceil(); // suponemos 2 columnas de bolas

    // Espacio útil dentro de la jarra (restamos padding y algo de separación)
    final double maxBallWidth = (width - 16) / 2 - 6;        // 2 columnas
    final double maxBallHeight = (height - 16) / approxRows - 6;

    double ballSize =
    maxBallWidth < maxBallHeight ? maxBallWidth : maxBallHeight;

    // Limitamos para que no sean ni minúsculas ni gigantes
    if (ballSize > 64) ballSize = 64;
    if (ballSize < 28) ballSize = 28;



    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DragTarget<int>(
          onWillAccept: (_) => true,  // cualquier bola que pase por aquí se considera "aceptada"
          onAccept: (_) {
            // No hacemos nada: la bola no cambia de sitio,
            // solo usamos esto para que Draggable sepa que ha sido aceptado.
          },
          builder: (context, candidate, rejected) {
            return Container(
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
                      .map((id) => _buildBall(id, index, ballSize))
                      .toList(),

                ),
              ),
            );
          },
        ),

        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 60,
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
                fontSize: 24,              // antes 32
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Inicial: $initial',
          style: const TextStyle(
            fontSize: 14,                 // antes 16
            color: Colors.black54,
          ),
        ),


      ],
    );
  }

  Widget _buildBall(int id, int jarIndex, double size) {
    final controller = widget.controller;

    final visual = Container(
      width: size,
      height: size,
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
      // Tap: sigue funcionando como antes (quitar una bola)
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
      child: Draggable<int>(
        data: id,
        feedback: Material(
          color: Colors.transparent,
          child: visual,
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: visual,
        ),
        child: visual,
        onDragEnd: (details) {
          if (_roundLocked) return;

          // Si NO ha caído sobre una jarra (ningún DragTarget lo aceptó),
          // lo interpretamos como "quitar bola".
          if (!details.wasAccepted) {
            final currentCount = controller.countForJar(jarIndex);
            final target = controller.target;

            // No permitir bajar de la cantidad objetivo
            if (currentCount <= target) return;

            setState(() {
              controller.removeBallFromJar(jarIndex, id);
            });
            _checkCompletion();
          }
        },
      ),
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

      Future.delayed(const Duration(milliseconds: 2000), () {
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
    final titleFontSize = _service.currentUser?.preferences.getFontSizeValue() ?? 20.0;
    final titleFontFamily = _service.currentUser?.preferences.getFontFamilyName() ?? 'Roboto';

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
                  builder: (context) => const SettingsScreenRestar(),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Instrucciones arriba
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Quita bolas hasta que todas las jarras tengan el mismo número',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Objetivo numérico
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Objetivo: ${_controller.target}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),

                    // Tablero ocupando el resto del espacio
                    Expanded(
                      child: EqualSubtractionBoard(
                        key: ValueKey(_roundIndex),
                        controller: _controller,
                        onRoundUpdate: _handleRoundUpdate,
                        primaryColor: userColor,
                        secondaryColor: secondaryColor,
                      ),
                    ),
                  ],
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
