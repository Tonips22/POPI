// lib/screens/resultados.dart
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
      print('Error cargando resultados: $e');
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

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: sesionesHoy.length <= 1
                    ? 0
                    : (sesionesHoy.length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxY(sesionesHoy),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[400]!),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.black87,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
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
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false,
                    spots: sesionesHoy.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return FlSpot(i.toDouble(), s.nAciertos.toDouble());
                    }).toList(),
                    dotData: FlDotData(show: true),
                    color: Colors.green,
                    barWidth: 3,
                  ),
                  LineChartBarData(
                    isCurved: false,
                    spots: sesionesHoy.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return FlSpot(i.toDouble(), s.nFallos.toDouble());
                    }).toList(),
                    dotData: FlDotData(show: true),
                    color: Colors.red,
                    barWidth: 3,
                  ),
                ],
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: points.length <= 1 ? 0 : (points.length - 1).toDouble(),
          minY: _dailyMinY(points),
          maxY: _dailyMaxY(points),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[400]!),
          ),
          titlesData: FlTitlesData(
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.black87,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
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
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: points
                  .map((point) => FlSpot(point.index.toDouble(), point.net.toDouble()))
                  .toList(),
              dotData: FlDotData(show: true),
              color: Colors.blueAccent,
              barWidth: 3,
            ),
          ],
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
