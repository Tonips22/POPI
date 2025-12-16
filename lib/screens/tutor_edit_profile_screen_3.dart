import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/app_service.dart';

class TutorEditProfileScreen3 extends StatefulWidget {
  final UserModel student;

  const TutorEditProfileScreen3({super.key, required this.student});

  @override
  State<TutorEditProfileScreen3> createState() =>
      _TutorEditProfileScreen3State();
}

class _TutorEditProfileScreen3State extends State<TutorEditProfileScreen3> {
  final AppService _appService = AppService();

  late String selectedShape;
  late String selectedReaction;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedShape = widget.student.preferences.shape ?? 'circle';
    selectedReaction = widget.student.preferences.reactionType ?? 'none';
  }

  Future<void> _savePreferences() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final updatedStudent = widget.student.copyWith(
      preferences: widget.student.preferences.copyWith(
        shape: selectedShape,
        reactionType:
        selectedReaction == 'none' ? null : selectedReaction,
      ),
    );

    await _appService.saveUser(updatedStudent);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue;
    final backgroundColor = Colors.white;


    return Scaffold(
      backgroundColor: backgroundColor,
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

  // ================= HEADER =================

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

  // ================= SHAPES =================

  Widget _buildShapesSection(Color primaryColor) {
    return _section(
      'Forma de los objetos',
      Row(
        children: [
          _shapeCard(
              shape: 'circle',
              icon: Icons.circle,
              label: 'Círculo',
              primaryColor: primaryColor),
          _shapeCard(
              shape: 'square',
              icon: Icons.square_rounded,
              label: 'Cuadrado',
              primaryColor: primaryColor),
          _shapeCard(
              shape: 'triangle',
              icon: Icons.change_history,
              label: 'Triángulo',
              primaryColor: primaryColor),
        ],
      ),
    );
  }

  Widget _shapeCard({
    required String shape,
    required IconData icon,
    required String label,
    required Color primaryColor,
  }) {
    final isSelected = selectedShape == shape;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedShape = shape),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
                  color: isSelected
                      ? primaryColor
                      : Colors.grey.shade600),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: Colors.green, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= REACTIONS =================

  Widget _buildReactionsSection(Color primaryColor) {
    return _section(
      'Reacción al acertar',
      Column(
        children: [
          _reactionCard(
            id: 'none',
            title: 'Sin reacción',
            description: 'No se mostrará ninguna animación.',
            icon: Icons.block,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 8),
          _reactionCard(
            id: 'confetti',
            title: 'Confeti',
            description: 'Lluvia de confeti al acertar.',
            icon: Icons.celebration,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _reactionCard({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required Color primaryColor,
  }) {
    final isSelected = selectedReaction == id;

    return GestureDetector(
      onTap: () => setState(() => selectedReaction = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
                size: 36,
                color:
                isSelected ? primaryColor : Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(description,
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color:
              isSelected ? primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMMON =================

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
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
          onPressed: _savePreferences,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5CA7FF),
          ),
          child: _isSaving
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
