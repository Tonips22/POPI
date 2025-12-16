import 'package:flutter/material.dart';
import 'package:popi/screens/tutor_edit_profile_screen_3.dart';
import '../models/user_model.dart';
import '../services/app_service.dart';

class TutorEditProfileScreen2 extends StatefulWidget {
  final UserModel student;

  const TutorEditProfileScreen2({super.key, required this.student});

  @override
  State<TutorEditProfileScreen2> createState() =>
      _TutorEditProfileScreen2State();
}

class _TutorEditProfileScreen2State extends State<TutorEditProfileScreen2> {
  final AppService _appService = AppService();

  late TextEditingController _nameController;
  late int _avatarIndex;

  // Colores
  late Color primaryColor;
  late Color secondaryColor;
  late Color backgroundColor;

  // Tipografía
  String selectedFontFamily = 'default';
  String fontSizeValue = 'default';

  final List<String> fonts = ['default', 'ComicNeue', 'OpenDyslexic'];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.student.name);
    _avatarIndex = widget.student.avatarIndex ?? 0;

    primaryColor =
        _parseColor(widget.student.preferences.primaryColor) ?? Colors.blue;
    secondaryColor =
        _parseColor(widget.student.preferences.secondaryColor) ?? Colors.green;
    backgroundColor =
        _parseColor(widget.student.preferences.backgroundColor) ?? Colors.white;

    selectedFontFamily = widget.student.preferences.fontFamily ?? 'default';
    fontSizeValue = widget.student.preferences.fontSize ?? 'default';
  }

  Color? _parseColor(String? hex) {
    if (hex == null) return null;
    try {
      return Color(int.parse(hex));
    } catch (_) {
      return null;
    }
  }

  String _colorToHex(Color c) =>
      '0x${c.value.toRadixString(16).padLeft(8, '0')}';

  Future<void> _goToScreen3() async {
    final updatedStudent = widget.student.copyWith(
      name: _nameController.text.trim(),
      avatarIndex: _avatarIndex,
      preferences: widget.student.preferences.copyWith(
        primaryColor: _colorToHex(primaryColor),
        secondaryColor: _colorToHex(secondaryColor),
        backgroundColor: _colorToHex(backgroundColor),
        fontFamily: selectedFontFamily,
        fontSize: fontSizeValue,
      ),
    );

    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TutorEditProfileScreen3(
          student: updatedStudent,
        ),
      ),
    );

    if (saved == true && mounted) {
      Navigator.pop(context, true); // 🔥 vuelve a Screen1 / Home
    }
  }


  double _fontSizeToSlider(String fontSize) {
    switch (fontSize) {
      case 'extra_small':
        return 0.0;
      case 'small':
        return 0.25;
      case 'default':
        return 0.5;
      case 'large':
        return 0.75;
      case 'extra_large':
        return 1.0;
      default:
        return 0.5;
    }
  }

  String _sliderToFontSize(double value) {
    if (value <= 0.125) return 'extra_small';
    if (value <= 0.375) return 'small';
    if (value <= 0.625) return 'default';
    if (value <= 0.875) return 'large';
    return 'extra_large';
  }

  double _getFontSizePreview(String fontSize) {
    switch (fontSize) {
      case 'extra_small':
        return 12.0;
      case 'small':
        return 16.0;
      case 'default':
        return 20.0;
      case 'large':
        return 24.0;
      case 'extra_large':
        return 32.0;
      default:
        return 20.0;
    }
  }

  String _getFontFamilyName(String fontFamily) {
    switch (fontFamily) {
      case 'default':
        return 'Roboto';
      case 'friendly':
        return 'ComicNeue';
      case 'easy-reading':
        return 'OpenDyslexic';
      default:
        return 'Roboto';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          "Editar Alumno",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            // Cabecera alumno
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFAAD2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/avatar$_avatarIndex.png'),
                    radius: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _nameController.text.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // COLORES
            _buildSectionContainer(
              title: 'Colores',
              child: Column(
                children: [
                  _buildColorSelector('Primario', primaryColor,
                          (c) => setState(() => primaryColor = c)),
                  _buildColorSelector('Secundario', secondaryColor,
                          (c) => setState(() => secondaryColor = c)),
                  _buildColorSelector('Fondo', backgroundColor,
                          (c) => setState(() => backgroundColor = c)),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // TIPOGRAFÍA
            _buildSectionContainer(
              title: 'Tipografía',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFontTypeSelector(),
                  const SizedBox(height: 24),
                  _buildFontSizeSelector(),
                ],
              ),
            ),

            const Spacer(),

            // BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: _goToScreen3,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CA7FF)),
                  child: const Text('Continuar',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(
      String label, Color color, Function(Color) onSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () async {
            final c = await _pickColor(context, color);
            if (c != null) onSelected(c);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Future<Color?> _pickColor(BuildContext context, Color initial) async {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.yellow,
    ];

    return showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selecciona un color'),
        content: Wrap(
          spacing: 6,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, c),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: c,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: const Color(0xFF5CA7FF),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const Divider(color: Colors.black, thickness: 1),
          child,
        ],
      ),
    );
  }

  Widget _buildFontTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _FontTypeButton(
            label: 'Predeterminada',
            fontFamily: 'Roboto',
            isSelected: selectedFontFamily == 'default',
            onTap: () => setState(() => selectedFontFamily = 'default'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FontTypeButton(
            label: 'Amigable',
            fontFamily: 'ComicNeue',
            isSelected: selectedFontFamily == 'friendly',
            onTap: () => setState(() => selectedFontFamily = 'friendly'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FontTypeButton(
            label: 'Lectura Fácil',
            fontFamily: 'OpenDyslexic',
            isSelected: selectedFontFamily == 'easy-reading',
            onTap: () => setState(() => selectedFontFamily = 'easy-reading'),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSelector() {
    final currentFontSize = _getFontSizePreview(fontSizeValue);
    final currentFontFamily = _getFontFamilyName(selectedFontFamily);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tamaño de letra',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Slider(
          value: _fontSizeToSlider(fontSizeValue),
          min: 0.0,
          max: 1.0,
          divisions: 4,
          onChanged: (value) {
            setState(() {
              fontSizeValue = _sliderToFontSize(value);
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Texto de ejemplo',
            style: TextStyle(
              fontSize: currentFontSize,
              fontFamily: currentFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}

class _FontTypeButton extends StatelessWidget {
  final String label;
  final String fontFamily;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontTypeButton({
    required this.label,
    required this.fontFamily,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 3 : 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamily,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
