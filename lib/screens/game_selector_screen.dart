import 'package:flutter/material.dart' hide Text;
import '../widgets/voice_text.dart';
import 'number_screen.dart';
import 'sort_numbers_game.dart';
import 'equal_share_screen.dart';
import 'equal_subtraction_screen.dart';
import 'customization_screen.dart';
import '../utils/accessible_routes.dart';
import '../services/app_service.dart';
import 'login_screen.dart';
import 'resultados.dart';
// import '../widgets/voice_text.dart';
// import '../widgets/preference_provider.dart';


class ChooseGameScreen extends StatefulWidget {
  const ChooseGameScreen({super.key});

  @override
  State<ChooseGameScreen> createState() => _ChooseGameScreenState();
}

class _ChooseGameScreenState extends State<ChooseGameScreen> {
  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final appService = AppService();
    final currentUser = appService.currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.white;
    final titleFontSize = appService.fontSizeWithFallback();
    final titleFontFamily = appService.fontFamilyWithFallback();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Juegos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize * 1.6,
            fontFamily: titleFontFamily,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppService().logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Resultados',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ResultadosScreen(),
                ),
              );
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'R',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomizationScreen(),
                    ),
                  );
                  // Actualizar la pantalla cuando se regrese de personalización
                  setState(() {});
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar${(currentUser.avatarIndex % 6) + 0}.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2596BE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: availableHeight * 0.05,
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: availableHeight * 0.02,
                childAspectRatio: (screenWidth * 0.4) / (availableHeight * 0.35),
                children: [
                  _buildGameButton(
                    context,
                    imagePath: 'images/games/touch_game.png',
                    label: 'Toca el número',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        buildAccessibleFadeRoute(
                          context: context,
                          page: const NumberScreen(),
                        ),
                      );
                    },
                  ),
                  _buildGameButton(
                    context,
                    imagePath: 'images/games/sort_name.png',
                    label: 'Ordena los números',
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        buildAccessibleFadeRoute(
                          context: context,
                          page: const SortNumbersGame(),
                        ),
                      );
                    },
                  ),
                  _buildGameButton(
                    context,
                    imagePath: 'images/games/sum_game.png',
                    label: 'Reparte los números',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(
                        buildAccessibleFadeRoute(
                          context: context,
                          page: const EqualShareScreen(),
                        ),
                      );
                    },
                  ),
                  _buildGameButton(
                    context,
                    imagePath: 'images/games/rest_game.png',
                    label: 'Deja el mismo número',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        buildAccessibleFadeRoute(
                          context: context,
                          page: const EqualSubtractionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameButton(
      BuildContext context, {
        required String imagePath,
        required String label,
        required Color color,
        VoidCallback? onTap,
      }) {
    // final prefs = PreferenceProvider.of(context);
    final appService = AppService();
    final titleFontFamily = appService.fontFamilyWithFallback();
    final baseFontSize = appService.fontSizeWithFallback();
    final size = MediaQuery.of(context).size;
    final buttonPadding = size.width * 0.01;
    final imageSize = size.width * 0.12;
    
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen del juego redondeada sin fondo blanco
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.gamepad,
                        size: imageSize * 0.6,
                        color: color,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.008),
              // Texto del juego
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: baseFontSize * 0.9,
                    fontFamily: titleFontFamily,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
