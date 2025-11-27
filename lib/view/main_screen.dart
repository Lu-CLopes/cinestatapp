import 'package:cinestatapp/view/home_filmes_page.dart';
import 'package:cinestatapp/view/home_units_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../wave_clipper.dart';
import 'pipocas_page.dart';
import 'audience_page.dart';
import 'support_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigate: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      const HomeUnitsPage(),
      const HomeFilmesPage(),
      const PipocasPage(),
      const AudiencePage(),
    ];
  }

  void _onItemTapped(int index) {
    final logoutIndex = _screens.length;
    if (index == logoutIndex) {
      // Botão Sair
      _showLogoutDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Sair', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Tem certeza que deseja sair?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Cabeçalho com onda
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: const Color(0xFF9B0000),
              height: 120,
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'c',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'ine',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.theaters, color: Colors.black, size: 40),
                ],
              ),
            ),
          ),

          // Área de conteúdo
          Expanded(
            child: _selectedIndex < _screens.length
                ? _screens[_selectedIndex]
                : _screens[0], // Fallback para Home se índice inválido
          ),
        ],
      ),

      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Unidades',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Filmes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: 'Pipocas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Público',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Sair'),
        ],
      ),
    );
  }
}

// Tela inicial (Home/Dashboard)
class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Saudação
            Text(
              'Bem-vindo${user?.displayName != null ? ", ${user!.displayName}" : ""}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // Cards de opções
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    icon: Icons.location_on,
                    title: 'Unidades',
                    description: 'Gerencie suas unidades',
                    color: Colors.red,
                    onTap: () => onNavigate(1),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOptionCard(
                    context,
                    icon: Icons.movie,
                    title: 'Filmes',
                    description: 'Cadastre filmes',
                    color: Colors.red,
                    onTap: () => onNavigate(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    icon: Icons.local_dining,
                    title: 'Pipocas',
                    description: 'Gerencie produtos',
                    color: Colors.red,
                    onTap: () => onNavigate(3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOptionCard(
                    context,
                    icon: Icons.people,
                    title: 'Audiências',
                    description: 'Gerencie o público',
                    color: Colors.red,
                    onTap: () => onNavigate(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.support_agent,
              title: 'Suporte e Contato',
              description: 'Entre em contato conosco',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
}
