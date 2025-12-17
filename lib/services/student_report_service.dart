import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sesion_juego.dart';
import '../models/user_model.dart';

class DailyAgg {
  final DateTime day;
  final int hits;
  final int fails;
  DailyAgg({required this.day, required this.hits, required this.fails});
  int get attempts => hits + fails;
}

class _GameAgg {
  int hits = 0;
  int fails = 0;
  int sessions = 0;
}

class StudentReportData {
  final UserModel student;
  final DateTime start;
  final DateTime end;
  final int totalSessions;
  final int activeDays;
  final DateTime? lastUseDate;
  final int totalHits;
  final int totalFails;
  final double successRate;
  final Map<int, _GameAgg> byGame;
  final List<String> milestones;
  final List<DailyAgg> daily;

  StudentReportData({
    required this.student,
    required this.start,
    required this.end,
    required this.totalSessions,
    required this.activeDays,
    required this.lastUseDate,
    required this.totalHits,
    required this.totalFails,
    required this.successRate,
    required this.byGame,
    required this.milestones,
    required this.daily,
  });
}

class StudentReportService {
  final _db = FirebaseFirestore.instance;

  static const Map<int, String> gameNames = {
    1: 'Identificar números',
    2: 'Ordenar números',
    3: 'Reparto igual',
    4: 'Dejar el mismo número',
  };

  Future<StudentReportData> build({
    required UserModel student,
    required DateTime start,
    required DateTime end,
  }) async {
    final numericUserId = int.tryParse(student.id) ?? 0;

    final snap = await _db
        .collection('juegos')
        .where('id_usuario', isEqualTo: numericUserId)
        .where('fecha_sesion', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('fecha_sesion', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('fecha_sesion')
        .get();

    final sesiones = snap.docs.map((d) => SesionJuego.fromFirestore(d)).toList();

    int totalHits = 0;
    int totalFails = 0;
    DateTime? lastUse;
    final days = <String>{};
    final Map<int, _GameAgg> byGame = {};
    final Map<DateTime, _GameAgg> byDay = {};

    for (final s in sesiones) {
      // Usamos nAciertos y nFallos de tu modelo
      totalHits += s.nAciertos.toInt();
      totalFails += s.nFallos.toInt();
      lastUse = s.fechaSesion;
      days.add('${s.fechaSesion.year}-${s.fechaSesion.month}-${s.fechaSesion.day}');

      byGame.putIfAbsent(s.tipoJuego, () => _GameAgg());
      byGame[s.tipoJuego]!.hits += s.nAciertos.toInt();
      byGame[s.tipoJuego]!.fails += s.nFallos.toInt();
      byGame[s.tipoJuego]!.sessions += 1;

      final day = DateTime(s.fechaSesion.year, s.fechaSesion.month, s.fechaSesion.day);
      byDay.putIfAbsent(day, () => _GameAgg());
      byDay[day]!.hits += s.nAciertos.toInt();
      byDay[day]!.fails += s.nFallos.toInt();
    }

    List<String> milestones = [];
    byGame.forEach((tipo, agg) {
      final name = gameNames[tipo] ?? 'Juego $tipo';
      final total = agg.hits + agg.fails;
      if (total > 0) {
        final rate = agg.hits / total;
        if (rate >= 0.9) milestones.add('¡Dominio excelente en $name!');
      }
    });

    final totalAttempts = totalHits + totalFails;
    final successRate = totalAttempts == 0 ? 0.0 : (totalHits / totalAttempts) * 100.0;

    final daily = byDay.entries
        .map((e) => DailyAgg(day: e.key, hits: e.value.hits, fails: e.value.fails))
        .toList()..sort((a, b) => a.day.compareTo(b.day));

    return StudentReportData(
      student: student,
      start: start,
      end: end,
      totalSessions: sesiones.length,
      activeDays: days.length,
      lastUseDate: lastUse,
      totalHits: totalHits,
      totalFails: totalFails,
      successRate: double.parse(successRate.toStringAsFixed(1)),
      byGame: byGame,
      milestones: milestones,
      daily: daily,
    );
  }
}