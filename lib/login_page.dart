
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'wave_clipper.dart'; // Importando o clipper

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (!mounted) return;
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // TODO: Navegar para a tela principal do app após login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Adicionado para evitar overflow com teclado
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: const Color(0xFF9B0000),
                  height: 80, // Altura menor na tela de login
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/img.png',
                height: 180,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        filled: true,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'E-mail',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        filled: true,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Senha',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  onPressed: _login,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.red,
                     minimumSize: const Size(double.infinity, 50),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30),
                     ),
                   ),
                  child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar', style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ),
              const Spacer(flex: 2),
              ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  color: const Color(0xFF9B0000),
                  height: 80, // Altura menor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
