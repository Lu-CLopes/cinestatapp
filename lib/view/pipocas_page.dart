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
  bool _isLoadingProducts = true;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoadingProducts = true);
    try {
      final dataConnectService = DataConnectService();
      final items = await dataConnectService.getAllProducts();
      if (!mounted) return;
      setState(() {
        _products = items;
        _isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar produtos: $e');
      if (!mounted) return;
      setState(() => _isLoadingProducts = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar receitas acessórias: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }

  Widget _buildRevenueSummary() {
    if (_isLoadingProducts) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Color(0xFF9B0000)),
      );
    }

    if (_products.isEmpty) {
      return const Text(
        'Nenhuma receita acessória cadastrada ainda. Utilize o formulário abaixo para adicionar produtos.',
        style: TextStyle(color: Colors.grey),
      );
    }

    final totalRevenue = _products.fold<double>(
      0,
      (sum, product) => sum + ((product['price'] as num?)?.toDouble() ?? 0.0),
    );
    final activeCount = _products
        .where((product) => product['active'] == true)
        .length;

    final Map<String, double> revenueByType = {};
    for (final product in _products) {
      final type = ((product['type'] as String?) ?? 'Outros').trim();
      final price = ((product['price'] as num?)?.toDouble() ?? 0.0);
      revenueByType.update(
        type.isEmpty ? 'Outros' : type,
        (value) => value + price,
        ifAbsent: () => price,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildMetric(
                  label: 'Receita estimada',
                  value: _formatCurrency(totalRevenue),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetric(
                  label: 'Produtos ativos',
                  value: '$activeCount',
                ),
              ),
            ],
          ),
        ),
        if (revenueByType.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Receita por categoria',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: revenueByType.entries
                .map(
                  (entry) => Chip(
                    backgroundColor: Colors.grey[850],
                    label: Text(
                      '${entry.key} (${_formatCurrency(entry.value)})',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildProductsList() {
    if (_isLoadingProducts) {
      return const SizedBox.shrink();
    }

    if (_products.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = _products[index];
        final active = product['active'] == true;
        final price = ((product['price'] as num?)?.toDouble() ?? 0.0);
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[850]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            title: Text(
              product['name'] as String? ?? 'Produto',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  'Categoria: ${(product['type'] as String?) ?? '-'}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preço: ${_formatCurrency(price)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  active ? Icons.check_circle : Icons.cancel,
                  color: active ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  active ? 'Ativo' : 'Inativo',
                  style: TextStyle(
                    color: active ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
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

      // Converter preço para double
      final price = double.tryParse(productPriceStr.replaceAll(',', '.'));
      if (price == null || price <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preço deve ser um número válido e positivo'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Converter ativo para bool
      final active = activeStr.toLowerCase() == 'ativo';

      // Criar produto no backend
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
        await _loadProducts();
        if (!mounted) return;
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
                'Receitas Acessórias',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Gerencie pipocas, combos e promoções',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Receitas acessórias cadastradas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildRevenueSummary(),
              const SizedBox(height: 16),
              _buildProductsList(),
              const SizedBox(height: 32),
              const Divider(color: Colors.white24, thickness: 0.4),
              const SizedBox(height: 24),
              const Text(
                'Cadastrar novo produto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

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

                  final price = double.tryParse(value.replaceAll(',', '.'));
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
