// Tela de Filmes
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
  final _durationController = TextEditingController();
  final _directorController = TextEditingController();

  // Valores para dropdowns
  String? _selectedGenre;
  String? _selectedAgeClass;
  String? _selectedDistributor;
  String? _selectedFormat;
  String? _selectedDirector;
  String? _selectedActive;

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  Future<void> _createMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final title = _titleController.text.trim();
      final genre = _selectedGenre ?? '';
      final ageClass = _selectedAgeClass ?? '';
      final durationStr = _durationController.text.trim();
      final distributor = _selectedDistributor ?? '';
      final format = _selectedFormat ?? '';
      final director = _selectedDirector ?? '';
      final activeStr = _selectedActive ?? '';

      // Validar campos obrigatórios
      if (title.isEmpty || genre.isEmpty || ageClass.isEmpty || 
          durationStr.isEmpty || distributor.isEmpty || format.isEmpty || 
          director.isEmpty || activeStr.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preencha todos os campos'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Converter duração para int
      final duration = int.tryParse(durationStr);
      if (duration == null || duration <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Duração deve ser um número válido'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Converter ativo para bool
      final active = activeStr.toLowerCase() == 'ativo';

      // Criar filme no backend
      final dataConnectService = DataConnectService();
      final createdId = await dataConnectService.createMovie(
        movieTitle: title,
        movieGenre: genre,
        movieAgeClass: ageClass,
        movieDuration: duration,
        movieDistrib: distributor,
        movieFormat: format,
        movieDirector: director,
        movieActive: active,
      );

      if (createdId != null && mounted) {
        // Limpar campos após sucesso
        _titleController.clear();
        _durationController.clear();
        // Resetar dropdowns e formulário
        setState(() {
          _selectedGenre = null;
          _selectedAgeClass = null;
          _selectedDistributor = null;
          _selectedFormat = null;
          _selectedDirector = null;
          _selectedActive = null;
        });
        // Resetar o formulário após limpar campos
        Future.microtask(() {
          _formKey.currentState?.reset();
        });
        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Filme cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar filme. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Genero do filme',
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
                  _genreController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o gênero do filme';
                    return 'Selecione o gênero do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Class
              DropdownButtonFormField<String>(
              DropdownButtonFormField<String>(
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
                dropdownColor: Colors
                    .black, // cor do menu suspenso (ajuste conforme o tema)
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
                  _ageClassController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a classificação indicativa do filme';
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
                    return 'Por favor, insira a duração';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Duração deve ser um número válido e positivo';
                  }

                  final capacity = int.tryParse(value);
                  if (capacity == null) {
                    return 'Digite um número válido';
                  }

                  if (capacity <= 0) {
                    return 'A duração deve ser maior que zero';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Distribution
              DropdownButtonFormField<String>(
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Distribuidora do Filme',
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
                  _distributorController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o distribuidor do filme';
                    return 'Selecione o distribuidor do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Formato
              DropdownButtonFormField<String>(
              DropdownButtonFormField<String>(
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
                  _formatController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o formato do filme';
                    return 'Selecione o formato do filme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Director
              DropdownButtonFormField<String>(
              DropdownButtonFormField<String>(
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
                  _directorController.text = value!;
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
                value: _selectedActive,
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
                text: _isLoading ? 'Cadastrando...' : 'Cadastrar Filme',
                onPressed: _isLoading ? () {} : _createMovie,
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
