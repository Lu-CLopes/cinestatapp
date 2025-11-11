import 'package:flutter/material.dart';
import 'compare_units_page.dart';
import 'unit_page.dart';

class HomeUnitsPage extends StatefulWidget {
  //final void Function(int) onNavigate;

  const HomeUnitsPage({super.key});

  @override
  State<HomeUnitsPage> createState() => _HomeUnitsPageState();
}

class _HomeUnitsPageState extends State<HomeUnitsPage> {
  void _navigateToCompare() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CompareUnitsPage()),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnidadePage()),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildOptionCard(
                  context,
                  icon: Icons.auto_graph,
                  title: 'Comparar Unidades',
                  description: 'Estatísticas comparativas',
                  color: Colors.red,
                  onTap: () => _navigateToCompare(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOptionCard(
                  context,
                  icon: Icons.auto_graph,
                  title: 'Cadastrar Unidades',
                  description: 'Adicione suas unidades',
                  color: Colors.red,
                  onTap: () => _navigateToRegister(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
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
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
  );
}
