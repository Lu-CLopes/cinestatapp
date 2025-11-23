// Tela de Filmes
import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class AudiencePage extends StatefulWidget {
  const AudiencePage({super.key});

  @override
  State<AudiencePage> createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  final _formKey = GlobalKey<FormState>();

  // Valores para dropdowns
  String? _selectedUnit;
  String? _selectedAge;
  String? _selectedGenre;
  String? _selectedFormat;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // try {
    //   final productName = _productNameController.text.trim();
    //   final type = _selectedType ?? '';
    //   final productPriceStr = _productPriceController.text.trim();
    //   final activeStr = _selectedActive ?? '';

    //   // Validar campos obrigatórios
    //   if (productName.isEmpty ||
    //       type.isEmpty ||
    //       productPriceStr.isEmpty ||
    //       activeStr.isEmpty) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Preencha todos os campos'),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //     return;
    //   }

    //   // Converter duração para int
    //   final price = double.tryParse(productPriceStr);
    //   if (price == null || price <= 0) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Duração deve ser um número válido'),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //     return;
    //   }

    //   // Converter ativo para bool
    //   final active = activeStr.toLowerCase() == 'ativo';

    //   // Criar filme no backend
    //   final dataConnectService = DataConnectService();
    //   final createdId = await dataConnectService.createProduct(
    //     productName: productName,
    //     productType: type,
    //     productPrice: price,
    //     productActive: active,
    //   );

    //   if (createdId != null && mounted) {
    //     // Limpar campos após sucesso
    //     _productNameController.clear();
    //     _productPriceController.clear();
    //     // Resetar dropdowns e formulário
    //     setState(() {
    //       _selectedType = null;
    //       _selectedActive = null;
    //     });
    //     // Resetar o formulário após limpar campos
    //     Future.microtask(() {
    //       _formKey.currentState?.reset();
    //     });
    //     // Mostrar mensagem de sucesso
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Produto cadastrado com sucesso!'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //   } else if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Erro ao cadastrar produto. Tente novamente.'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
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

              // Unit
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Unidade do público',
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
                  // load unitsByManager listar e mapear aqui
                  DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                  DropdownMenuItem(value: 'Bebida', child: Text('Bebida')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a unidade do público';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age do publico
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Idade do público',
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
                    _selectedAge = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a idade do público';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Genre do publico
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Genero do público',
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

              // Formato
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Formato do Filme preferência',
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

              // Button to add Movie
              // Botão de Cadastro
              CineButtonComponente(
                text: _isLoading ? 'Cadastrando...' : 'Cadastrar Público',
                onPressed: _isLoading ? () {} : _createProduct,
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
