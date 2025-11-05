// Tela de Filmes
import 'dart:ffi';

import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class FilmesPage extends StatefulWidget {
  const FilmesPage({super.key});

  @override
  State<FilmesPage> createState() => _FilmesPageState();
}

class _FilmesPageState extends State<FilmesPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ageClassController = TextEditingController();
  final _durationController = TextEditingController();
  final _distributorController = TextEditingController();
  final _formatController = TextEditingController();
  final _directorController = TextEditingController();
  final _activeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _ageClassController.dispose();
    _durationController.dispose();
    _distributorController.dispose();
    _formatController.dispose();
    _directorController.dispose();
    _activeController.dispose();
    super.dispose();
  }

  Future<void> _createMovie() async {
    if (_formKey.currentState!.validate()) {
      // Lógica para criar o filme
      // Você pode acessar os valores dos campos usando os controladores
      String title = _titleController.text;
      String genre = _genreController.text;
      String ageClass = _ageClassController.text;
      int duration = int.parse(_durationController.text);
      String distributor = _distributorController.text;
      String format = _formatController.text;
      String director = _directorController.text;
      String active = _activeController.text;

      final dataConnectService = DataConnectService();
      final created = await dataConnectService.createMovie(
        movieTitle: title,
        movieGenre: genre,
        movieAgeClass: ageClass,
        movieDuration: duration,
        movieDistrib: distributor,
        movieFormat: format,
        movieDirector: director,
        movieActive: active == 'Ativo' ? true : false,
      );

      if (created != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unidade criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to main page and remove all previous routes
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/main', (route) => false);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar unidade'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Logo
              const Icon(Icons.movie, size: 80, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                'Cadastre seu Filme',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione filmes aqui',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o título do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Genre
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(
                  labelText: 'Genero do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o genero do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Class
              TextFormField(
                controller: _ageClassController,
                decoration: const InputDecoration(
                  labelText: 'Classificação indicativa',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a classificação indicativa do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Durations
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duração do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a duração do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Distribution
              TextFormField(
                controller: _distributorController,
                decoration: const InputDecoration(
                  labelText: 'Distribuidor do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o distribuidor do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Formato
              TextFormField(
                controller: _formatController,
                decoration: const InputDecoration(
                  labelText: 'Formato do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o formato do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Director
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(
                  labelText: 'Diretor do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o diretor do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active
              // Filme Ativo
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filme Ativo',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                dropdownColor: Colors
                    .black, // cor do menu suspenso (ajuste conforme o tema)
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Desativo', child: Text('Desativo')),
                ],
                onChanged: (value) {
                  _activeController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a situação do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Button to add Unit
              // Botão de Cadastro
              CineButtonComponente(
                text: 'Criar Filme',
                onPressed: _isLoading ? () {} : _createMovie,
                textStyle: _isLoading
                    ? const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    : const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
