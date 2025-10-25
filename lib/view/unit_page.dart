import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';

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
  final _activeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _localController.dispose();
    _maxCapController.dispose();
    _activeController.dispose();
    super.dispose();
  }

  Future<void> _creteUnit() async {
    if (_formKey.currentState!.validate()) {
      // Lógica para criar a unidade de cinema
      // Você pode acessar os valores dos campos usando os controladores
      String name = _nameController.text;
      String local = _localController.text;
      String maxCap = _maxCapController.text;
      String active = _activeController.text;

      // Exemplo de exibição dos valores no console
      // print('Nome: $name');
      // print('Local: $local');
      // print('Capacidade Máxima: $maxCap');
      // print('Ativo: $active');

      // Aqui você pode adicionar a lógica para salvar os dados da unidade
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
                onChanged: (value) {
                  _activeController.text = value!;
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
                onPressed: _isLoading ? () {} : _creteUnit,
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
