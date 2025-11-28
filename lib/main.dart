import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'widgets/preference_provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // generado por FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones generadas (multi-plataforma)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolvemos toda la app con PreferenceLoader
    return PreferenceLoader(
      userId: 'demo', // Usuario demo por defecto
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}