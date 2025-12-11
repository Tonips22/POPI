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
      print('Error cargando historial: $e');
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _missingUser
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Inicia sesión para ver tus resultados.',
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._sesiones.map((sesion) => _buildSesionCard(sesion)).toList(),
                    ],
                  ),
                ),
    );
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
              color: const Color(0xFF77A9F4).withOpacity(0.2),
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
                  color: Colors.green.withOpacity(0.2),
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
                  color: Colors.red.withOpacity(0.2),
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
}
