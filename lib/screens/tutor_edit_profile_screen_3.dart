import 'package:flutter/material.dart';
import 'tutor_edit_profile_screen_4.dart';
import '../models/user_model.dart';

class TutorEditProfileScreen3 extends StatefulWidget {
  final UserModel student;

  const TutorEditProfileScreen3({super.key, required this.student});

  @override
  State<TutorEditProfileScreen3> createState() =>
      _TutorEditProfileScreen3State();
}

class _TutorEditProfileScreen3State extends State<TutorEditProfileScreen3> {
  late String selectedShape;
  late String selectedReaction;

  @override
  void initState() {
    super.initState();
    selectedShape = widget.student.preferences.shape ?? 'circle';
    selectedReaction = widget.student.preferences.reactionType ?? 'none';
  }

  Future<void> _goToScreen4() async {
    final updatedStudent = widget.student.copyWith(
      preferences: widget.student.preferences.copyWith(
        shape: selectedShape,
        reactionType:
        selectedReaction == 'none' ? null : selectedReaction,
      ),
    );

    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TutorEditProfileScreen4(
          student: updatedStudent,
        ),
      ),
    );

    if (saved == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        title: const Text(
          'Preferencias',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildStudentHeader(),
            const SizedBox(height: 12),
            _buildShapesSection(primaryColor),
            const SizedBox(height: 16),
            _buildReactionsSection(primaryColor),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFAAD2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(
              'assets/images/avatar${widget.student.avatarIndex}.png',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.student.name.toUpperCase(),
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapesSection(Color primaryColor) {
    return _section(
      'Forma de los objetos',
      Row(
        children: [
          _shapeCard('circle', Icons.circle, 'Círculo', primaryColor),
          _shapeCard('square', Icons.square_rounded, 'Cuadrado', primaryColor),
          _shapeCard('triangle', Icons.change_history, 'Triángulo', primaryColor),
        ],
      ),
    );
  }

  Widget _shapeCard(
      String shape, IconData icon, String label, Color primaryColor) {
    final isSelected = selectedShape == shape;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedShape = shape),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 3 : 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 48,
                  color:
                  isSelected ? primaryColor : Colors.grey.shade600),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactionsSection(Color primaryColor) {
    return _section(
      'Reacción al acertar',
      Column(
        children: [
          _reactionCard('none', 'Sin reacción',
              'No se mostrará ninguna animación.', Icons.block, primaryColor),
          const SizedBox(height: 8),
          _reactionCard('confetti', 'Confeti',
              'Lluvia de confeti al acertar.', Icons.celebration, primaryColor),
        ],
      ),
    );
  }

  Widget _reactionCard(String id, String title, String desc,
      IconData icon, Color primaryColor) {
    final isSelected = selectedReaction == id;

    return GestureDetector(
      onTap: () => setState(() => selectedReaction = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                isSelected ? primaryColor : Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    Text(desc,
                        style:
                        const TextStyle(fontSize: 12)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          child,
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5CA7FF)),
          onPressed: _goToScreen4,
          child: const Text('Continuar',),
        ),
      ],
    );
  }
}
