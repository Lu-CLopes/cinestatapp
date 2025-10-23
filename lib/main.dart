import 'dart:developer';

import 'package:cinestatapp/my_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  log("Starting app");
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verificar se Firebase já foi inicializado
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    log("Firebase initialized successfully");
  } catch (e) {
    log("Firebase already initialized or error: $e");
  }
  
  runApp(const MyApp());
}
