import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';

class UnidadePage extends StatefulWidget {
  const UnidadePage({super.key});

  @override
  State<UnidadePage> createState() => _UnidadePageState();
}

class _UnidadePageState extends State<UnidadePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _localController = TextEditingController();
  final _maxCapController = TextEditingController();

  // Valor para dropdown
  String? _selectedActive;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _localController.dispose();
    _maxCapController.dispose();
    super.dispose();
  }

  Future<void> _createUnit() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar se o usuário está logado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa estar logado para criar uma unidade. Faça login e tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final local = _localController.text.trim();
      final maxCapStr = _maxCapController.text.trim();
      final activeStr = _selectedActive ?? '';

      // Validar campos obrigatórios
      if (name.isEmpty || local.isEmpty || maxCapStr.isEmpty || activeStr.isEmpty) {
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

      // Converter capacidade máxima para int
      final maxCap = int.tryParse(maxCapStr);
      if (maxCap == null || maxCap <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Capacidade máxima deve ser um número válido'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Converter ativo para bool (dropdown retorna "Ativo" ou "Desativo")
      final active = activeStr.toLowerCase() == 'ativo';

      // Criar unidade no backend
      final dataConnectService = DataConnectService();
      final created = await dataConnectService.createUnit(
        unitName: name,
        unitLocal: local,
        unitMacCapacity: maxCap,
        unitActive: active,
      );

      if (created != null && mounted) {
        // Limpar campos após sucesso
        _nameController.clear();
        _localController.clear();
        _maxCapController.clear();
        // Resetar dropdown e formulário
        setState(() {
          _selectedActive = null;
        });
        // Resetar o formulário após limpar campos
        Future.microtask(() {
          _formKey.currentState?.reset();
        });
        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unidade criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar unidade. Verifique os dados e tente novamente. Veja o console para mais detalhes.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e, stackTrace) {
      log('Erro ao criar unidade: $e');
      log('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
                'Cadastre sua Unidade',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione sua unidade aqui',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Unidade',
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
                    return 'Digite o nome da unidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unit Local
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Local Unidade',
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
                    return 'Digite o local da unidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Max Capacity
              TextFormField(
                controller: _maxCapController,
                decoration: const InputDecoration(
                  labelText: 'Capacidade Unidade',
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
                    return 'Digite a capacidade da unidade';
                  }

                  final capacity = int.tryParse(value);
                  if (capacity == null) {
                    return 'Digite um número válido';
                  }

                  if (capacity <= 0) {
                    return 'A capacidade deve ser maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active
              // Unidade Ativa
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Unidade Ativa',
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
                value: _selectedActive,
                onChanged: (value) {
                  setState(() {
                    _selectedActive = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a situação da unidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Button to add Unit
              // Botão de Cadastro
              CineButtonComponente(
                text: 'Criar Unidade',
                onPressed: _isLoading ? () {} : _createUnit,
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
