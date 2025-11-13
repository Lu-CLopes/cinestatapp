import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  final List<Map<String, dynamic>> schedule;

  const SchedulePage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    // Ordena por data/hora só pra garantir
    final sorted = [...schedule]
      ..sort((a, b) =>
          (a['datetime'] as DateTime).compareTo(b['datetime'] as DateTime));

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronograma sugerido'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final item = sorted[index];
          final movie = item['movie'] as Map<String, dynamic>;
          final dt = item['datetime'] as DateTime;

          final titulo = (movie['movieTitle'] ?? '') as String;
          final genero = (movie['movieGenre'] ?? 'Sem gênero') as String;
          final classificacao = (movie['movieAgeClass'] ?? '-') as String;

          return Card(
            color: const Color(0xFF1A1A1A),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                titulo,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${dateFormatter.format(dt)} - ${timeFormatter.format(dt)}\n'
                'Gênero: $genero | Classificação: $classificacao',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }
}
