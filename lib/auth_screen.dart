
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'wave_clipper.dart'; // Importando o clipper

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column( // Removido o SafeArea para o clipper ir até o topo
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header com a nova curva
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
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: 'c', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'ine', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.theaters, // Ícone de tickets do próprio Flutter
                    color: Colors.black, // Cor preta como no design
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),

          // Imagem central
          Image.asset(
            'assets/images/img.png',
            height: 250,
          ),

          const Spacer(),

          // Botões
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar para a tela de cadastro
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Cadastrar', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),

          const Spacer(flex: 2),

          // Rodapé com a nova curva
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: const Color(0xFF9B0000),
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
