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
import 'resultados_simple.dart';
import 'tutorial_juego_1.dart';
import 'tutorial_juego_2.dart';
import 'tutorial_juego_3.dart';
import 'tutorial_juego_4.dart';
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
    final preferences = currentUser?.preferences;
    final touchGameColor =
        _colorFromHex(preferences?.touchGameColor, Colors.blue);
    final sortGameColor =
        _colorFromHex(preferences?.sortGameColor, Colors.green);
    final shareGameColor =
        _colorFromHex(preferences?.shareGameColor, Colors.orange);
    final subtractGameColor =
        _colorFromHex(preferences?.subtractGameColor, Colors.purple);
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
                  builder: (_) => const ResultadosSimpleScreen(),
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
          if (currentUser != null &&
              currentUser.preferences.canCustomize)
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
                        'assets/images/avatar${(currentUser.avatarIndex % 6) + 0}.jpg',
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
                    icon: Icons.touch_app,
                    label: 'Toca el número',
                    color: touchGameColor,
                    onTap: () => _handleNumberGameTap(context, appService),
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.sort,
                    label: 'Ordena los números',
                    color: sortGameColor,
                    onTap: () => _handleSortGameTap(context, appService),
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.share,
                    label: 'Reparte los números',
                    color: shareGameColor,
                    onTap: () => _handleEqualShareGameTap(context, appService),
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.balance,
                    label: 'Deja el mismo número',
                    color: subtractGameColor,
                    onTap: () => _handleEqualSubtractionGameTap(context, appService),
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
        required IconData icon,
        required String label,
        required Color color,
        VoidCallback? onTap,
      }) {
    // final prefs = PreferenceProvider.of(context);
    final appService = AppService();
    final titleFontFamily = appService.fontFamilyWithFallback();
    final baseFontSize = appService.fontSizeWithFallback();
    final size = MediaQuery.of(context).size;
    final buttonPadding = size.width * 0.015;
    final iconSize = size.width * 0.055;
    final iconPadding = size.width * 0.02;
    
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

  void _handleNumberGameTap(BuildContext context, AppService appService) {
    final user = appService.currentUser;
    final shouldShowTutorial = user?.preferences.showTutorialJuego1 ?? true;

    if (shouldShowTutorial) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const TutorialJuego1Screen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        buildAccessibleFadeRoute(
          context: context,
          page: const NumberScreen(),
        ),
      );
    }
  }

  void _handleSortGameTap(BuildContext context, AppService appService) {
    final user = appService.currentUser;
    final shouldShowTutorial = user?.preferences.showTutorialJuego2 ?? true;

    if (shouldShowTutorial) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const TutorialJuego2Screen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        buildAccessibleFadeRoute(
          context: context,
          page: const SortNumbersGame(),
        ),
      );
    }
  }

  void _handleEqualShareGameTap(BuildContext context, AppService appService) {
    final user = appService.currentUser;
    final shouldShowTutorial = user?.preferences.showTutorialJuego3 ?? true;

    if (shouldShowTutorial) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const TutorialJuego3Screen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        buildAccessibleFadeRoute(
          context: context,
          page: const EqualShareScreen(),
        ),
      );
    }
  }

  void _handleEqualSubtractionGameTap(BuildContext context, AppService appService) {
    final user = appService.currentUser;
    final shouldShowTutorial = user?.preferences.showTutorialJuego4 ?? true;

    if (shouldShowTutorial) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const TutorialJuego4Screen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        buildAccessibleFadeRoute(
          context: context,
          page: const EqualSubtractionScreen(),
        ),
      );
    }
  }

  Color _colorFromHex(String? value, Color fallback) {
    if (value == null) return fallback;
    final parsed = int.tryParse(value);
    if (parsed == null) return fallback;
    return Color(parsed);
  }
}
