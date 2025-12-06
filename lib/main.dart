import 'package:flutter/material.dart';
import 'package:popi/screens/home_tutor_screen.dart';
import 'screens/login_screen.dart';
import 'services/app_service.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppService _appService = AppService();

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el usuario para actualizar el tema
    _appService.userChangeNotifier.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _appService.userChangeNotifier.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {
      // Forzar reconstrucción del MaterialApp con el nuevo color
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el color primario del usuario logueado
    final currentUser = _appService.currentUser;
    final primaryColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.primaryColor))
        : Colors.blue.shade400;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}