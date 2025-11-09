import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String genre;
  final String duration;
  final VoidCallback? onUpdate;
  final VoidCallback? onRead;
  final VoidCallback? onDelete;

  const MovieCard({
    super.key,
    required this.title,
    required this.genre,
    required this.duration,
    this.onUpdate,
    this.onRead,
    this.onDelete,
  });

  static const Color _appRed = Color(0xFF9B0000);

  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onPressed,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          icon: Icon(icon, size: 18, color: color),
          onPressed: onPressed,
          tooltip: label,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 170, // controla tamanho do card para evitar overflow vertical
        child: Padding(
          // reduzimos ligeiramente o padding horizontal para ganhar espaço
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Column(
            children: [
              // Conteúdo principal (ocupa o espaço disponível)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título que quebra linha e não estoura
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(genre, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(
                      duration,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Linha de ações compacta alinhada à direita
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min, // evita ocupar toda a largura
                  children: [
                    _action(
                      context,
                      Icons.edit_outlined,
                      'Update',
                      onUpdate,
                      _appRed,
                    ),
                    const SizedBox(width: 5),
                    _action(
                      context,
                      Icons.remove_red_eye_outlined,
                      'Read',
                      onRead,
                      Colors.white,
                    ),
                    const SizedBox(width: 5),
                    _action(
                      context,
                      Icons.delete_outline,
                      'Delete',
                      onDelete,
                      Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
