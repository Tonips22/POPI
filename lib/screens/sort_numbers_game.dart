import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../widgets/number_tile.dart';
import '../widgets/target_slot.dart';
import '../widgets/check_icon_overlay.dart';
import '../widgets/preference_provider.dart';

import '../logic/game_controller_ordenar.dart';
import 'settings_screen_ordenar.dart';
import 'game_selector_screen.dart';
import 'game_victory_screen.dart';

class SortNumbersGame extends StatefulWidget {
  const SortNumbersGame({super.key});

  @override
  State<SortNumbersGame> createState() => _SortNumbersGameState();
}

class _SortNumbersGameState extends State<SortNumbersGame>
    with SingleTickerProviderStateMixin {

  final OrdenarGameController _controller = OrdenarGameController();

  late List<int> pool;
  late List<int?> targets;
  late int count;

  late AnimationController _shakeController;
  int? _shakingValue;

  bool _showCheckIcon = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.initGame();
    _startRound();
  }

  void _startRound() {
    count = _controller.difficulty;

    pool = List<int>.from(_controller.pool)..shuffle();
    targets = List<int?>.filled(count, null);

    setState(() {});
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleDrop(DragItem dragItem, int targetIndex) {
    final value = dragItem.value;

    if (!_controller.isCorrectPlacement(value, targetIndex)) {
      _shakeNumber(value);
      return;
    }

    setState(() {
      if (dragItem.fromIndex >= 0) {
        final prev = targets[targetIndex];
        targets[targetIndex] = value;
        targets[dragItem.fromIndex] = prev;
      } else {
        final prev = targets[targetIndex];
        pool.remove(value);
        if (prev != null) pool.add(prev);
        targets[targetIndex] = value;
      }
    });

    _showPositivePill();
    _checkCompletion();
  }

  void _showPositivePill() {
    setState(() => _showCheckIcon = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showCheckIcon = false);
    });
  }

  void _shakeNumber(int value) {
    setState(() => _shakingValue = value);
    _shakeController.forward(from: 0).then((_) {
      if (mounted) setState(() => _shakingValue = null);
    });
  }

  void _removeFromTarget(int index) {
    final value = targets[index];
    if (value != null) pool.add(value);
    targets[index] = null;
    setState(() {});
  }

  void _checkCompletion() {
    for (int i = 0; i < count; i++) {
      if (targets[i] != _controller.sorted[i]) return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (victoryContext) => GameVictoryScreen(
          onRestart: () {
            Navigator.pushReplacement(
              victoryContext,
              MaterialPageRoute(builder: (_) => const SortNumbersGame()),
            );
          },
          onHome: () {
            Navigator.pushReplacement(
              victoryContext,
              MaterialPageRoute(builder: (_) => const ChooseGameScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenceProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        title: Text(
          'Ordena la secuencia',
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
                  builder: (_) => const SettingsScreenOrdenar(),
                ),
              );

              _controller.initGame();
              _startRound();
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // POOL
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: pool.map((value) {
                          final shake = value == _shakingValue;

                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: AnimatedBuilder(
                              animation: _shakeController,
                              builder: (context, child) {
                                final offset = shake
                                    ? math.sin(_shakeController.value * math.pi * 4) * 10
                                    : 0.0;

                                return Transform.translate(
                                  offset: Offset(offset, 0),
                                  child: child,
                                );
                              },
                              child: NumberTile(
                                value: value,
                                onTap: () {
                                  final idx = targets.indexOf(null);
                                  if (idx == -1) return;

                                  if (_controller.isCorrectPlacement(value, idx)) {
                                    _handleDrop(
                                      DragItem(value: value, fromIndex: -1),
                                      idx,
                                    );
                                  } else {
                                    _shakeNumber(value);
                                  }
                                },
                                draggableData:
                                DragItem(value: value, fromIndex: -1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(count, (i) {
                        return TargetSlot(
                          index: i,
                          value: targets[i],
                          onAccept: (drag) => _handleDrop(drag, i),
                          onRemove: () => _removeFromTarget(i),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_showCheckIcon)
            CheckIconOverlay(color: Colors.blue.shade400),
        ],
      ),
    );
  }
}

class DragItem {
  final int value;
  final int fromIndex; // -1 si viene del pool

  DragItem({
    required this.value,
    required this.fromIndex,
  });
}
