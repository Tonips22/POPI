import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../services/reaction_sound_player.dart';
import '../models/user_model.dart';

class ReactionsScreen extends StatefulWidget {
  const ReactionsScreen({super.key});

  @override
  State<ReactionsScreen> createState() => _ReactionsScreenState();
}

class _ReactionOption {
  const _ReactionOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;
}

const List<_ReactionOption> _animationOptions = [
  _ReactionOption(
    id: 'none',
    title: 'Sin reacción',
    description: 'No se mostrará ninguna animación al acertar.',
    icon: Icons.block,
    colors: [Colors.grey, Colors.black45],
  ),
  _ReactionOption(
    id: 'confetti',
    title: 'Confeti clásico',
    description: 'Lluvia de confeti multicolor al acertar.',
    icon: Icons.celebration,
    colors: [Colors.pinkAccent, Colors.blueAccent, Colors.amber],
  ),
  _ReactionOption(
    id: 'stars',
    title: 'Estrellas brillantes',
    description: 'Explosión de estrellas doradas al superar una ronda.',
    icon: Icons.star,
    colors: [Colors.amber, Colors.orangeAccent],
  ),
  _ReactionOption(
    id: 'bubbles',
    title: 'Burbujas ascendentes',
    description: 'Burbujas suaves que ascienden cuando aciertas.',
    icon: Icons.bubble_chart,
    colors: [Colors.cyanAccent, Colors.blueAccent],
  ),
];

const List<_ReactionOption> _soundOptions = [
  _ReactionOption(
    id: 'none',
    title: 'Sin sonido',
    description: 'Solo se mostrarán las animaciones visuales.',
    icon: Icons.volume_off,
    colors: [Colors.grey, Colors.black45],
  ),
  _ReactionOption(
    id: 'sound_bells',
    title: 'Campanas brillantes',
    description: 'Pequeño tintineo festivo al acertar.',
    icon: Icons.notifications_active,
    colors: [Colors.amber, Colors.orangeAccent],
  ),
  _ReactionOption(
    id: 'sound_marimba',
    title: 'Marimba alegre',
    description: 'Acorde de marimba rápido y divertido.',
    icon: Icons.music_note,
    colors: [Colors.deepPurpleAccent, Colors.blueAccent],
  ),
  _ReactionOption(
    id: 'sound_whistle',
    title: 'Acorde brillante',
    description: 'Un acorde corto y agradable para celebrar.',
    icon: Icons.music_video,
    colors: [Colors.tealAccent, Colors.greenAccent],
  ),
];

class _ReactionsScreenState extends State<ReactionsScreen> {
  final AppService _service = AppService();
  late String _selectedReaction;
  late String _selectedSound;
  bool _messageSuccess = false;
  bool _messageFail = false;
  bool _messageFinal = false;
  bool _isSaving = false;
  final ReactionSoundPlayer _soundPlayer = ReactionSoundPlayer();

  @override
  void initState() {
    super.initState();
    final prefs = _service.currentUser?.preferences;
    _selectedReaction = prefs?.reactionType ?? 'none';
    _selectedSound = prefs?.reactionSound ?? 'none';
    _messageSuccess = prefs?.reactionMessageSuccess ?? false;
    _messageFail = prefs?.reactionMessageFail ?? false;
    _messageFinal = prefs?.reactionMessageFinal ?? false;
  }

