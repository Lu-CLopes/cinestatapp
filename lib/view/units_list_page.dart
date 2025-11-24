import 'package:flutter/material.dart';

import '../service/firebase/data_connect_service.dart';
import 'audience_page.dart';
import 'compare_units_page.dart';
import 'unit_page.dart';

class UnitsListPage extends StatefulWidget {
  const UnitsListPage({super.key});

  @override
  State<UnitsListPage> createState() => _UnitsListPageState();
}

class _UnitsListPageState extends State<UnitsListPage> {
  final DataConnectService _service = DataConnectService();

  bool _isLoading = true;
  bool _isDeleting = false;
  List<Map<String, dynamic>> _units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    setState(() => _isLoading = true);
    final units = await _service.getUnitsForCurrentManager();
    if (!mounted) return;
    setState(() {
      _units = units;
      _isLoading = false;
    });
  }

  Future<void> _deleteUnit(String unitId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir unidade'),
        content: const Text('Tem certeza que deseja excluir esta unidade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);
    final deleted = await _service.deleteUnit(unitId);
    if (!mounted) return;
    setState(() => _isDeleting = false);

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unidade excluída com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadUnits();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a unidade'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToCreateUnit() {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const UnidadePage()),
    ).then((created) {
      if (created == true) {
        _loadUnits();
      }
    });
  }

  void _navigateToAudience(String unitId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AudiencePage(initialUnitId: unitId)),
    );
  }

  void _navigateToCompare() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CompareUnitsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Unidades Cadastradas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_graph),
            tooltip: 'Comparar unidades',
            onPressed: _units.isEmpty ? null : _navigateToCompare,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9B0000),
        onPressed: _navigateToCreateUnit,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUnits,
        color: const Color(0xFF9B0000),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF9B0000)),
              )
            : _units.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Icon(Icons.location_off, color: Colors.white70, size: 64),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Nenhuma unidade cadastrada ainda.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Use o botão "+" para adicionar uma nova unidade.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: _units.length,
                separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final unit = _units[index];
                  final active = unit['active'] == true;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[850]!),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      title: Text(
                        unit['name'] as String? ?? 'Unidade',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            unit['local'] as String? ?? 'Local não informado',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Capacidade: ${unit['capacity'] ?? '-'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                active ? Icons.check_circle : Icons.cancel,
                                color: active ? Colors.green : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                active ? 'Ativa' : 'Inativa',
                                style: TextStyle(
                                  color: active ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: _isDeleting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 'audience':
                                    _navigateToAudience(unit['id'] as String);
                                    break;
                                  case 'delete':
                                    _deleteUnit(unit['id'] as String);
                                    break;
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'audience',
                                  child: Text('Ver público'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
