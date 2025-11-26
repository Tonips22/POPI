import 'package:flutter/material.dart';
import 'package:popi/screens/home_tutor_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/preference_provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generado por FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones generadas (multi-plataforma)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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