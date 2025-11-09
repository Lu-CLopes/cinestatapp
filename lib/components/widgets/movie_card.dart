import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String genre;
  final String duration;

  const MovieCard({
    super.key,
    required this.title,
    required this.genre,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(genre),
            const SizedBox(height: 4),
            Text(duration),
          ],
        ),
      ),
    );
  }
}
