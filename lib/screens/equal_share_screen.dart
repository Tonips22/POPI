import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popi/screens/settings_screen.dart';
import '../widgets/check_icon_overlay.dart';
// import '../widgets/preference_provider.dart';
import '../services/app_service.dart';

/// ---------------------------------------------------------------------------
/// CONTROLADOR DEL JUEGO: SUMAS EN CADA RECIPIENTE
/// ---------------------------------------------------------------------------
class EqualShareController {
  final Random _random = Random();

  static const int _containersCount = 2; // ahora mismo siempre 2
  static const int _ballsCount = 4; // nº de bolas

  late List<int> ballValues; // valor de cada bola
  late List<int> targetValues; // número debajo de cada recipiente

  late List<int> pool; // ids de bolas aún arriba
  late List<List<int>> containers; // ids de bolas en cada tarro

  void initGame() {
    _startNewRound();
  }

  void nextRound() {
    _startNewRound();
  }

  void _startNewRound() {
    // Generamos una combinación de bolas y objetivos que tenga solución
    while (true) {
      // Valores de las bolas entre 1 y 4 (para que las sumas no se disparen)
      ballValues =
      List<int>.generate(_ballsCount, (_) => 1 + _random.nextInt(4));

      // Elegimos una partición aleatoria de las bolas en dos grupos:
      // grupo 1 -> recipiente 0, grupo 2 -> recipiente 1
      final int maxMask = (1 << _ballsCount) - 1;
      final int mask = 1 + _random.nextInt(maxMask - 1); // evita 0 y full

      final List<int> group1 = [];
      final List<int> group2 = [];

      for (int i = 0; i < _ballsCount; i++) {
        if ((mask & (1 << i)) != 0) {
          group1.add(i);
        } else {
          group2.add(i);
        }
      }

      // Calculamos las sumas objetivo
      final int sum1 =
      group1.fold(0, (s, idx) => s + ballValues[idx]);
      final int sum2 =
      group2.fold(0, (s, idx) => s + ballValues[idx]);

      // Queremos objetivos entre 1 y 10
      if (sum1 >= 1 && sum1 <= 10 && sum2 >= 1 && sum2 <= 10) {
        targetValues = [sum1, sum2];
        break;
      }
    }

    // Todas las bolas empiezan en el "pool" de arriba
    pool = List<int>.generate(_ballsCount, (i) => i);
    containers = List<List<int>>.generate(
      _containersCount,
          (_) => <int>[],
    );
  }

  int get containersCount => _containersCount;

  List<int> get ballsInPool => List.unmodifiable(pool);

  int getBallValue(int ballId) => ballValues[ballId];

  void moveObjectToContainer(int objectId, int containerIndex) {
    pool.remove(objectId);
    for (final jar in containers) {
      jar.remove(objectId);
    }
    containers[containerIndex].add(objectId);
  }

  void moveObjectToPool(int objectId) {
    for (final jar in containers) {
      jar.remove(objectId);
    }
    if (!pool.contains(objectId)) {
      pool.add(objectId);
    }
  }

  bool get isPoolEmpty => pool.isEmpty;

  int sumForJar(int jarIndex) {
    return containers[jarIndex]
        .fold(0, (sum, id) => sum + getBallValue(id));
  }

  bool jarMatchesTarget(int jarIndex) {
    return sumForJar(jarIndex) == targetValues[jarIndex];
  }

  bool get isCompletedCorrectly {
    if (!isPoolEmpty) return false;
    for (int i = 0; i < containersCount; i++) {
      if (!jarMatchesTarget(i)) return false;
    }
    return true;
  }

  bool get isCompletedIncorrect => isPoolEmpty && !isCompletedCorrectly;

  /// Ecuación tipo: "2 + 3 = 5   ·   1 + 3 = 4"
  String buildEquation() {
    if (!isCompletedCorrectly) return '';
    final List<String> parts = [];
    for (int j = 0; j < containersCount; j++) {
      final values =
      containers[j].map((id) => getBallValue(id)).toList();
      final terms = values.join(' + ');
      parts.add('$terms = ${targetValues[j]}');
    }
    return parts.join('          ');
  }
}

  /// ---------------------------------------------------------------------------
