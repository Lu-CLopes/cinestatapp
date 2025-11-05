//import 'package:cinestatapp/dataconnect_generated/example.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/firebase/data_connect_service.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final local_db.AppDatabase _db;
  //LoginController(this._db);

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<String> checkUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user != null) {
        log('User validated');
        
        // Sincronizar usuário com backend (cria se não existir)
        final dataConnectService = DataConnectService();
        final synced = await dataConnectService.syncUserWithBackend();
        
        if (synced) {
          // Se o usuário tem email, tenta buscar por email (mais confiável)
          if (user.email != null) {
            final userData = await dataConnectService.getUserDataByEmail(user.email!);
            if (userData != null) {
              log('Dados do usuário do backend: ${userData.toString()}');
            }
          }
        }

        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      log('Erro de Login: ${e.message}'); // if not validated we send an error
    }

    return "-1";
  }
}
