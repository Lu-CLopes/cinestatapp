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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
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
            }
          });
        },
        backgroundColor: const Color(0xFF9B0000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
