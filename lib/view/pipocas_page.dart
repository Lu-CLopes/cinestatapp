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
  
  // Vendas
  List<Map<String, dynamic>> _sessions = [];
  List<Map<String, dynamic>> _units = [];
  List<Map<String, dynamic>> _movies = [];

  List<Map<String, dynamic>> get _rankedProducts {
    final sorted = List<Map<String, dynamic>>.from(_products)
      ..sort((a, b) => _productScore(b).compareTo(_productScore(a)));
    return sorted;
  }

  List<Map<String, dynamic>> get _rankedCombos {
    final combos = _products.where((product) {
      final type = (product['type'] as String?)?.toLowerCase() ?? '';
      return type.contains('combo') || type.contains('promo');
    }).toList()
      ..sort((a, b) => _productScore(b).compareTo(_productScore(a)));
    return combos;
  }

  double _productScore(Map<String, dynamic> product) {
    return ((product['totalQuantity'] as num?)?.toDouble() ?? 0.0);
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadSessions();
    _loadUnits();
    _loadMovies();
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

  Future<void> _loadSessions() async {
    try {
      final dataConnectService = DataConnectService();
      final items = await dataConnectService.getAllSessions();
      if (!mounted) return;
      setState(() {
        _sessions = items;
      });
    } catch (e) {
      debugPrint('Erro ao carregar sessões: $e');
    }
  }

  Future<void> _loadUnits() async {
    try {
      final dataConnectService = DataConnectService();
      final items = await dataConnectService.getUnitsForCurrentManager();
      if (!mounted) return;
      setState(() {
        _units = items;
      });
    } catch (e) {
      debugPrint('Erro ao carregar unidades: $e');
    }
  }

  Future<void> _loadMovies() async {
    try {
      final dataConnectService = DataConnectService();
      final items = await dataConnectService.getAllMovies();
      if (!mounted) return;
      setState(() {
        _movies = items;
      });
    } catch (e) {
      debugPrint('Erro ao carregar filmes: $e');
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
      (sum, product) => sum + ((product['totalRevenue'] as num?)?.toDouble() ?? 0.0),
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

  Widget _buildRankingSection() {
    if (_isLoadingProducts || _products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ranking de produtos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRankingList(
          _rankedProducts,
          emptyMessage: 'Cadastre produtos para ver o ranking.',
          showPosition: true,
        ),
        const SizedBox(height: 24),
        const Text(
          'Ranking de combos e promoções',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRankingList(
          _rankedCombos,
          emptyMessage: 'Cadastre combos ou promoções para ver o ranking.',
          showPosition: true,
        ),
      ],
    );
  }

  Widget _buildRankingList(
    List<Map<String, dynamic>> items, {
    required String emptyMessage,
    bool showPosition = false,
  }) {
    if (items.isEmpty) {
      return Text(
        emptyMessage,
        style: const TextStyle(color: Colors.grey),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final product = items[index];
        final rank = index + 1;
        final price = _formatCurrency(
          ((product['price'] as num?)?.toDouble() ?? 0.0),
        );
        final type = (product['type'] as String?) ?? '-';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[850]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showPosition) ...[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$rank',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String? ?? 'Produto',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Categoria: $type',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vendas: ${(product['totalQuantity'] ?? 0).toString()} unidades',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Preço',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Receita total',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    _formatCurrency(
                      ((product['totalRevenue'] as num?)?.toDouble() ?? 0.0),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
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

  Future<void> _showSaleDialog() async {
    final saleFormKey = GlobalKey<FormState>();
    String? selectedProductId;
    String? selectedSessionId;
    final quantityController = TextEditingController();
    final revenueController = TextEditingController();
    bool createNewSession = false;
    String? selectedUnitId;
    String? selectedMovieId;
    final sessionDateController = TextEditingController(
      text: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );
    final sessionHourController = TextEditingController(
      text: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );
    final sessionTicketsController = TextEditingController();
    final sessionRevenueController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Registrar Venda',
            style: TextStyle(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Form(
                key: saleFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  CheckboxListTile(
                    title: const Text(
                      'Criar nova sessão',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: createNewSession,
                    onChanged: (value) {
                      setDialogState(() {
                        createNewSession = value ?? false;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  if (createNewSession) ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      isExpanded: true,
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit['id'] as String,
                          child: Text(
                            unit['name'] as String? ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedUnitId = value;
                        });
                      },
                      validator: (value) {
                        if (createNewSession && (value == null || value.isEmpty)) {
                          return 'Selecione uma unidade';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filme',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      isExpanded: true,
                      items: _movies.map((movie) {
                        return DropdownMenuItem(
                          value: movie['id'] as String,
                          child: Text(
                            movie['movieTitle'] as String? ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedMovieId = value;
                        });
                      },
                      validator: (value) {
                        if (createNewSession && (value == null || value.isEmpty)) {
                          return 'Selecione um filme';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sessionDateController,
                      decoration: const InputDecoration(
                        labelText: 'Data da sessão (DD/MM/AAAA)',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (createNewSession && (value == null || value.isEmpty)) {
                          return 'Digite a data';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sessionHourController,
                      decoration: const InputDecoration(
                        labelText: 'Hora da sessão (HH:MM)',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (createNewSession && (value == null || value.isEmpty)) {
                          return 'Digite a hora';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bilheteria (opcional)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: sessionTicketsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ingressos vendidos',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        hintText: 'Ex: 150',
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sessionRevenueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Receita de ingressos (R\$)',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        hintText: 'Ex: 3000.00',
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    if (_sessions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: const Text(
                          'Nenhuma sessão cadastrada. Marque "Criar nova sessão" para continuar.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    else
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Sessão',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        isExpanded: true,
                        items: _sessions.map((session) {
                          final date = session['date'] as DateTime;
                          final hour = session['hour'] as DateTime;
                          final movie = session['movieTitle'] as String? ?? '';
                          final unit = session['unitName'] as String? ?? '';
                          final dateStr = '${date.day}/${date.month}/${date.year}';
                          final hourStr = '${hour.hour.toString().padLeft(2, '0')}:${hour.minute.toString().padLeft(2, '0')}';
                          final displayText = '$movie\n$unit - $dateStr $hourStr';
                          return DropdownMenuItem(
                            value: session['id'] as String,
                            child: Text(
                              displayText,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedSessionId = value;
                          });
                        },
                        validator: (value) {
                          if (!createNewSession && (value == null || value.isEmpty)) {
                            return 'Selecione uma sessão';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 16),
                  ],
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Produto',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    isExpanded: true,
                    items: _products.map((product) {
                      return DropdownMenuItem(
                        value: product['id'] as String,
                        child: Text(
                          product['name'] as String? ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedProductId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecione um produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade vendida',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite a quantidade';
                      }
                      final qty = int.tryParse(value);
                      if (qty == null || qty <= 0) {
                        return 'Quantidade deve ser um número positivo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: revenueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Receita líquida (opcional)',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (!saleFormKey.currentState!.validate()) return;
                Navigator.pop(context);
                await _createSale(
                  productId: selectedProductId!,
                  sessionId: selectedSessionId,
                  unitId: selectedUnitId,
                  movieId: selectedMovieId,
                  quantity: int.parse(quantityController.text),
                  revenue: revenueController.text.isNotEmpty
                      ? double.tryParse(revenueController.text.replaceAll(',', '.'))
                      : null,
                  createNewSession: createNewSession,
                  sessionDateStr: sessionDateController.text,
                  sessionHourStr: sessionHourController.text,
                  sessionTickets: sessionTicketsController.text.isNotEmpty
                      ? int.tryParse(sessionTicketsController.text)
                      : null,
                  sessionRevenue: sessionRevenueController.text.isNotEmpty
                      ? double.tryParse(sessionRevenueController.text.replaceAll(',', '.'))
                      : null,
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createSale({
    required String productId,
    String? sessionId,
    String? unitId,
    String? movieId,
    required int quantity,
    double? revenue,
    required bool createNewSession,
    String? sessionDateStr,
    String? sessionHourStr,
    int? sessionTickets,
    double? sessionRevenue,
  }) async {
    try {
      final dataConnectService = DataConnectService();
      String? finalSessionId = sessionId;

      if (createNewSession && unitId != null && movieId != null) {
        final dateParts = sessionDateStr!.split('/');
        final hourParts = sessionHourStr!.split(':');
        final sessionDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
        final sessionHour = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
          int.parse(hourParts[0]),
          int.parse(hourParts[1]),
        );

        finalSessionId = await dataConnectService.createSession(
          movieId: movieId,
          unitId: unitId,
          sessionDate: sessionDate,
          sessionHour: sessionHour,
          ticketsSold: sessionTickets,
          netValue: sessionRevenue,
        );

        if (finalSessionId == null) {
          throw Exception('Falha ao criar sessão');
        }
      }

      if (finalSessionId == null) {
        throw Exception('Sessão não selecionada');
      }

      final saleId = await dataConnectService.createSale(
        productId: productId,
        sessionId: finalSessionId,
        saleDate: DateTime.now(),
        quantity: quantity,
        netValue: revenue,
      );

      if (saleId == null) {
        throw Exception('Falha ao criar venda');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Venda registrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadProducts();
        _loadSessions();
        // Notifica a tela de filmes para recarregar o ranking
        // (será atualizado quando o usuário voltar para a tela de filmes)
      }
    } catch (e) {
      debugPrint('Erro ao registrar venda: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar venda: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              _buildRankingSection(),
              const SizedBox(height: 24),
              CineButtonComponente(
                text: 'Registrar Venda',
                onPressed: _showSaleDialog,
              ),
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
                  DropdownMenuItem(value: 'Combo', child: Text('Combo')),
                  DropdownMenuItem(value: 'Promoção', child: Text('Promoção')),
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
