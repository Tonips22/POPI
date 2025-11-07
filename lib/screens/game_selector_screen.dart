import 'package:flutter/material.dart';
import 'number_screen.dart';

class ChooseGameScreen extends StatelessWidget {
  const ChooseGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Elige un juego',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2,
            children: [
              _buildGameButton(
                context,
                icon: Icons.send,
                label: 'Toca el número',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NumberScreen()),
                  );
                },
              ),
              _buildGameButton(
                context,
                icon: Icons.open_with,
                label: 'Ordena los números',
                onTap: () {},
              ),
              _buildGameButton(
                context,
                icon: Icons.calculate,
                label: 'Reparte los números',
                onTap: () {},
              ),
              _buildGameButton(
                context,
                icon: Icons.compare_arrows,
                label: 'Deja el mismo número',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        VoidCallback? onTap,
      }) {
    const Color buttonBlue = Color(0xFF5CA7FF);

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        elevation: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 56,
            child: Icon(icon, size: 48, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 42,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
