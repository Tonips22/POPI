// lib/screens/historial_resultados.dart
import 'package:flutter/material.dart';
import '../services/sesion_juego_service.dart';
import '../models/sesion_juego.dart';
import '../services/app_service.dart';

class HistorialResultadosScreen extends StatefulWidget {
  const HistorialResultadosScreen({super.key});

  @override
  State<HistorialResultadosScreen> createState() => _HistorialResultadosScreenState();
}

class _DailySummary {
  _DailySummary({required this.date});

  final DateTime date;
  int totalHits = 0;
  int totalFails = 0;
  int totalSessions = 0;

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _HistorialResultadosScreenState extends State<HistorialResultadosScreen> {
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
      sesiones.sort((a, b) => b.sessionCounter.compareTo(a.sessionCounter));

      setState(() {
        _sesiones = sesiones;
        _missingUser = false;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando historial: $e');
      setState(() => _isLoading = false);
    }
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
          'HISTORIAL',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
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
    if (_sesiones.isEmpty) {
      return _buildMessage(
        icon: Icons.inbox_outlined,
        message: 'No hay resultados registrados',
      );
    }

    final dailySummaries = _groupSessionsByDay(_sesiones);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const TabBar(
                labelColor: Colors.black,
                indicatorColor: Color(0xFF77A9F4),
                tabs: [
                  Tab(text: 'Sesiones'),
                  Tab(text: 'Totales diarios'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildSessionsTab(),
                _buildDailyTotalsTab(dailySummaries),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
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

  Widget _buildSessionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _sesiones.map(_buildSesionCard).toList(),
      ),
    );
  }

  Widget _buildDailyTotalsTab(List<_DailySummary> summaries) {
    if (summaries.isEmpty) {
      return const Center(
        child: Text(
          'Aún no hay totales diarios.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemBuilder: (context, index) {
        final summary = summaries[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary.formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.totalSessions} sesiones',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildChip(
                icon: Icons.check,
                value: summary.totalHits,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: Icons.close,
                value: summary.totalFails,
                color: Colors.red,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: summaries.length,
    );
  }

  Widget _buildChip({required IconData icon, required int value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _applyOpacity(color, 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  List<_DailySummary> _groupSessionsByDay(List<SesionJuego> sesiones) {
    final Map<DateTime, _DailySummary> map = {};

    for (final sesion in sesiones) {
      final date = DateTime(sesion.fechaSesion.year, sesion.fechaSesion.month, sesion.fechaSesion.day);
      final summary = map.putIfAbsent(date, () => _DailySummary(date: date));
      summary.totalHits += sesion.nAciertos;
      summary.totalFails += sesion.nFallos;
      summary.totalSessions += 1;
    }

    final summaries = map.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return summaries;
  }

  Widget _buildSesionCard(SesionJuego sesion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _applyOpacity(const Color(0xFF77A9F4), 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${sesion.sessionCounter > 0 ? sesion.sessionCounter : sesion.idSesion}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF77A9F4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesión ${sesion.sessionCounter > 0 ? sesion.sessionCounter : sesion.idSesion}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sesion.fechaFormateada} - ${sesion.horaFormateada}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _applyOpacity(Colors.green, 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${sesion.nAciertos}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _applyOpacity(Colors.red, 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.close, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${sesion.nFallos}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _applyOpacity(Color color, double opacity) {
    final double clamped = opacity.clamp(0.0, 1.0);
    return color.withAlpha((255 * clamped).round());
  }
}
