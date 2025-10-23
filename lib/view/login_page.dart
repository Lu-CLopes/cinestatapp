import 'package:cinestatapp/components/widgets/cine_button_componente.dart';
import 'package:cinestatapp/view/controller/login_controller.dart';
import 'package:flutter/material.dart';
import '../wave_clipper.dart'; // Importando o clipper

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // Adicionado para evitar overflow com teclado
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
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
              Image.asset('assets/images/img.png', height: 120),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller.emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        filled: true,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'E-mail',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _controller.passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        filled: true,
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Senha',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child:
CineButtonComponente(text: 'Login', onPressed: () async {
                // Validar email antes de tentar login
                final email = _controller.emailController.text.trim();
                final password = _controller.passwordController.text.trim();
                
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos'),  
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (!email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um email válido'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final uid = await _controller.checkUser();
                if (uid != "-1") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login realizado com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Navegar para a tela principal
                  Navigator.pushReplacementNamed(context, '/main');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email e/ou senha incorretos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
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
