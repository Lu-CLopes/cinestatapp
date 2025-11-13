import 'package:flutter/material.dart';

import 'compare_units_page.dart';
import 'unit_page.dart';
import 'units_list_page.dart';

const double _cardHeight = 160;

class HomeUnitsPage extends StatelessWidget {
  const HomeUnitsPage({super.key});

  void _navigateToCompare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CompareUnitsPage()),
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UnidadePage()),
    );
  }

  void _navigateToUnitsList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UnitsListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestão de Unidades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOptionCard(
                  context,
                  icon: Icons.auto_graph,
                  title: 'Comparar Unidades',
                  description: 'Estatísticas comparativas',
                  color: Colors.red,
                  onTap: () => _navigateToCompare(context),
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  context,
                  icon: Icons.add_business,
                  title: 'Cadastrar Unidade',
                  description: 'Adicione novas unidades',
                  color: Colors.red,
                  onTap: () => _navigateToRegister(context),
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  context,
                  icon: Icons.store_mall_directory,
                  title: 'Ver Unidades',
                  description: 'Visualize unidades cadastradas',
                  color: Colors.red,
                  onTap: () => _navigateToUnitsList(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildOptionCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String description,
  required Color color,
  required VoidCallback onTap,
}) {
  return SizedBox(
    height: _cardHeight,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}
