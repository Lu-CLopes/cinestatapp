import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import '../wave_clipper.dart'; // Importando o clipper
import '../components/widgets/cine_button_componente.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        // Removido o SafeArea para o clipper ir até o topo
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
          Image.asset('assets/images/img.png', height: 250),

          const Spacer(),

          // Botões
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                CineButtonComponente(
                  text: 'Login',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CineButtonComponente(
                  text: 'Cadastrar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Spacer(flex: 2),

          // Rodapé com a nova curva
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(color: const Color(0xFF9B0000), height: 100),
          ),
        ],
      ),
    );
  }
}
