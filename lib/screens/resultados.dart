// lib/screens/resultados.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/sesion_juego_service.dart';
import '../models/sesion_juego.dart';
import 'historial_resultados.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  final SesionJuegoService _sesionService = SesionJuegoService();
  List<SesionJuego> _sesiones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResultados();
  }

  Future<void> _loadResultados() async {
    setState(() => _isLoading = true);
    try {
      final sesiones = await _sesionService.getAllSesiones();
      sesiones.sort((a, b) => a.idSesion.compareTo(b.idSesion));

      setState(() {
        _sesiones = sesiones;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando resultados: $e');
      setState(() => _isLoading = false);
    }
  }

  double _getMaxY() {
    if (_sesiones.isEmpty) return 10;

    int maxValue = 0;
    for (var sesion in _sesiones) {
      if (sesion.nAciertos > maxValue) maxValue = sesion.nAciertos;
      if (sesion.nFallos > maxValue) maxValue = sesion.nFallos;
    }

    // redondear hacia arriba al siguiente múltiplo de 5 y dejar un margen
    return ((maxValue / 5).ceil() * 5 + 2).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sesiones.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay resultados registrados',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadResultados,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : Padding(
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
                        child: Text(
                          'Evolución de resultados (${_sesiones.length} sesiones)',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                              maxX: (_sesiones.length - 1).toDouble(),
                              minY: 0,
                              maxY: _getMaxY(),
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
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < _sesiones.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '${_sesiones[index].idSesion}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
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
                                  // 👈 OJO: aquí ya NO usamos tooltipBgColor
                                  getTooltipColor: (touchedSpot) => Colors.black87,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      final index = spot.x.toInt();
                                      final sesion = _sesiones[index];
                                      final label = spot.barIndex == 0 ? 'Aciertos' : 'Fallos';
                                      final value = spot.y.toInt();
                                      return LineTooltipItem(
                                        'Sesión ${sesion.idSesion}\n$label: $value',
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
                                // Serie de aciertos
                                LineChartBarData(
                                  isCurved: false,
                                  spots: _sesiones.asMap().entries.map((entry) {
                                    final i = entry.key;
                                    final s = entry.value;
                                    return FlSpot(i.toDouble(), s.nAciertos.toDouble());
                                  }).toList(),
                                  dotData: FlDotData(show: true),
                                  color: Colors.green,
                                  barWidth: 3,
                                ),
                                // Serie de fallos
                                LineChartBarData(
                                  isCurved: false,
                                  spots: _sesiones.asMap().entries.map((entry) {
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
                  ),
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
}