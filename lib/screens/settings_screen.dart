import 'package:flutter/material.dart';
import 'difficulty_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(
              context,
              'Dificultad',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionButton(context, 'Personalización'),
            const SizedBox(height: 20),
            _buildOptionButton(context, 'Accesibilidad'),
            const SizedBox(height: 40),
            IconButton(
              iconSize: 40,
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
              icon: Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label,
      {VoidCallback? onTap}) {
    return _HoverButton(
      label: label,
      onTap: onTap,
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _HoverButton({required this.label, this.onTap});

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 250,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.grey[400] : Colors.grey[300],
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: Colors.black,
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ]
                : [],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isHovered ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}