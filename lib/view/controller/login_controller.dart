//import 'package:cinestatapp/dataconnect_generated/example.dart';
import 'dart:developer';
import 'package:cinestatapp/dataconnect_generated/example.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final dataConnect = FirebaseDataConnect.instanceFor(
  //   connectorConfig: ExampleConnector.connectorConfig,
  // );
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

        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      log('Erro de Login: ${e.message}'); // if not validated we send an error
    }

    return "-1";
  }
}
