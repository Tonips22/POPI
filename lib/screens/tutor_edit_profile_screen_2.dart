import 'package:flutter/material.dart';
import 'package:popi/screens/home_tutor_screen.dart';

class TutorEditProfileScreen2 extends StatefulWidget {
  final String studentName;
  final String avatarPath;

  const TutorEditProfileScreen2({
    super.key,
    required this.studentName,
    required this.avatarPath,
  });

  @override
  State<TutorEditProfileScreen2> createState() => _TutorEditProfileScreen2State();
}

class _TutorEditProfileScreen2State extends State<TutorEditProfileScreen2> {
  Color primaryColor = Colors.blue;
  Color secondaryColor = Colors.green;
  Color backgroundColor = Colors.white;
  String selectedFont = 'Roboto';
  double textSize = 14;

  final List<String> fonts = [
    'Roboto',
    'ComicNeue',
    'OpenDyslexic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "TUTOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.more_vert, size: 18, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            // Cabecera del alumno
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFAAD2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.avatarPath),
                    radius: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.studentName.toUpperCase(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Sección colores
            _buildSectionContainer(
              title: 'Colores',
              child: Column(
                children: [
                  _buildColorSelector('Primario', primaryColor, () async {
                    Color? c = await _pickColor(context, primaryColor);
                    if (c != null) setState(() => primaryColor = c);
                  }),
                  const SizedBox(height: 4),
                  _buildColorSelector('Secundario', secondaryColor, () async {
                    Color? c = await _pickColor(context, secondaryColor);
                    if (c != null) setState(() => secondaryColor = c);
                  }),
                  const SizedBox(height: 4),
                  _buildColorSelector('Fondo', backgroundColor, () async {
                    Color? c = await _pickColor(context, backgroundColor);
                    if (c != null) setState(() => backgroundColor = c);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Sección tipografía
            _buildSectionContainer(
              title: 'Tipografía',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fuente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  DropdownButton<String>(
                    value: selectedFont,
                    isExpanded: true,
                    items: fonts.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(
                          f == 'Roboto' ? 'Predeterminada' : f == 'ComicNeue' ? 'Amigable' : 'Lectura Fácil',
                          style: TextStyle(fontSize: 12, fontFamily: f, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedFont = v!),
                  ),
                  const SizedBox(height: 4),
                  const Text('Tamaño', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Slider(
                    value: textSize,
                    min: 10,
                    max: 20,
                    divisions: 10,
                    label: textSize.round().toString(),
                    onChanged: (v) => setState(() => textSize = v),
                  ),
                  Center(
                    child: Text(
                      'Vista previa',
                      style: TextStyle(fontSize: textSize, fontFamily: selectedFont, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TutorHomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: const Color(0xFF5CA7FF),
                  ),
                  child: const Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(String label, Color color, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Future<Color?> _pickColor(BuildContext context, Color initialColor) async {
    List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.pink, Colors.teal, Colors.yellow];
    return await showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selecciona un color'),
        content: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, c),
              child: Container(width: 24, height: 24, decoration: BoxDecoration(color: c, border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4))),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFF5CA7FF), borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const Divider(color: Colors.black, height: 6, thickness: 1),
          child,
        ],
      ),
    );
  }
}
