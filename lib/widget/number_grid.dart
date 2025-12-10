import 'package:flutter/material.dart';
import '../logic/game_controller.dart';

class NumberGrid extends StatelessWidget {
  final GameController controller;
  final Function(bool) onAnswer;
  final Color primaryColor;
  final String shape;

  const NumberGrid({
    super.key,
    required this.controller,
    required this.onAnswer,
    required this.primaryColor,
    this.shape = 'circle',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final count = controller.currentNumbers.length;

        int columns = (count <= 3)
            ? count
            : (count <= 4)
            ? 2
            : (count <= 6)
            ? 3
            : (count <= 9)
            ? 3
            : 4;
        int rows = (count / columns).ceil();

        final circleSizeW = (maxWidth / columns) * 0.85;
        final circleSizeH = (maxHeight / rows) * 0.85;
        double circleSize = circleSizeW < circleSizeH ? circleSizeW : circleSizeH;

        const double maxCircleSize = 100;
        if (circleSize > maxCircleSize) {
          circleSize = maxCircleSize;
        }

        final spacingX = (maxWidth - (circleSize * columns)) / (columns + 1);
        final spacingY = (maxHeight - (circleSize * rows)) / (rows + 1);

        final children = <Widget>[];
        int index = 0;
        for (int r = 0; r < rows; r++) {
          final rowChildren = <Widget>[];
          for (int c = 0; c < columns; c++) {
            if (index < count) {
              final num = controller.currentNumbers[index];
              rowChildren.add(
                GestureDetector(
                  onTap: () {
                    bool isCorrect = controller.checkAnswer(num);
                    onAnswer(isCorrect);
                  },
                  child: ClipPath(
                    clipper: shape == 'triangle' ? TriangleClipper() : null,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius: shape == 'square' ? BorderRadius.circular(16) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$num',
                          style: TextStyle(
                            fontSize: circleSize * 0.45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              index++;
            } else {
              rowChildren.add(SizedBox(width: circleSize, height: circleSize));
            }
          }

          children.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacingY / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int c = 0; c < rowChildren.length; c++) ...[
                    if (c > 0) SizedBox(width: spacingX),
                    rowChildren[c],
                  ],
                ],
              ),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}

/// CustomClipper para crear triángulos
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0); // Punto superior (centro arriba)
    path.lineTo(size.width, size.height); // Esquina inferior derecha
    path.lineTo(0, size.height); // Esquina inferior izquierda
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}