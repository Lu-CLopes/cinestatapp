// Tela de Filmes
import 'package:flutter/material.dart';
import '../components/widgets/cine_button_componente.dart';
import '../service/firebase/data_connect_service.dart';
import 'package:fl_chart/fl_chart.dart';

class CompareUnitsPage extends StatefulWidget {
  const CompareUnitsPage({super.key});

  @override
  State<CompareUnitsPage> createState() => _CompareUnitsPageState();
}

class _CompareUnitsPageState extends State<CompareUnitsPage> {
  // Unidades simuladas
  final List<String> units = ['Unidade A', 'Unidade B'];

  String? selectedUnit1;
  String? selectedUnit2;

  // Dados simulados
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
    selectedUnit1 = units[0];
    selectedUnit2 = units[1];
  }

  @override
  Widget build(BuildContext context) {
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
            // Dropdowns para selecionar unidades
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUnitDropdown('Unidade 1', selectedUnit1!, (value) {
                  setState(() => selectedUnit1 = value);
                }),
                _buildUnitDropdown('Unidade 2', selectedUnit2!, (value) {
                  setState(() => selectedUnit2 = value);
                }),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildComparisonCard(
                    title: 'Renda de Tickets (%)',
                    color1: Colors.red,
                    color2: Colors.white,
                    value1: rendaTickets[selectedUnit1]!,
                    value2: rendaTickets[selectedUnit2]!,
                  ),
                  _buildComparisonCard(
                    title: 'Renda em Pipoca (%)',
                    color1: Colors.red,
                    color2: Colors.white,
                    value1: rendaPipoca[selectedUnit1]!,
                    value2: rendaPipoca[selectedUnit2]!,
                  ),
                  _buildComparisonCard(
                    title: 'Ocupação Média (%)',
                    color1: Colors.red,
                    color2: Colors.white,
                    value1: ocupacaoMedia[selectedUnit1]!,
                    value2: ocupacaoMedia[selectedUnit2]!,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Gênero Preferido (em % de público)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildGenreChart(),
                  const SizedBox(height: 8),
                  _buildComparisonCard(
                    title: 'Acao (%)',
                    color1: Colors.red,
                    color2: Colors.white,
                    value1: preferenciaAcao[selectedUnit1]!,
                    value2: preferenciaAcao[selectedUnit2]!,
                  ),
                  const SizedBox(height: 8),
                  _buildComparisonCard(
                    title: 'Comédia (%)',
                    color1: Colors.red,
                    color2: Colors.white,
                    value1: preferenciaComedia[selectedUnit1]!,
                    value2: preferenciaComedia[selectedUnit2]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown para selecionar unidades
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
          items: units
              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Card com gráfico de barras horizontais
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
                _legend(color1, selectedUnit1!),
                _legend(color2, selectedUnit2!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Pequeno gráfico de gênero
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

  // Legenda com cor + nome
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
