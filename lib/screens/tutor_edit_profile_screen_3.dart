import 'package:flutter/material.dart';
import 'tutor_edit_profile_screen_4.dart';
import '../models/user_model.dart';
import '../services/reaction_sound_player.dart';

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
  late String selectedSound;
  late bool messageSuccess;
  late bool messageFail;
  late bool messageFinal;
  final ReactionSoundPlayer _soundPlayer = ReactionSoundPlayer();

  static const List<_SoundOption> _soundOptions = [
    _SoundOption(
      id: 'none',
      title: 'Sin sonido',
      description: 'Solo reacciones visuales.',
      icon: Icons.volume_off,
    ),
    _SoundOption(
      id: 'sound_bells',
      title: 'Campanas',
      description: 'Tono alegre y corto.',
      icon: Icons.notifications_active,
    ),
    _SoundOption(
      id: 'sound_marimba',
      title: 'Marimba',
      description: 'Acorde divertido.',
      icon: Icons.music_note,
    ),
    _SoundOption(
      id: 'sound_whistle',
      title: 'Acorde brillante',
      description: 'Acorde corto y agradable.',
      icon: Icons.music_video,
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedShape = widget.student.preferences.shape ?? 'circle';
    selectedReaction = widget.student.preferences.reactionType ?? 'none';
    selectedSound = widget.student.preferences.reactionSound ?? 'none';
    messageSuccess = widget.student.preferences.reactionMessageSuccess;
    messageFail = widget.student.preferences.reactionMessageFail;
    messageFinal = widget.student.preferences.reactionMessageFinal;
  }

  Future<void> _goToScreen4() async {
    final updatedStudent = widget.student.copyWith(
      preferences: widget.student.preferences.copyWith(
        shape: selectedShape,
        reactionType:
            selectedReaction == 'none' ? null : selectedReaction,
        reactionSound:
            selectedSound == 'none' ? null : selectedSound,
        reactionMessageSuccess: messageSuccess,
        reactionMessageFail: messageFail,
        reactionMessageFinal: messageFinal,
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
            const SizedBox(height: 16),
            _buildSoundsSection(primaryColor),
            const SizedBox(height: 16),
            _buildMessagesSection(primaryColor),
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
              'assets/images/avatar${widget.student.avatarIndex}.jpg',
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
          _reactionCard(
            'none',
            'Sin reacción',
            'No se mostrará ninguna animación.',
            Icons.block,
            primaryColor,
          ),
          const SizedBox(height: 8),
          _reactionCard(
            'confetti',
            'Confeti',
            'Lluvia de confeti al acertar.',
            Icons.celebration,
            primaryColor,
          ),
          const SizedBox(height: 8),
          _reactionCard(
            'stars',
            'Explosión de estrellas',
            'Estrellas brillantes que aparecen como refuerzo.',
            Icons.star,
            primaryColor,
          ),
          const SizedBox(height: 8),
          _reactionCard(
            'bubbles',
            'Burbujas ascendentes',
            'Burbujas de colores que suben desde el centro.',
            Icons.bubble_chart,
            primaryColor,
          ),
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

  Widget _buildSoundsSection(Color primaryColor) {
    return _section(
      'Sonido al acertar',
      Column(
        children: _soundOptions.map((option) {
          final isSelected = selectedSound == option.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedSound = option.id);
                if (option.id != 'none') {
                  _soundPlayer.play(option.id);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      option.icon,
                      color: isSelected ? Colors.green : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            option.description,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessagesSection(Color primaryColor) {
    return _section(
      'Mensajes motivacionales',
      Column(
        children: [
          _messageToggle(
            'Mensaje de apoyo por acierto',
            'Frases aleatorias como "¡Bien hecho!" al acertar.',
            messageSuccess,
            (value) => setState(() => messageSuccess = value),
          ),
          const SizedBox(height: 8),
          _messageToggle(
            'Mensaje de apoyo por fallo',
            'Mensajes como "¡Tú puedes!" cuando ocurra un error.',
            messageFail,
            (value) => setState(() => messageFail = value),
          ),
          const SizedBox(height: 8),
          _messageToggle(
            'Mensaje de apoyo final',
            'Mensaje motivador al acabar todas las rondas.',
            messageFinal,
            (value) => setState(() => messageFinal = value),
          ),
        ],
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

  Widget _messageToggle(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.purple : Colors.grey.shade300,
          width: value ? 2 : 1.5,
        ),
      ),
      child: SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple,
      ),
    );
  }
}

class _SoundOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  const _SoundOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}
