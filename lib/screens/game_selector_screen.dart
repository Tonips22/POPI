import 'package:flutter/material.dart';
import 'number_screen.dart';
import 'sort_numbers_game.dart';
import '../widgets/preference_provider.dart';

class ChooseGameScreen extends StatelessWidget {
  const ChooseGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenceProvider.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Juegos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (prefs?.getFontSizeValue() ?? 18.0) * 1.5,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NumberScreen()),
                      );
                    },
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.sort,
                    label: 'Ordena los números',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SortNumbersGame()),
                      );
                    },
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.share,
                    label: 'Reparte los números',
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Implementar juego
                    },
                  ),
                  _buildGameButton(
                    context,
                    icon: Icons.balance,
                    label: 'Deja el mismo número',
                    color: Colors.purple,
                    onTap: () {
                      // TODO: Implementar juego
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
                  final prefs = PreferenceProvider.of(context);
                  return Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: prefs?.getFontSizeValue() ?? fontSize,
                      fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
