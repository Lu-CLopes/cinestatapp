// Tela de Filmes
import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class PipocasPage extends StatefulWidget {
  const PipocasPage({super.key});

  @override
  State<PipocasPage> createState() => _PipocasPageState();
}

class _PipocasPageState extends State<PipocasPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();

  // Valores para dropdowns
  String? _selectedType;
  String? _selectedActive;

  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final productName = _productNameController.text.trim();
      final type = _selectedType ?? '';
      final productPriceStr = _productPriceController.text.trim();
      final activeStr = _selectedActive ?? '';

      // Validar campos obrigatórios
      if (productName.isEmpty ||
          type.isEmpty ||
          productPriceStr.isEmpty ||
          activeStr.isEmpty) {
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
      final price = double.tryParse(productPriceStr);
      if (price == null || price <= 0) {
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
      final success = await dataConnectService.createProduct(
        productName: productName,
        productType: type,
        productPrice: price,
        productActive: active,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        // Limpar campos após sucesso
        _productNameController.clear();
        _productPriceController.clear();
        // Resetar dropdowns e formulário
        setState(() {
          _selectedType = null;
          _selectedActive = null;
        });
        // Resetar o formulário após limpar campos
        Future.microtask(() {
          _formKey.currentState?.reset();
        });
        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar produto. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
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
                'Cadastre seu Produto',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione produtos aqui',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Name
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
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
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo do produto',
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
                  DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                  DropdownMenuItem(value: 'Bebida', child: Text('Bebida')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o tipo do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Durations
              TextFormField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço (reais)',
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
                    return 'Digite o preço do produto';
                  }

                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Preço deve ser um número válido e positivo';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active
              // Comida Ativo
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Produto Ativo',
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
                    return 'Selecione a situação do produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Button to add Movie
              // Botão de Cadastro
              CineButtonComponente(
                text: _isLoading ? 'Cadastrando...' : 'Cadastrar Produto',
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
