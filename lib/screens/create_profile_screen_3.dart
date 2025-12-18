import 'package:flutter/material.dart';
import 'create_profile_screen_4.dart';
class CreateProfileScreen3 extends StatefulWidget {
  const CreateProfileScreen3({super.key});

  @override
  State<CreateProfileScreen3> createState() => _CreateProfileScreen3State();
}

class _CreateProfileScreen3State extends State<CreateProfileScreen3> {
  Color primaryColor = Colors.blue;
  Color secondaryColor = Colors.green;
  Color backgroundColor = Colors.white;
  String selectedFont = 'Roboto';
  double textSize = 18;

  final List<String> fonts = [
    'Roboto',        // Predeterminada
    'ComicNeue',     // Amigable
    'OpenDyslexic',  // Lectura fácil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferencias visuales',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === SECCIÓN COLORES ===
              _buildSectionContainer(
                title: 'Colores del perfil',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColorSelector(
                      label: 'Color primario',
                      color: primaryColor,
                      onTap: () async {
                        Color? newColor = await _pickColor(context, primaryColor);
                        if (newColor != null) setState(() => primaryColor = newColor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildColorSelector(
                      label: 'Color secundario',
                      color: secondaryColor,
                      onTap: () async {
                        Color? newColor = await _pickColor(context, secondaryColor);
                        if (newColor != null) setState(() => secondaryColor = newColor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildColorSelector(
                      label: 'Color de fondo',
                      color: backgroundColor,
                      onTap: () async {
                        Color? newColor = await _pickColor(context, backgroundColor);
                        if (newColor != null) setState(() => backgroundColor = newColor);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // === SECCIÓN TIPOGRAFÍA ===
              _buildSectionContainer(
                title: 'Tipografía del texto',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fuente del texto',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedFont,
                      isExpanded: true,
                      items: fonts.map((font) {
                        return DropdownMenuItem<String>(
                          value: font,
                          child: Text(
                            font == 'Roboto'
                                ? 'Predeterminada'
                                : font == 'ComicNeue'
                                ? 'Amigable'
                                : 'Lectura Fácil',
                            style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedFont = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tamaño del texto',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Slider(
                      value: textSize,
                      min: 10,
                      max: 30,
                      divisions: 20,
                      label: textSize.round().toString(),
                      onChanged: (value) {
                        setState(() => textSize = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Vista previa del texto',
                        style: TextStyle(
                          fontSize: textSize,
                          fontFamily: selectedFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // === BOTONES INFERIORES ===
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CA7FF),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateProfileScreen4()),
                      );
                    },
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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

  // === SELECTOR DE COLOR ===
  Widget _buildColorSelector({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // === DIÁLOGO DE COLORES ===
  Future<Color?> _pickColor(BuildContext context, Color initialColor) async {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.yellow
    ];

    return await showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selecciona un color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, c),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // === CONTENEDOR DE SECCIÓN ===
  Widget _buildSectionContainer({
    required String title,
    required Widget child,
  }) {
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const Divider(color: Colors.black),
          child,
        ],
      ),
    );
  }
}
