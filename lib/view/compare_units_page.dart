// Tela de Filmes
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../service/firebase/data_connect_service.dart';

class CompareUnitsPage extends StatefulWidget {
  const CompareUnitsPage({super.key});

  @override
  State<CompareUnitsPage> createState() => _CompareUnitsPageState();
}

class _CompareUnitsPageState extends State<CompareUnitsPage> {
  final DataConnectService _service = DataConnectService();

  List<String> _units = [];
  String? _selectedUnit1;
  String? _selectedUnit2;
  bool _isLoading = true;

  final Map<String, double> rendaTickets = {'Unidade A': 75, 'Unidade B': 55};
  final Map<String, double> rendaPipoca = {'Unidade A': 60, 'Unidade B': 85};
  final Map<String, double> ocupacaoMedia = {'Unidade A': 70, 'Unidade B': 90};
  final Map<String, double> preferenciaGenero = {'Ação': 65, 'Comédia': 35};
  final Map<String, double> preferenciaAcao = {
    'Unidade A': 45,
    'Unidade B': 55,
  };
  final Map<String, double> preferenciaComedia = {
    'Unidade A': 70,
    'Unidade B': 30,
  };

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    try {
      final unitsData = await _service.getUnitsForCurrentManager();
      final names = unitsData
          .map((unit) => (unit['name'] as String?)?.trim())
          .whereType<String>()
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();

      if (names.isEmpty) {
        names.addAll(['Unidade A', 'Unidade B']);
      }

      setState(() {
        _units = names;
        _selectedUnit1 = names.isNotEmpty ? names[0] : null;
        _selectedUnit2 = names.length > 1 ? names[1] : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _units = ['Unidade A', 'Unidade B'];
        _selectedUnit1 = 'Unidade A';
        _selectedUnit2 = 'Unidade B';
        _isLoading = false;
      });
    }
  }

  double _metricForUnit(Map<String, double> metrics, String unit) {
    if (metrics.containsKey(unit)) return metrics[unit]!;
    final hash = unit.hashCode.abs();
    return 40 + (hash % 61); // range between 40 and 100
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF9B0000)),
        ),
      );
    }

    final hasTwoUnits = _selectedUnit1 != null && _selectedUnit2 != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comparar Unidades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_units.length >= 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUnitDropdown('Unidade 1', _selectedUnit1!, (value) {
                    if (value == null) return;
                    setState(() => _selectedUnit1 = value);
                  }),
                  _buildUnitDropdown('Unidade 2', _selectedUnit2!, (value) {
                    if (value == null) return;
                    setState(() => _selectedUnit2 = value);
                  }),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  'Cadastre pelo menos duas unidades para comparar.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: hasTwoUnits
                  ? ListView(
                      children: [
                        _buildComparisonCard(
                          title: 'Renda de Tickets (%)',
                          color1: Colors.red,
                          color2: Colors.white,
                          value1: _metricForUnit(rendaTickets, _selectedUnit1!),
                          value2: _metricForUnit(rendaTickets, _selectedUnit2!),
                        ),
                        _buildComparisonCard(
                          title: 'Renda em Pipoca (%)',
                          color1: Colors.red,
                          color2: Colors.white,
                          value1: _metricForUnit(rendaPipoca, _selectedUnit1!),
                          value2: _metricForUnit(rendaPipoca, _selectedUnit2!),
                        ),
                        _buildComparisonCard(
                          title: 'Ocupação Média (%)',
                          color1: Colors.red,
                          color2: Colors.white,
                          value1: _metricForUnit(
                            ocupacaoMedia,
                            _selectedUnit1!,
                          ),
                          value2: _metricForUnit(
                            ocupacaoMedia,
                            _selectedUnit2!,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Gênero Preferido (em % de público)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildGenreChart(),
                        const SizedBox(height: 8),
                        _buildComparisonCard(
                          title: 'Ação (%)',
                          color1: Colors.red,
                          color2: Colors.white,
                          value1: _metricForUnit(
                            preferenciaAcao,
                            _selectedUnit1!,
                          ),
                          value2: _metricForUnit(
                            preferenciaAcao,
                            _selectedUnit2!,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildComparisonCard(
                          title: 'Comédia (%)',
                          color1: Colors.red,
                          color2: Colors.white,
                          value1: _metricForUnit(
                            preferenciaComedia,
                            _selectedUnit1!,
                          ),
                          value2: _metricForUnit(
                            preferenciaComedia,
                            _selectedUnit2!,
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'Selecione duas unidades para comparar.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(
    String label,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButton<String>(
          value: selected,
          items: _units
              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required Color color1,
    required Color color2,
    required double value1,
    required double value2,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: value1,
                          color: color1,
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: value2,
                          color: color2,
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _legend(color1, _selectedUnit1 ?? ''),
                _legend(color2, _selectedUnit2 ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChart() {
    return Column(
      children: preferenciaGenero.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: e.value,
                height: 14,
                child: Container(color: Colors.red),
              ),
              const SizedBox(width: 8),
              Text('${e.key} (${e.value.toStringAsFixed(0)}%)'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
