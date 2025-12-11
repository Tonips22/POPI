import 'package:flutter/material.dart';
import '../services/app_service.dart';
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
    description: 'Lluvia de confeti al acertar en “Toca el número”.',
    icon: Icons.celebration,
    colors: [Colors.pinkAccent, Colors.blueAccent, Colors.amber],
  ),
];

class _ReactionsScreenState extends State<ReactionsScreen> {
  final AppService _service = AppService();
  late String _selectedReaction;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prefs = _service.currentUser?.preferences;
    _selectedReaction = prefs?.reactionType ?? 'none';
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
            _buildPlaceholderTab('Sonidos personalizados próximamente'),
            _buildPlaceholderTab('Mensajes y frases motivadoras próximamente'),
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

  Widget _buildPlaceholderTab(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
