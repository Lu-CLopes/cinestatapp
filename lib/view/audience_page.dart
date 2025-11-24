import 'package:flutter/material.dart';

import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class AudiencePage extends StatefulWidget {
  const AudiencePage({super.key, this.initialUnitId});

  final String? initialUnitId;

  @override
  State<AudiencePage> createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  static const List<String> _ageOptions = [
    'Livre (L)',
    '10 anos',
    '12 anos',
    '14 anos',
    '16 anos',
    '18 anos',
  ];

  static const List<String> _genreOptions = [
    'Comédia',
    'Ação',
    'Drama',
    'Suspense',
    'Terror',
  ];

  static const List<String> _formatOptions = ['2D', '3D'];

  final _formKey = GlobalKey<FormState>();
  final DataConnectService _service = DataConnectService();

  List<Map<String, dynamic>> _units = [];
  List<Map<String, dynamic>> _audiences = [];

  String? _selectedUnitId;
  String? _selectedAgeLabel;
  String? _selectedGenre;
  String? _selectedFormat;

  bool _isLoadingUnits = true;
  bool _isLoadingAudience = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await _service.getUnitsForCurrentManager();
    if (!mounted) return;

    setState(() {
      _units = units;
      _selectedUnitId = widget.initialUnitId ??
          (units.isNotEmpty ? units.first['id'] as String? : null);
      _isLoadingUnits = false;
    });

    if (units.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre uma unidade antes de registrar o público.'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() => _audiences = []);
    } else if (_selectedUnitId != null) {
      await _loadAudienceData(_selectedUnitId!);
    }
  }

  Future<void> _loadAudienceData(String unitId) async {
    setState(() => _isLoadingAudience = true);
    final data = await _service.getAudienceByUnit(unitId);
    if (!mounted) return;
    setState(() {
      _audiences = data;
      _isLoadingAudience = false;
    });
  }

  int _convertAgeLabelToNumber(String label) {
    final match = RegExp(r'\d+').firstMatch(label);
    if (match == null) return 0;
    return int.tryParse(match.group(0) ?? '') ?? 0;
  }

  Future<void> _submitAudience() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedUnitId == null || _selectedUnitId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a unidade do público'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final created = await _service.createAudience(
        unitId: _selectedUnitId!,
        audienceAge: _convertAgeLabelToNumber(_selectedAgeLabel!),
        audienceGender: _selectedGenre ?? '',
        audienceFormat: _selectedFormat ?? '',
      );

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      if (created != null) {
        _formKey.currentState?.reset();
        setState(() {
          _selectedAgeLabel = null;
          _selectedGenre = null;
          _selectedFormat = null;
        });
        await _loadAudienceData(_selectedUnitId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Público cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar público. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar público: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUnits) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF9B0000)),
        ),
      );
    }

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
              const Icon(Icons.movie, size: 80, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                'Cadastre seu Público',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione audiência aqui',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(
                  label: 'Unidade do público',
                  icon: Icons.category,
                ),
                value: _selectedUnitId,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: _units
                    .map(
                      (unit) => DropdownMenuItem(
                        value: unit['id'] as String,
                        child: Text(
                          unit['name'] as String? ?? 'Unidade',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnitId = value;
                  });
                  if (value != null && value.isNotEmpty) {
                    _loadAudienceData(value);
                  } else {
                    setState(() => _audiences = []);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a unidade do público';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildAudienceInsights(),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(
                  label: 'Faixa etária',
                  icon: Icons.cake,
                ),
                value: _selectedAgeLabel,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: _ageOptions
                    .map(
                      (age) => DropdownMenuItem(
                        value: age,
                        child: Text(age, style: const TextStyle(color: Colors.white)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedAgeLabel = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a faixa etária';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(
                  label: 'Gênero do público',
                  icon: Icons.people,
                ),
                value: _selectedGenre,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: _genreOptions
                    .map(
                      (genre) => DropdownMenuItem(
                        value: genre,
                        child:
                            Text(genre, style: const TextStyle(color: Colors.white)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedGenre = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o gênero do público';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(
                  label: 'Formato favorito',
                  icon: Icons.theaters,
                ),
                value: _selectedFormat,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: _formatOptions
                    .map(
                      (format) => DropdownMenuItem(
                        value: format,
                        child: Text(
                          format,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedFormat = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o formato preferido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CineButtonComponente(
                text: _isSubmitting ? 'Cadastrando...' : 'Cadastrar Público',
                onPressed: _isSubmitting ? () {} : _submitAudience,
                textStyle: _isSubmitting
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

  Widget _buildAudienceInsights() {
    if (_selectedUnitId == null) {
      return const SizedBox.shrink();
    }

    if (_isLoadingAudience) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF9B0000)),
      );
    }

    if (_audiences.isEmpty) {
      return const Text(
        'Nenhum dado de público registrado para esta unidade.',
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      );
    }

    final total = _audiences.length;
    final validAges = _audiences
        .map((audience) => audience['age'] as int? ?? 0)
        .where((age) => age > 0)
        .toList();
    final double averageAge = validAges.isEmpty
        ? 0
        : validAges.reduce((value, element) => value + element) /
            validAges.length;

    final Map<String, int> genreCounts = {};
    final Map<String, int> formatCounts = {};

    for (final audience in _audiences) {
      final genre = (audience['genre'] as String?)?.trim();
      if (genre != null && genre.isNotEmpty) {
        genreCounts.update(genre, (value) => value + 1, ifAbsent: () => 1);
      }
      final format = (audience['format'] as String?)?.trim();
      if (format != null && format.isNotEmpty) {
        formatCounts.update(format, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMetric(label: 'Total de registros', value: '$total'),
            _buildMetric(
              label: 'Idade média',
              value: averageAge.isNaN ? '0' : averageAge.toStringAsFixed(1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (genreCounts.isNotEmpty) ...[
          const Text(
            'Gêneros preferidos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genreCounts.entries
                .map(
                  (entry) => Chip(
                    label: Text(
                      '${entry.key} (${entry.value})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[850],
                  ),
                )
                .toList(),
          ),
        ],
        if (formatCounts.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Formatos preferidos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: formatCounts.entries
                .map(
                  (entry) => Chip(
                    label: Text(
                      '${entry.key} (${entry.value})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[850],
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMetric({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }
}

