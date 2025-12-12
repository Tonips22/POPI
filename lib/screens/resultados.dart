// lib/screens/resultados.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/sesion_juego_service.dart';
import '../models/sesion_juego.dart';
import 'historial_resultados.dart';
import '../services/app_service.dart';

class _DailyAggregate {
  int hits = 0;
  int fails = 0;

  void add(int h, int f) {
    hits += h;
    fails += f;
  }

  int get net => hits - fails;
}

class _DailyNetPoint {
  const _DailyNetPoint({
    required this.index,
    required this.date,
    required this.net,
    required this.hits,
    required this.fails,
  });

  final int index;
  final DateTime date;
  final int net;
  final int hits;
  final int fails;
}

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  final SesionJuegoService _sesionService = SesionJuegoService();
  final AppService _appService = AppService();
  List<SesionJuego> _sesiones = [];
  bool _isLoading = true;
  bool _missingUser = false;

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
      debugPrint('Error cargando resultados: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF77A9F4),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.maybePop(context),
          ),
          centerTitle: true,
          title: const Text(
            'RESULTADOS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistorialResultadosScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: _buildBody(),
      ),
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
        actionLabel: 'Reintentar',
        onPressed: _loadResultados,
      );
    }
    if (_sesiones.isEmpty) {
      return _buildMessage(
        icon: Icons.inbox_outlined,
        message: 'No hay resultados registrados',
        actionLabel: 'Reintentar',
        onPressed: _loadResultados,
      );
    }

    final sesionesHoy = _sessionsToday();
    final dailyPoints = _dailyNetPoints();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF77A9F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Evolución de resultados',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Color(0xFF77A9F4),
              tabs: [
                Tab(text: 'Desempeño de hoy'),
                Tab(text: 'Suma cero diaria'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                _buildTodayPerformanceChart(sesionesHoy),
                _buildDailyNetChart(dailyPoints),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String message,
    required String actionLabel,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayPerformanceChart(List<SesionJuego> sesionesHoy) {
    if (sesionesHoy.isEmpty) {
      return _buildChartEmptyMessage('No hay sesiones registradas hoy.');
    }

    const hitsGradient = [Color(0xFF22C55E), Color(0xFF0EA5E9)];
    const failGradient = [Color(0xFFFB7185), Color(0xFFF43F5E)];

    return Column(
      children: [
        Expanded(
          child: _chartCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                    handleBuiltInTouches: true,
                    touchSpotThreshold: 24,
                    touchTooltipData: _buildTooltipData((spot) {
                      if (spot.barIndex != 0) return null;
                      final index = spot.x.toInt();
                      if (index < 0 || index >= sesionesHoy.length) {
                        return null;
                      }
                      final sesion = sesionesHoy[index];
                      final sessionLabel = sesion.sessionCounter > 0
                          ? sesion.sessionCounter
                          : sesion.idSesion;
                      final gameName = _getGameName(sesion.tipoJuego);
                      return LineTooltipItem(
                        'Sesión $sessionLabel\n$gameName\nAciertos: ${sesion.nAciertos}\nFallos: ${sesion.nFallos}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    }),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,
                      gradient: const LinearGradient(colors: hitsGradient),
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
                            strokeColor: hitsGradient.last,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: hitsGradient
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
                      gradient: const LinearGradient(colors: failGradient),
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
                            strokeColor: failGradient.last,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: failGradient
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
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Aciertos', Colors.green),
            const SizedBox(width: 32),
            _buildLegendItem('Fallos', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyNetChart(List<_DailyNetPoint> points) {
    if (points.isEmpty) {
      return _buildChartEmptyMessage(
        'Aún no hay suficientes datos para la suma cero diaria.',
      );
    }

    return _chartCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.transparent,
            minX: 0,
            maxX: points.length <= 1 ? 0 : (points.length - 1).toDouble(),
            minY: _dailyMinY(points),
            maxY: _dailyMaxY(points),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: _applyOpacity(const Color(0xFFA5B4FC), 0.4),
                strokeWidth: 1,
                dashArray: const [5, 6],
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: _applyOpacity(const Color(0xFFA5B4FC), 0.2),
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
              handleBuiltInTouches: true,
              touchSpotThreshold: 24,
              touchTooltipData: _buildTooltipData((spot) {
                final index = spot.x.toInt();
                if (index < 0 || index >= points.length) {
                  return null;
                }
                final point = points[index];
                final dateLabel = _formatDate(point.date);
                return LineTooltipItem(
                  '$dateLabel\nBalance: ${point.net}\nAciertos: ${point.hits}\nFallos: ${point.fails}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                barWidth: 4,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5B8DEF),
                    Color(0xFF6366F1),
                  ],
                ),
                spots: points
                    .map((point) => FlSpot(point.index.toDouble(), point.net.toDouble()))
                    .toList(),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barIndex, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: const Color(0xFF4338CA),
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5B8DEF),
                      Color(0xFF6366F1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 1],
                  ),
                  cutOffY: 0,
                  applyCutOffY: true,
                  spotsLine: const BarAreaSpotsLine(
                    show: true,
                    flLineStyle: FlLine(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartEmptyMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

  LineTouchTooltipData _buildTooltipData(
    LineTooltipItem? Function(LineBarSpot spot) builder,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (_) => _applyOpacity(Colors.black, 0.85),
      tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      tooltipMargin: 12,
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map(builder).whereType<LineTooltipItem>().toList();
      },
    );
  }

  Color _applyOpacity(Color color, double opacity) {
    final double clamped = opacity.clamp(0.0, 1.0);
    final double baseAlpha = color.a * 255.0;
    final int alpha =
        math.min(255, math.max(0, (baseAlpha * clamped).round()));
    return color.withAlpha(alpha);
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

  List<_DailyNetPoint> _dailyNetPoints() {
    final Map<DateTime, _DailyAggregate> map = {};
    for (final sesion in _sesiones) {
      final date = DateTime(sesion.fechaSesion.year, sesion.fechaSesion.month, sesion.fechaSesion.day);
      final aggregate = map.putIfAbsent(date, () => _DailyAggregate());
      aggregate.add(sesion.nAciertos, sesion.nFallos);
    }

    final entries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value.key;
      final aggregate = entry.value.value;
      return _DailyNetPoint(
        index: index,
        date: date,
        net: aggregate.net,
        hits: aggregate.hits,
        fails: aggregate.fails,
      );
    }).toList();
  }

  double _getMaxY(List<SesionJuego> sesiones) {
    if (sesiones.isEmpty) return 10;

    int maxValue = 0;
    for (var sesion in sesiones) {
      if (sesion.nAciertos > maxValue) maxValue = sesion.nAciertos;
      if (sesion.nFallos > maxValue) maxValue = sesion.nFallos;
    }

    return ((maxValue / 5).ceil() * 5 + 2).toDouble();
  }

  double _dailyMaxY(List<_DailyNetPoint> points) {
    if (points.isEmpty) return 5;
    int maxValue = points.first.net;
    for (final point in points) {
      if (point.net > maxValue) {
        maxValue = point.net;
      }
    }
    if (maxValue < 0) maxValue = 0;
    return ((maxValue / 5).ceil() * 5 + 2).toDouble();
  }

  double _dailyMinY(List<_DailyNetPoint> points) {
    if (points.isEmpty) return -5;
    int minValue = points.first.net;
    for (final point in points) {
      if (point.net < minValue) {
        minValue = point.net;
      }
    }
    if (minValue > 0) minValue = 0;
    final magnitude = ((minValue.abs() / 5).ceil() * 5 + 2).toDouble();
    return -magnitude;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _getGameName(int type) {
    switch (type) {
      case 1:
        return 'Toca el número';
      case 2:
        return 'Ordena los números';
      case 3:
        return 'Reparte sumas';
      case 4:
        return 'Resta para igualar';
      default:
        return 'Juego';
    }
  }
}
