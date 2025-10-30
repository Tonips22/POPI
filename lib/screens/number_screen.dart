import 'package:flutter/material.dart';
import '../widget/number_circle.dart';

class NumberScreen extends StatelessWidget {
  const NumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fila con los tres círculos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              NumberCircle(number: 2),
              NumberCircle(number: 1),
              NumberCircle(number: 3),
            ],
          ),
          const SizedBox(height: 60),
          // Botón del altavoz
          IconButton(
            iconSize: 60,
            color: Colors.black,
            onPressed: () {
              // Acción futura
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.volume_up),
            ),
          ),
        ],
      ),
    );
  }
}
