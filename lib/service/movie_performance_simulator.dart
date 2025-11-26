// lib/service/movie_performance_simulator.dart

class MovieSimulationResult {
  final double score; // 0 a 100
  final String nivel; // Baixo / Médio / Alto / Sem dados
  final Map<String, double> detalhes; // genreScore, formatScore, ageScore, durationScore

  MovieSimulationResult({
    required this.score,
    required this.nivel,
    required this.detalhes,
  });
}

class MoviePerformanceSimulator {
  int _ageFromLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.startsWith('livre')) return 0;

    final match = RegExp(r'\d+').firstMatch(label);
    if (match == null) return 0;
    return int.tryParse(match.group(0) ?? '0') ?? 0;
  }

  MovieSimulationResult simulate({
    required String genre,
    required String format,
    required String ageClassLabel,
    required int durationMinutes,
    required List<Map<String, dynamic>> audience,
  }) {
    if (audience.isEmpty) {
      return MovieSimulationResult(
        score: 0,
        nivel: 'Sem dados de público',
        detalhes: {
          'genreScore': 0,
          'formatScore': 0,
          'ageScore': 0,
          'durationScore': 0,
        },
      );
    }

    final minAge = _ageFromLabel(ageClassLabel);
    final total = audience.length;

    int genreMatch = 0;
    int formatMatch = 0;
    int ageOk = 0;

    for (final a in audience) {
      final audGenre = (a['genre'] as String?)?.trim() ?? '';
      final audFormat = (a['format'] as String?)?.trim() ?? '';
      final audAge = (a['age'] as int?) ?? 0;

      if (audGenre == genre) genreMatch++;
      if (audFormat == format) formatMatch++;
      if (audAge >= minAge) ageOk++;
    }

    final genreScore = (genreMatch / total) * 100;
    final formatScore = (formatMatch / total) * 100;
    final ageScore = (ageOk / total) * 100;

    // Duração “ideal” (ajusta como quiser)
    double durationScore;
    if (durationMinutes < 70 || durationMinutes > 180) {
      durationScore = 40;
    } else if (durationMinutes >= 90 && durationMinutes <= 140) {
      durationScore = 100;
    } else {
      durationScore = 70;
    }

    // Pesos dos fatores
    final finalScore = (genreScore * 0.4) +
        (formatScore * 0.3) +
        (ageScore * 0.2) +
        (durationScore * 0.1);

    String nivel;
    if (finalScore >= 70) {
      nivel = 'Alto potencial';
    } else if (finalScore >= 40) {
      nivel = 'Potencial médio';
    } else {
      nivel = 'Baixo potencial';
    }

    return MovieSimulationResult(
      score: finalScore,
      nivel: nivel,
      detalhes: {
        'genreScore': genreScore,
        'formatScore': formatScore,
        'ageScore': ageScore,
        'durationScore': durationScore,
      },
    );
  }
}
