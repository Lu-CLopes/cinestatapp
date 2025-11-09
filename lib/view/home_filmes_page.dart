// Tela de Filmes
import 'package:flutter/material.dart';
import '../service/firebase/data_connect_service.dart';
import '../wave_clipper.dart'; // Importando o clipper
import '../components/widgets/movie_card.dart';
import 'filmes_page.dart';

class HomeFilmesPage extends StatefulWidget {
  const HomeFilmesPage({super.key});

  @override
  State<HomeFilmesPage> createState() => _HomeFilmesPageState();
}

class _HomeFilmesPageState extends State<HomeFilmesPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _directorController = TextEditingController();

  List<Map<String, dynamic>> _movies = [];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  Future<void> _loadMovies() async {
    try {
      final dataConnectService = DataConnectService();
      final movies = await dataConnectService.getAllMovies();

      if (movies.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum filme encontrado.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      if (mounted) {
        setState(() {
          _movies = movies;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar filmes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //_loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9, // ajustado pra card quadrado
              ),
              //itemCount: _movies.length, // sua lista de filmes
              itemCount: 4,
              itemBuilder: (context, index) {
                // final movie = _movies[index];
                // final title = movie['movieTitle'] ?? 'Título Desconhecido';
                // final genre = movie['movieGenre'] ?? 'Gênero Desconhecido';
                // final duration = movie['movieDuration'] != null
                //     ? '${movie['movieDuration']} min'
                //     : 'Duração Desconhecida';
                return MovieCard(
                  title: 'meu filme',
                  genre: 'terror',
                  duration: '120 mins',
                  // onTap: () {
                  //   setState(() {
                  //     selectedMovieIndex = index;
                  //   });
                  // },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FilmesPage()),
          );
        },
        backgroundColor: const Color(0xFF9B0000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
