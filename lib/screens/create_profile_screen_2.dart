import 'package:flutter/material.dart';
import 'create_profile_screen_3.dart';

class CreateProfileScreen2 extends StatefulWidget {
  const CreateProfileScreen2({super.key});

  @override
  State<CreateProfileScreen2> createState() => _CreateProfileScreen2State();
}

class _CreateProfileScreen2State extends State<CreateProfileScreen2> {
  final List<String> _imagePaths = List.generate(
    16,
        (index) => 'assets/images/avatar${(index % 4) + 1}.png',
  );

  // Lista de imágenes seleccionadas (para la contraseña)
  final List<int> _selectedIndexes = [];

  static const double itemSize = 90.0;
  static const double spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = 8 * itemSize + 7 * spacing;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear perfil de alumno',
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // 🔵 BLOQUE AZUL: IMÁGENES DISPONIBLES
              _buildSectionContainer(
                title: 'Inicio de sesión accesible',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pro tip: Selecciona hasta 4 animales en un orden concreto para definir la contraseña del alumno',
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Imágenes disponibles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalWidth,
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: List.generate(_imagePaths.length, (index) {
                            final bool selected =
                            _selectedIndexes.contains(index);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedIndexes.length < 4 &&
                                      !_selectedIndexes.contains(index)) {
                                    _selectedIndexes.add(index);
                                  }
                                });
                              },
                              child: Container(
                                width: itemSize,
                                height: itemSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(
                                    color: selected
                                        ? Colors.black
                                        : Colors.grey,
                                    width: selected ? 3 : 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(_imagePaths[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔵 NUEVO BLOQUE AZUL: CONTRASEÑA SELECCIONADA
              _buildSectionContainer(
                title: 'Contraseña seleccionada',
                child: Column(
                  children: [
                    Row(
                      children: [
                        ...List.generate(4, (index) {
                          return Container(
                            width: itemSize,
                            height: itemSize,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              image: index < _selectedIndexes.length
                                  ? DecorationImage(
                                image: AssetImage(_imagePaths[
                                _selectedIndexes[index]]),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black87),
                          onPressed: () {
                            setState(() {
                              if (_selectedIndexes.isNotEmpty) {
                                _selectedIndexes.removeLast();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Botones inferiores
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CA7FF),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CreateProfileScreen3()),
                      );
                    },
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 17)),
          const Divider(color: Colors.black),
          child,
        ],
      ),
    );
  }
}
