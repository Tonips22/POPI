import 'package:flutter/material.dart';
import 'create_profile_screen_2.dart';
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  int? _selectedImageIndex;

  // 16 imágenes disponibles
  final List<String> _imagePaths = List.generate(
    16,
        (index) => 'assets/images/avatar${(index % 4) + 1}.png',
  );

  // Tamaño forzado de cada avatar (cambia aquí si quieres otro tamaño)
  static const double itemSize = 90.0;
  static const double spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    // Anchura total para 8 columnas (8 items y 7 espacios entre ellos)
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Datos identificativos
              _buildSectionContainer(
                title: 'Datos identificativos del alumno',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Nombre del alumno',
                            hint: 'Introduce nombre del alumno',
                            controller: _nameController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            label: 'Edad del alumno',
                            hint: 'Introduce edad del alumno',
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Imagen de perfil
              _buildSectionContainer(
                title: 'Imagen de perfil',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imágenes disponibles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Contenedor con desplazamiento horizontal si hace falta
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalWidth,
                        // Wrap organiza los items en varias filas según el ancho fijo
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: List.generate(_imagePaths.length, (index) {
                            final bool selected = _selectedImageIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImageIndex = index;
                                });
                              },
                              child: Container(
                                width: itemSize,
                                height: itemSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(
                                    color: selected ? Colors.black : Colors.grey,
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

                    const SizedBox(height: 16),

                    // Imagen seleccionada + borrar (mismo tamaño que itemSize)
                    Row(
                      children: [
                        const Text(
                          'Imagen seleccionada:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: itemSize,
                          height: itemSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(6),
                            image: _selectedImageIndex != null
                                ? DecorationImage(
                              image: AssetImage(
                                  _imagePaths[_selectedImageIndex!]),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black87),
                          onPressed: () {
                            setState(() {
                              _selectedImageIndex = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Botones
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
                        MaterialPageRoute(builder: (_) => const CreateProfileScreen2()),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const Divider(color: Colors.black),
          child,
        ],
      ),
    );
  }
}
