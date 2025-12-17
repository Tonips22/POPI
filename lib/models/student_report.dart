class StudentReport {
  final String studentName;
  final DateTime reportDate;
  final DateTime periodStart;
  final DateTime periodEnd;

  final int totalSessions;
  final int activeDays;
  final DateTime? lastUseDate;

  final int totalHits;
  final int totalFails;
  final double successRate; // 0..100
  final double errorRate;   // 0..100
  final String evolution;

  final List<GameSummary> byGame;

  final List<String> recommendedGames;
  final String nextLevelSuggestion;

  StudentReport({
    required this.studentName,
    required this.reportDate,
    required this.periodStart,
    required this.periodEnd,
    required this.totalSessions,
    required this.activeDays,
    required this.lastUseDate,
    required this.totalHits,
    required this.totalFails,
    required this.successRate,
    required this.errorRate,
    required this.evolution,
    required this.byGame,
    required this.recommendedGames,
    required this.nextLevelSuggestion,
  });
}

class GameSummary {
  final int tipoJuego;
  final String gameName;
  final int attempts;
  final int hits;
  final int fails;
  final double successPercent;

  GameSummary({
    required this.tipoJuego,
    required this.gameName,
    required this.attempts,
    required this.hits,
    required this.fails,
    required this.successPercent,
  });
}