  Future<void> _selectReaction(_ReactionOption option) async {
    if (_isSaving) return;
    final user = _service.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    final String? valueToSave = option.id == 'none' ? null : option.id;
    final UserPreferences updatedPreferences =
        user.preferences.copyWith(reactionType: valueToSave);

    final success = await _service.updatePreferences(user.id, updatedPreferences);
    setState(() => _isSaving = false);

    if (success) {
      _service.updateCurrentUserPreferences(updatedPreferences);
      setState(() => _selectedReaction = option.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(option.id == 'none'
                ? 'Reacciones desactivadas'
                : 'Reacción "${option.title}" activada'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar la reacción'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectSound(_ReactionOption option) async {
    if (_isSaving) return;
    final user = _service.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    final String? valueToSave = option.id == 'none' ? null : option.id;
    final UserPreferences updatedPreferences =
        user.preferences.copyWith(reactionSound: valueToSave);

    final success = await _service.updatePreferences(user.id, updatedPreferences);
    setState(() => _isSaving = false);

    if (success) {
      _service.updateCurrentUserPreferences(updatedPreferences);
      setState(() => _selectedSound = option.id);
      if (valueToSave != null) {
        _soundPlayer.play(valueToSave);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(option.id == 'none'
                ? 'Sonidos desactivados'
                : 'Sonido "${option.title}" activado'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar el sonido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleFontSize = _service.fontSizeWithFallback();
    final titleFontFamily = _service.fontFamilyWithFallback();
    final backgroundColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.backgroundColor))
        : Colors.white;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Reacciones',
            style: TextStyle(
              fontSize: titleFontSize,
              fontFamily: titleFontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: 'Animaciones'),
              Tab(text: 'Sonidos'),
              Tab(text: 'Mensajes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAnimationsTab(titleFontFamily),
            _buildSoundsTab(titleFontFamily),
            _buildMessagesTab(titleFontFamily),
          ],
        ),
        bottomNavigationBar: _isSaving
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
    );
  }

  Widget _buildAnimationsTab(String titleFontFamily) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _animationOptions.length,
      itemBuilder: (context, index) {
        final option = _animationOptions[index];
        final bool selected = _selectedReaction == option.id;
        return GestureDetector(
          onTap: () => _selectReaction(option),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? Colors.blueAccent : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: option.colors),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(option.icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: titleFontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected
                      ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoundsTab(String titleFontFamily) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _soundOptions.length,
      itemBuilder: (context, index) {
        final option = _soundOptions[index];
        final bool selected = _selectedSound == option.id;
        return GestureDetector(
          onTap: () => _selectSound(option),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? Colors.green : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: option.colors),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    option.icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: titleFontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesTab(String titleFontFamily) {
    final textStyle = TextStyle(
      fontSize: 16,
      fontFamily: titleFontFamily,
      fontWeight: FontWeight.w600,
    );
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Elige qué mensajes quieres escuchar. Se pueden combinar porque no se solapan entre sí.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _messageToggleTile(
          title: 'Mensaje de apoyo por acierto',
          subtitle: 'Frases aleatorias como "¡Bien hecho!" al acertar.',
          value: _messageSuccess,
          onChanged: (value) => _toggleMessage('success', value),
          style: textStyle,
        ),
        const SizedBox(height: 8),
        _messageToggleTile(
          title: 'Mensaje de apoyo por fallo',
          subtitle: 'Mensajes como "¡Tú puedes!" cuando ocurra un error.',
          value: _messageFail,
          onChanged: (value) => _toggleMessage('fail', value),
          style: textStyle,
        ),
        const SizedBox(height: 8),
        _messageToggleTile(
          title: 'Mensaje de apoyo final',
          subtitle:
              'Un mensaje motivador al terminar todas las rondas, adaptado a los aciertos y fallos.',
          value: _messageFinal,
          onChanged: (value) => _toggleMessage('final', value),
          style: textStyle,
        ),
      ],
    );
  }

  Future<void> _toggleMessage(String type, bool value) async {
    final user = _service.currentUser;
    if (user == null) return;
    if (_isSaving) return;
    setState(() => _isSaving = true);
    UserPreferences updatedPreferences = user.preferences;
    switch (type) {
      case 'success':
        updatedPreferences =
            updatedPreferences.copyWith(reactionMessageSuccess: value);
        break;
      case 'fail':
        updatedPreferences =
            updatedPreferences.copyWith(reactionMessageFail: value);
        break;
      case 'final':
        updatedPreferences =
            updatedPreferences.copyWith(reactionMessageFinal: value);
        break;
    }

    final success =
        await _service.updatePreferences(user.id, updatedPreferences);
    setState(() => _isSaving = false);

    if (success) {
      _service.updateCurrentUserPreferences(updatedPreferences);
      setState(() {
        if (type == 'success') _messageSuccess = value;
        if (type == 'fail') _messageFail = value;
        if (type == 'final') _messageFinal = value;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar la configuración de mensajes'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _messageToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required TextStyle style,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? Colors.deepPurple : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: style),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        value: value,
        onChanged: (enabled) => onChanged(enabled),
        activeColor: Colors.deepPurple,
      ),
    );
  }

}
