import 'package:flutter/material.dart';

class NumberCircle extends StatelessWidget {
  final int number;

  const NumberCircle({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