/// TABLERO VISUAL CON DRAG & DROP + TAP-TO-SELECT
///  + BLOQUEO SI SE SUPERA EL OBJETIVO
/// ---------------------------------------------------------------------------
class EqualShareBoard extends StatefulWidget {
  const EqualShareBoard({
    super.key,
    required this.controller,
    required this.onRoundEnd,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final EqualShareController controller;
  final void Function(bool isCorrect, String equation) onRoundEnd;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<EqualShareBoard> createState() => _EqualShareBoardState();
}

class _EqualShareBoardState extends State<EqualShareBoard> {
  bool _roundLocked = false;
  int? _selectedBallId; // bola seleccionada para accesibilidad

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final size = MediaQuery.of(context).size;
    final jarWidth = size.width * 0.18;
    final jarHeight = size.height * 0.35;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // FILA SUPERIOR: bolas (pool)
        _buildPool(controller),

        const SizedBox(height: 16),

        // FILA INFERIOR: recipientes
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

  Widget _buildPool(EqualShareController controller) {
    return DragTarget<int>(
      onWillAccept: (_) => true,
      onAccept: (objectId) {
        setState(() {
          controller.moveObjectToPool(objectId);
          _selectedBallId = null;
        });
        _checkCompletion();
      },
      builder: (context, candidate, rejected) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            // Tap en la zona del pool: devuelve la bola seleccionada al pool
            onTap: () {
              if (_selectedBallId != null) {
                setState(() {
                  controller.moveObjectToPool(_selectedBallId!);
                  _selectedBallId = null;
                });
                _checkCompletion();
              }
            },
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: controller.ballsInPool
                  .map((id) => _buildDraggableBall(id))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJar({
    required int index,
    required double width,
    required double height,
    required EqualShareController controller,
  }) {
    final ballsInJar = controller.containers[index];
    final int target = controller.targetValues[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          // Tap en la jarra: si hay bola seleccionada, se mueve aquí
          onTap: () {
            if (_selectedBallId != null) {
              final value = controller.getBallValue(_selectedBallId!);
              final currentSum = controller.sumForJar(index);
              // si nos pasamos del objetivo, NO hacemos nada
              if (currentSum + value > target) return;

              setState(() {
                controller.moveObjectToContainer(_selectedBallId!, index);
                _selectedBallId = null;
              });
              _checkCompletion();
            }
          },
          child: DragTarget<int>(
            // aquí decidimos si aceptamos la bola arrastrada
            onWillAccept: (objectId) {
              if (objectId == null) return false;
              final value = controller.getBallValue(objectId);
              final currentSum = controller.sumForJar(index);
              return currentSum + value <= target;
            },
            onAccept: (objectId) {
              // por seguridad, volvemos a comprobar
              final value = controller.getBallValue(objectId);
              final currentSum = controller.sumForJar(index);
              if (currentSum + value > target) {
                return; // no aceptamos si se pasa
              }
              setState(() {
                controller.moveObjectToContainer(objectId, index);
                _selectedBallId = null;
              });
              _checkCompletion();
            },
            builder: (context, candidateData, rejectedData) {
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
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: ballsInJar
                            .map((id) => _buildDraggableBall(id))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          height: 90,
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
              '$target',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableBall(int id) {
    final controller = widget.controller;
    final value = controller.getBallValue(id);
    final bool isSelected = _selectedBallId == id;
    final bool isInPool = controller.ballsInPool.contains(id);

    final visual = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isSelected ? widget.primaryColor.withOpacity(0.5) : widget.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$value',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isInPool) {
            // Si está en el pool: seleccionar / deseleccionar
            if (_selectedBallId == id) {
              _selectedBallId = null;
            } else {
              _selectedBallId = id;
            }
          } else {
            // Si está en una jarra: la devolvemos al pool
            controller.moveObjectToPool(id);
            _selectedBallId = null;
          }
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
      ),
    );
  }


  void _checkCompletion() {
    if (_roundLocked) return;

    final controller = widget.controller;

    if (controller.isCompletedCorrectly) {
      _roundLocked = true;
      final equation = controller.buildEquation();
      widget.onRoundEnd(true, equation);
    } else if (controller.isCompletedIncorrect) {
      widget.onRoundEnd(false, '');
    }
  }
}

/// ---------------------------------------------------------------------------
/// PANTALLA PRINCIPAL (como NumberScreen)
/// ---------------------------------------------------------------------------
class EqualShareScreen extends StatefulWidget {
  const EqualShareScreen({super.key});

  @override
  State<EqualShareScreen> createState() => _EqualShareScreenState();
}

class _EqualShareScreenState extends State<EqualShareScreen> {
  final EqualShareController _controller = EqualShareController();
  final AppService _service = AppService();

  bool _showCheckIcon = false;
  bool _showErrorIcon = false;

  int _hits = 0;
  int _errors = 0;
  late DateTime _roundStart;
  int _roundIndex = 0; // para reconstruir el tablero entre rondas

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
      _showErrorIcon = false;
      _roundStart = DateTime.now();
      _roundIndex++;
    });
  }

  void _handleRoundEnd(bool isCorrect, String equation) {
    final elapsed = DateTime.now().difference(_roundStart);

    if (isCorrect) {
      setState(() {
        _hits++;
        _showCheckIcon = true;
      });

      // Aquí registrarías acierto + tiempo
      debugPrint('Acierto $_hits, tiempo: ${elapsed.inSeconds}s');

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _restartRound();
      });
    } else {
      setState(() {
        _errors++;
        _showErrorIcon = true;
      });

      // Aquí registrarías el error + tiempo
      debugPrint('Error $_errors, tiempo hasta el fallo: ${elapsed.inSeconds}s');

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _showErrorIcon = false;
        });
      });
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
          'Reparto de sumas',
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
                _showErrorIcon = false;
                _roundStart = DateTime.now();
                _roundIndex++;
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
                child: EqualShareBoard(
                  key: ValueKey(_roundIndex),
                  controller: _controller,
                  onRoundEnd: _handleRoundEnd,
                  primaryColor: userColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            ),
          ),

          if (_showCheckIcon)
            CheckIconOverlay(color: secondaryColor),

          if (_showErrorIcon)
            CheckIconOverlay(
              color: Colors.red,
              icon: Icons.cancel,
            ),
        ],
      ),
    );
  }
}
