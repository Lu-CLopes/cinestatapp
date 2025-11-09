// Tela de Filmes
import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class UpdateFilmesPage extends StatefulWidget {
  final String movieId;
  const UpdateFilmesPage({super.key, required this.movieId});

  @override
  State<UpdateFilmesPage> createState() => _UpdateFilmesPageState();
}

class _UpdateFilmesPageState extends State<UpdateFilmesPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _directorController = TextEditingController();

  String? _selectedGenre;
  String? _selectedAgeClass;
  String? _selectedDistributor;
  String? _selectedFormat;
  String? _selectedDirector;
  String? _selectedActive;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  Future<void> _loadMovie() async {
    setState(() => _isLoading = true);
    final connector = DataConnectService();
    final data = await connector.getMovieById(widget.movieId);
    if (data != null && mounted) {
      _titleController.text = data['movieTitle'] ?? '';
      _durationController.text = (data['movieDuration']?.toString() ?? '');
      _selectedGenre = data['movieGenre'];
      _selectedAgeClass = data['movieAgeClass'];
      _selectedDistributor = data['movieDistrib'];
      _selectedFormat = data['movieFormat'];
      _selectedDirector = data['movieDirector'];
      _selectedActive = (data['movieActive'] == true) ? 'Ativo' : 'Desativo';
      // if you use director controller:
      _directorController.text = data['movieDirector'] ?? '';
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao carregar filme')));
      }
    }
  }

  Future<void> _updateMovie() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final title = _titleController.text.trim();
    final genre = _selectedGenre ?? '';
    final ageClass = _selectedAgeClass ?? '';
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final distrib = _selectedDistributor ?? '';
    final format = _selectedFormat ?? '';
    final director = _selectedDirector ?? _directorController.text.trim();
    final active = (_selectedActive ?? 'Desativo').toLowerCase() == 'ativo';

    final connector = DataConnectService();
    final ok = await connector.updateMovie(
      movieId: widget.movieId,
      movieTitle: title,
      movieGenre: genre,
      movieAgeClass: ageClass,
      movieDuration: duration,
      movieDistrib: distrib,
      movieFormat: format,
      movieDirector: director,
      movieActive: active,
    );

    setState(() => _isLoading = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filme atualizado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao atualizar filme'),
          backgroundColor: Colors.red,
        ),
      );
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
                'Modifique seu Filme',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Atualize filmes aqui',
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
                  prefixIcon: Icon(Icons.movie, color: Colors.grey),
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
                    return 'Por favor, insira o título do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Genre
              DropdownButtonFormField<String>(
                initialValue: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Genero do filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.category, color: Colors.grey),
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
                  DropdownMenuItem(value: 'Comédia', child: Text('Comédia')),
                  DropdownMenuItem(value: 'Ação', child: Text('Ação')),
                  DropdownMenuItem(value: 'Drama', child: Text('Drama')),
                  DropdownMenuItem(value: 'Suspense', child: Text('Suspense')),
                  DropdownMenuItem(value: 'Terror', child: Text('Terror')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o gênero do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Class
              DropdownButtonFormField<String>(
                initialValue: _selectedAgeClass,
                decoration: const InputDecoration(
                  labelText: 'Classificação indicativa',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.group, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: 'Livre (L)',
                    child: Text('Livre (L)'),
                  ),
                  DropdownMenuItem(value: '10 anos', child: Text('10 anos')),
                  DropdownMenuItem(value: '12 anos', child: Text('12 anos')),
                  DropdownMenuItem(value: '14 anos', child: Text('14 anos')),
                  DropdownMenuItem(value: '16 anos', child: Text('16 anos')),
                  DropdownMenuItem(value: '18 anos', child: Text('18 anos')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedAgeClass = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a classificação indicativa do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Durations
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duração (minutos)',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.timer, color: Colors.grey),
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

                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Duração deve ser um número válido e positivo';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Distribution
              DropdownButtonFormField<String>(
                initialValue: _selectedDistributor,
                decoration: const InputDecoration(
                  labelText: 'Distribuidora do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.business, color: Colors.grey),
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
                  DropdownMenuItem(
                    value: 'Walt Disney Studios',
                    child: Text('Walt Disney Studios'),
                  ),
                  DropdownMenuItem(
                    value: 'Warner Bros',
                    child: Text('Warner Bros'),
                  ),
                  DropdownMenuItem(
                    value: 'Universal Pictures',
                    child: Text('Universal Pictures'),
                  ),
                  DropdownMenuItem(
                    value: 'Sony Pictures',
                    child: Text('Sony Pictures'),
                  ),
                  DropdownMenuItem(
                    value: 'Paramount Pictures',
                    child: Text('Paramount Pictures'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDistributor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o distribuidor do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Formato
              DropdownButtonFormField<String>(
                initialValue: _selectedFormat,
                decoration: const InputDecoration(
                  labelText: 'Formato do Filme',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.theaters, color: Colors.grey),
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
                  DropdownMenuItem(value: '2D', child: Text('2D')),
                  DropdownMenuItem(value: '3D', child: Text('3D')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o formato do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Director
              DropdownButtonFormField<String>(
                initialValue: _selectedDirector,
                decoration: const InputDecoration(
                  labelText: 'Diretor',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person_pin, color: Colors.grey),
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
                  DropdownMenuItem(
                    value: 'Steven Spielberg',
                    child: Text('Steven Spielberg'),
                  ),
                  DropdownMenuItem(
                    value: 'Alfred Hitchcock',
                    child: Text('Alfred Hitchcock'),
                  ),
                  DropdownMenuItem(
                    value: 'Martin Scorsese',
                    child: Text('Martin Scorsese'),
                  ),
                  DropdownMenuItem(
                    value: 'James Cameron',
                    child: Text('James Cameron'),
                  ),
                  DropdownMenuItem(
                    value: 'Quentin Tarantino',
                    child: Text('Quentin Tarantino'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDirector = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o diretor do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active
              // Filme Ativo
              DropdownButtonFormField<String>(
                initialValue: _selectedActive,
                decoration: const InputDecoration(
                  labelText: 'Filme Ativo',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.check_circle, color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                  DropdownMenuItem(value: 'Desativo', child: Text('Desativo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedActive = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a situação do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Button to add Movie
              // Botão de Cadastro
              CineButtonComponente(
                text: _isLoading ? 'Atualizando...' : 'Atualizar Filme',
                onPressed: _isLoading ? () {} : _updateMovie,
                textStyle: _isLoading
                    ? const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
