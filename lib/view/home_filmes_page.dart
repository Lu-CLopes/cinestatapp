// Tela de Filmes
import 'package:flutter/material.dart';
import '../service/firebase/data_connect_service.dart';
import '../components/widgets/movie_card.dart';
import 'filmes_page.dart';
import 'update_filmes_page.dart';

class HomeFilmesPage extends StatefulWidget {
  const HomeFilmesPage({super.key});

  @override
  State<HomeFilmesPage> createState() => _HomeFilmesPageState();
}

class _HomeFilmesPageState extends State<HomeFilmesPage> {
  List<Map<String, dynamic>> _movies = [];
  Map<String, Map<String, dynamic>> _boxOfficeStats = {};
  bool _isLoading = false;
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _loadBoxOfficeStats();
  }

  Future<void> _loadMovies() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final dataConnectService = DataConnectService();
      final movies = await dataConnectService.getAllMovies();

      if (mounted) {
        setState(() {
          _movies = movies;
          _isLoading = false;
        });

        if (movies.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum filme encontrado.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar filmes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadBoxOfficeStats() async {
    if (!mounted) return;
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final dataConnectService = DataConnectService();
      final stats = await dataConnectService.getMovieBoxOfficeStats();

      if (mounted) {
        setState(() {
          _boxOfficeStats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStats = false);
        debugPrint('Erro ao carregar estatísticas de bilheteria: $e');
      }
    }
  }

  List<Map<String, dynamic>> get _rankedMovies {
    final ranked = _movies.map((movie) {
      final movieId = movie['id'] as String?;
      final stats = movieId != null ? _boxOfficeStats[movieId] : null;
      return {
        ...movie,
        'totalTickets': stats?['totalTickets'] ?? 0,
        'totalRevenue': stats?['totalRevenue'] ?? 0.0,
        'sessionCount': stats?['sessionCount'] ?? 0,
      };
    }).toList();

    ranked.sort((a, b) {
      final revenueA = (a['totalRevenue'] as num).toDouble();
      final revenueB = (b['totalRevenue'] as num).toDouble();
      return revenueB.compareTo(revenueA);
    });

    return ranked;
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }

  Future<void> _deleteMovie(String movieId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este filme?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final connector = DataConnectService();
    final ok = await connector.deleteMovie(movieId);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filme excluído com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadMovies();
      await _loadBoxOfficeStats();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir filme'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = const Center(
        child: CircularProgressIndicator(color: Color(0xFF9B0000)),
      );
    } else if (_movies.isEmpty) {
      body = const Center(
        child: Text(
          'Nenhum filme cadastrado.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    } else {
      body = GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9, // ajustado pra card quadrado
        ),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          final movieId = movie['id'] as String?;
          final title = (movie['movieTitle'] ?? '') as String;
          final genre = (movie['movieGenre'] ?? 'Sem gênero') as String;
          final durationValue = movie['movieDuration'];
          final duration = durationValue != null
              ? '$durationValue min'
              : 'Duração desconhecida';

          return MovieCard(
            title: title,
            genre: genre,
            duration: duration,
            onUpdate: movieId == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateFilmesPage(movieId: movieId),
                      ),
                    ).then((updated) {
                      if (updated == true) {
                        _loadMovies();
                        _loadBoxOfficeStats();
                      }
                    });
                  },
            onRead: movieId == null
                ? null
                : () async {
                    final data = await DataConnectService()
                        .getMovieById(movieId);
                    if (!mounted) return;
                    if (data == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Não foi possível carregar os dados.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(data['movieTitle'] ?? 'Filme'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gênero: ${data['movieGenre'] ?? '-'}'),
                              Text(
                                  'Classificação: ${data['movieAgeClass'] ?? '-'}'),
                              Text(
                                  'Duração: ${data['movieDuration'] ?? '-'} min'),
                              Text(
                                  'Distribuidora: ${data['movieDistrib'] ?? '-'}'),
                              Text('Formato: ${data['movieFormat'] ?? '-'}'),
                              Text('Diretor: ${data['movieDirector'] ?? '-'}'),
                              Text(
                                'Ativo: ${(data['movieActive'] ?? false) ? 'Sim' : 'Não'}',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fechar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
            onDelete: movieId == null ? null : () => _deleteMovie(movieId),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          if (!_isLoading) _buildBoxOfficeRanking(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FilmesPage()),
          ).then((value) {
            if (value == true) {
              _loadMovies();
              _loadBoxOfficeStats();
            }
          });
        },
        backgroundColor: const Color(0xFF9B0000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBoxOfficeRanking() {
    final ranked = _rankedMovies.where((movie) {
      final revenue = (movie['totalRevenue'] as num).toDouble();
      return revenue > 0;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ranking de Bilheteria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingStats)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF9B0000)),
              ),
            )
          else if (ranked.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Nenhum filme com vendas registradas ainda.',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...ranked.take(5).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final movie = entry.value;
              final title = movie['movieTitle'] as String? ?? 'Filme';
              final revenue = (movie['totalRevenue'] as num).toDouble();
              final tickets = movie['totalTickets'] as int? ?? 0;
              final sessions = movie['sessionCount'] as int? ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.amber
                            : index == 1
                                ? Colors.grey[600]
                                : index == 2
                                    ? Colors.brown[700]
                                    : Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${tickets.toString()} ingressos',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$sessions sessões',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatCurrency(revenue),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Receita total',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
