import 'package:flutter/material.dart';
import 'screens/number_screen.dart';
import 'screens/game_selector_screen.dart';
import 'screens/customization_screen.dart';
import 'screens/fonts_settings_screen.dart';
import 'screens/number_format_screen.dart';
import 'screens/color_settings_screen.dart';
import 'screens/create_profile_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}