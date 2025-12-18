import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/sesion_juego.dart';
import '../services/app_service.dart';
import '../services/sesion_juego_service.dart';

class _EmojiTier {
  final double minAccuracy;
  final String emoji;
  final String message;

  const _EmojiTier({
    required this.minAccuracy,
    required this.emoji,
    required this.message,
  });
}

class ResultadosSimpleScreen extends StatefulWidget {
  const ResultadosSimpleScreen({super.key});

  @override
  State<ResultadosSimpleScreen> createState() => _ResultadosSimpleScreenState();
}

class _ResultadosSimpleScreenState extends State<ResultadosSimpleScreen> {
  final SesionJuegoService _sesionService = SesionJuegoService();
  final AppService _appService = AppService();

  List<SesionJuego> _sesiones = [];
  bool _isLoading = true;
  bool _missingUser = false;

  static const List<_EmojiTier> _emojiTiers = [
    _EmojiTier(minAccuracy: 1.0, emoji: '🥇', message: '¡Perfecto, sin fallos!'),
    _EmojiTier(minAccuracy: 0.95, emoji: '🏆', message: '¡Excelente, casi perfecto!'),
    _EmojiTier(minAccuracy: 0.9, emoji: '🤩', message: '¡Brillas con mucha fuerza!'),
    _EmojiTier(minAccuracy: 0.85, emoji: '🚀', message: '¡Vas lanzado hacia el éxito!'),
    _EmojiTier(minAccuracy: 0.8, emoji: '🌟', message: '¡Gran rendimiento hoy!'),
    _EmojiTier(minAccuracy: 0.75, emoji: '💪', message: '¡Fuerza y perseverancia!'),
    _EmojiTier(minAccuracy: 0.7, emoji: '😄', message: '¡Muy buen trabajo!'),
    _EmojiTier(minAccuracy: 0.65, emoji: '😎', message: '¡Con estilo y seguridad!'),
    _EmojiTier(minAccuracy: 0.6, emoji: '😊', message: '¡Buen ritmo, sigue así!'),
    _EmojiTier(minAccuracy: 0.55, emoji: '😀', message: '¡Aciertos constantes!'),
    _EmojiTier(minAccuracy: 0.5, emoji: '🙂', message: '¡Balance positivo!'),
    _EmojiTier(minAccuracy: 0.45, emoji: '😌', message: '¡Cada paso cuenta!'),
    _EmojiTier(minAccuracy: 0.4, emoji: '😉', message: '¡Confía y continúa!'),
    _EmojiTier(minAccuracy: 0.35, emoji: '😺', message: '¡Siempre con buena actitud!'),
    _EmojiTier(minAccuracy: 0.0, emoji: '🙌', message: '¡Lo importante es seguir!'),
  ];

  @override
  void initState() {
    super.initState();
    _loadResultados();
  }

  Future<void> _loadResultados() async {
    setState(() => _isLoading = true);
    try {
      final userId = _appService.numericUserId;
      if (userId <= 0) {
        setState(() {
          _sesiones = [];
          _missingUser = true;
          _isLoading = false;
        });
        return;
      }

      final sesiones = await _sesionService.getSesionesByUsuario(userId);
      sesiones.sort((a, b) => a.sessionCounter.compareTo(b.sessionCounter));

      setState(() {
        _sesiones = sesiones;
        _missingUser = false;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando resultados simples: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF77A9F4),
        title: const Text(
          'RESULTADOS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_missingUser) {
      return _buildMessage(
        icon: Icons.lock_outline,
        message: 'Inicia sesión para ver tus resultados.',
      );
    }

    final sesionesHoy = _sessionsToday();
    if (sesionesHoy.isEmpty) {
      return _buildMessage(
        icon: Icons.calendar_today,
        message: 'Aún no hay sesiones registradas hoy.',
      );
    }

    final totalHits = sesionesHoy.fold<int>(0, (prev, s) => prev + s.nAciertos);
    final totalFails = sesionesHoy.fold<int>(0, (prev, s) => prev + s.nFallos);
    final double accuracy =
        totalHits + totalFails > 0 ? totalHits / (totalHits + totalFails) : 0;
    final tier = _emojiTierForAccuracy(accuracy);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF77A9F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Desempeño de hoy',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _chartCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.transparent,
                          minX: 0,
                          maxX: sesionesHoy.length <= 1
                              ? 0
                              : (sesionesHoy.length - 1).toDouble(),
                          minY: 0,
                          maxY: _getMaxY(sesionesHoy),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: sesionesHoy.length > 1,
                            verticalInterval: 1,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: _applyOpacity(const Color(0xFFB0C8FF), 0.6),
                              strokeWidth: 1,
                              dashArray: const [6, 6],
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: _applyOpacity(const Color(0xFFB0C8FF), 0.3),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            enabled: false,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 4,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
                              ),
                              spots: sesionesHoy.asMap().entries.map((entry) {
                                final i = entry.key;
                                final s = entry.value;
                                return FlSpot(i.toDouble(), s.nAciertos.toDouble());
                              }).toList(),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barIndex, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: const Color(0xFF22C55E),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: const [Color(0xFF22C55E), Color(0xFF0EA5E9)]
                                      .map((color) => _applyOpacity(color, 0.25))
                                      .toList(),
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 4,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFB7185), Color(0xFFF43F5E)],
                              ),
                              spots: sesionesHoy.asMap().entries.map((entry) {
                                final i = entry.key;
                                final s = entry.value;
                                return FlSpot(i.toDouble(), s.nFallos.toDouble());
                              }).toList(),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barIndex, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: const Color(0xFFF43F5E),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: const [Color(0xFFFB7185), Color(0xFFF43F5E)]
                                      .map((color) => _applyOpacity(color, 0.15))
                                      .toList(),
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 160,
                  child: _buildEmojiCard(
                    tier: tier,
                    totalHits: totalHits,
                    totalFails: totalFails,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiCard({
    required _EmojiTier tier,
    required int totalHits,
    required int totalFails,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Text(
              tier.emoji,
              style: const TextStyle(fontSize: 80),
            ),
          ),
        ),
        Text(
          tier.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Aciertos: $totalHits\nFallos: $totalFails',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadResultados,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({required Widget child}) {
    final radius = BorderRadius.circular(24);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF7FAFF),
            Color(0xFFE3EDFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: _applyOpacity(Colors.black, 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: child,
      ),
    );
  }

  List<SesionJuego> _sessionsToday() {
    final now = DateTime.now();
    return _sesiones
        .where((s) => _isSameDay(s.fechaSesion, now))
        .toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  double _getMaxY(List<SesionJuego> sesiones) {
    if (sesiones.isEmpty) return 10;
    int maxValue = 0;
    for (final sesion in sesiones) {
      maxValue = math.max(maxValue, math.max(sesion.nAciertos, sesion.nFallos));
    }
    if (maxValue < 5) return 5;
    return (maxValue * 1.2).ceilToDouble();
  }

  Color _applyOpacity(Color color, double opacity) {
    final double clamped = opacity.clamp(0.0, 1.0);
    final int alpha =
        math.min(255, math.max(0, (color.alpha * clamped).round()));
    return color.withAlpha(alpha);
  }

  _EmojiTier _emojiTierForAccuracy(double accuracy) {
    final normalized = accuracy.clamp(0.0, 1.0);
    for (final tier in _emojiTiers) {
      if (normalized >= tier.minAccuracy) {
        return tier;
      }
    }
    return _emojiTiers.last;
  }
}
