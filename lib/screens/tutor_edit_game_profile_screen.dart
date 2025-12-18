import 'package:flutter/material.dart';
import 'package:popi/screens/tutor_edit_game_profile_dejar.dart';
import 'package:popi/screens/tutor_edit_game_profile_reparte.dart';
import 'package:popi/screens/tutor_edit_game_profile_tocar.dart';
import 'package:popi/screens/tutor_edit_game_profile_ordenar.dart';

import 'home_tutor_screen.dart';
// import '../widgets/preference_provider.dart';

class TutorChooseGameScreen extends StatelessWidget {
  final String studentId;      // ✅ NUEVO
  final String studentName;
  final String avatarPath;

  const TutorChooseGameScreen({
    super.key,
    required this.studentId,   // ✅ NUEVO
    required this.studentName,
    required this.avatarPath,
  });


  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight -
        kToolbarHeight -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // === CABECERA TUTOR + ALUMNO ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF71B1FF),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const TutorHomeScreen()),
                      );
                    },
                  ),



                  CircleAvatar(
                    backgroundImage: AssetImage(avatarPath),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      studentName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.black),
                ],
              ),
            ),


            const SizedBox(height: 12),

            // === GRID DE JUEGOS ===
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: availableHeight * 0.02,
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.02,
                        mainAxisSpacing: availableHeight * 0.02,
                        childAspectRatio:
                        (screenWidth * 0.4) / (availableHeight * 0.35),
                        children: [
                          _buildGameButton(
                            context,
                            icon: Icons.touch_app,
                            label: 'Toca el número',
                            color: Colors.blue,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorEditGameProfileTocar(
                                    studentId: studentId,
                                    studentName: studentName,
                                    avatarPath: avatarPath,
                                  ),
                                ),
                              );

                              if (result == true && context.mounted) {
                                // Cambios guardados → mandar al HomeTutor
                                Navigator.pop(context,true);
                              }


                            },
                          ),

                          _buildGameButton(
                            context,
                            icon: Icons.sort,
                            label: 'Ordena los números',
                            color: Colors.green,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorEditGameProfileOrdenar(
                                    studentId: studentId,
                                    studentName: studentName,
                                    avatarPath: avatarPath,
                                  ),
                                ),
                              );

                              if (result == true && context.mounted) {
                                // Cambios guardados → mandar al HomeTutor
                                Navigator.pop(context,true);
                              }


                            },
                          ),

                          _buildGameButton(
                            context,
                            icon: Icons.share,
                            label: 'Reparte los números',
                            color: Colors.orange,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorEditGameProfileReparte(
                                    studentId: studentId,
                                    studentName: studentName,
                                    avatarPath: avatarPath,
                                  ),
                                ),
                              );

                              if (result == true && context.mounted) {
                                // Cambios guardados → mandar al HomeTutor
                                Navigator.pop(context,true);
                              }


                              },
                          ),

                          _buildGameButton(
                            context,
                            icon: Icons.balance,
                            label: 'Deja el mismo número',
                            color: Colors.purple,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TutorEditGameProfileDejar(
                                    studentId: studentId,
                                    studentName: studentName,
                                    avatarPath: avatarPath,
                                  ),
                                ),
                              );

                              if (result == true && context.mounted) {
                                // Cambios guardados → mandar al HomeTutor
                                Navigator.pop(context);
                              }


                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        VoidCallback? onTap,
      }) {
    final size = MediaQuery.of(context).size;
    final buttonPadding = size.width * 0.015;
    final iconSize = size.width * 0.055;
    final iconPadding = size.width * 0.02;
    final fontSize = size.width * 0.022;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(buttonPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón circular con icono blanco
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(iconPadding),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Texto del juego
              Builder(
                builder: (context) {
                  // final prefs = PreferenceProvider.of(context);
                  return Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
