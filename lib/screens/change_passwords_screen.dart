import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ChangePasswordsScreen extends StatefulWidget {
  const ChangePasswordsScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.avatarIndex, // <-- NUEVO
    required this.role,
  });

  final String userId;
  final String userName;
  final int avatarIndex;
  final String role;

  @override
  State<ChangePasswordsScreen> createState() => _ChangePasswordsScreenState();
}

class _ChangePasswordsScreenState extends State<ChangePasswordsScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _blueBox    = Color(0xFF77A9F4);
  static const _tileBg     = Color(0xFFD9D9D9);

  final List<int> _pwd = [];
  final TextEditingController _plainPwdCtrl = TextEditingController();
  bool _savingPlain = false;

  final List<_Animal> _animals = const [
    _Animal('🦁', Color(0xFFFFF3CD)),
    _Animal('🧸', Color(0xFFF5E6FF)),
    _Animal('🐯', Color(0xFFFFE0B2)),
    _Animal('🦓', Color(0xFFE0E0E0)),
    _Animal('🐊', Color(0xFFD4EDDA)),
    _Animal('🐸', Color(0xFFDFF5FF)),
    _Animal('🦥', Color(0xFFFCE4EC)),
    _Animal('🦒', Color(0xFFE8F5E9)),
  ];

  void _addAnimal(int index) {
    if (_pwd.length >= 4) return;
    setState(() => _pwd.add(index));
  }

  void _backspace() {
    if (_pwd.isEmpty) return;
    setState(() => _pwd.removeLast());
  }

  String get _avatarPath {
    // Seguridad: si en BD viene raro, lo acotamos 0..5
    final idx = widget.avatarIndex.clamp(0, 11);
    return 'assets/images/avatar$idx.jpg';
  }

  bool get _isStudent => widget.role.toLowerCase() == 'student';

  @override
  void dispose() {
    _plainPwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePlainPassword() async {
    final pwd = _plainPwdCtrl.text.trim();
    if (pwd.isEmpty && !_isStudent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce una contraseña'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _savingPlain = true);
    try {
      await UserService().updatePassword(
        widget.userId,
        pwd.isEmpty ? null : pwd,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pwd.isEmpty ? 'Contraseña eliminada' : 'Contraseña actualizada',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _savingPlain = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _blueAppBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: const Text(
          'ADMINISTRADOR',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad   = clamp(w * 0.08, 24, 60);

          final pillPadH  = clamp(w * 0.03, 14, 22);
          final pillPadV  = clamp(w * 0.008, 6, 10);
          final pillRadius= clamp(w * 0.02, 10, 16);
          final pillFont  = clamp(base * 0.026, 14, 20);

          final avatar    = clamp(base * 0.22, 80, 120);
          final avatarR   = clamp(14, 12, 16);
          final nameFont  = clamp(base * 0.032, 16, 22);

          final labelFont = clamp(base * 0.028, 14, 18);
          final boxH      = clamp(base * 0.11, 56, 78);
          final slotSize  = clamp(boxH * 0.62, 36, 52);
          final slotR     = clamp(10, 8, 12);
          final slotGap   = clamp(base * 0.02, 10, 16);
          final boxR      = clamp(14, 12, 16);
          final boxPadX   = clamp(base * 0.03, 16, 22);

          final gridW     = clamp(w * 0.80, 520, 820);
          final gridPad   = clamp(base * 0.02, 12, 18);
          final cellSize  = clamp(base * 0.13, 72, 92);
          final cellR     = clamp(14, 12, 16);
          final cellGap   = clamp(base * 0.016, 10, 16);
          final emojiSize = clamp(cellSize * 0.52, 28, 40);

          final contentW  = clamp(w * 0.80, 540, 860);

          Widget userHeader() {
            return Column(
              children: [
                if (_isStudent)
                  Container(
                    width: avatar,
                    height: avatar,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(avatarR.toDouble()),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(_avatarPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: clamp(base * 0.018, 8, 14)),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: nameFont,
                    color: Colors.black87,
                  ),
                ),
              ],
            );
          }

          Widget passwordBox() {
            final delGap   = clamp(base * 0.012, 6, 10);
            final delSize  = slotSize * 0.92;
            final innerW   = (slotSize * 4) + (slotGap * 3) + delGap + delSize + (boxPadX * 2);

            return SizedBox(
              width: innerW,
              child: Container(
                height: boxH,
                padding: EdgeInsets.symmetric(horizontal: boxPadX),
                decoration: BoxDecoration(
                  color: _blueBox,
                  borderRadius: BorderRadius.circular(boxR),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 3),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      _PasswordSlot(
                        size: slotSize,
                        radius: slotR.toDouble(),
                        filled: _pwd.length > i
                            ? (_SlotFill(emoji: _animals[_pwd[i]].emoji, bg: _animals[_pwd[i]].bg))
                            : null,
                      ),
                      if (i < 3) SizedBox(width: slotGap),
                    ],
                    SizedBox(width: delGap),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(slotR.toDouble()),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(slotR.toDouble()),
                        onTap: _pwd.isEmpty ? null : _backspace,
                        child: Container(
                          width: delSize,
                          height: delSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(slotR.toDouble()),
                            border: Border.all(color: Colors.black54, width: 1.5),
                          ),
                          child: const Icon(Icons.backspace_outlined, size: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          Widget passwordRow() {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: clamp(contentW * 0.30, 160, 240),
                  child: Text(
                    'Escriba la nueva\ncontraseña:',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: labelFont,
                      color: Colors.black87,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                passwordBox(),
              ],
            );
          }

          Widget animalsGrid() {
            return Center(
              child: Container(
                width: gridW,
                padding: EdgeInsets.all(gridPad),
                decoration: BoxDecoration(
                  color: _tileBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: cellGap,
                  crossAxisSpacing: cellGap,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_animals.length, (i) {
                    final a = _animals[i];
                    final disabled = _pwd.length >= 4;
                    return _AnimalButton(
                      size: cellSize,
                      radius: cellR.toDouble(),
                      bg: a.bg,
                      emoji: a.emoji,
                      emojiSize: emojiSize,
                      onTap: disabled ? null : () => _addAnimal(i),
                    );
                  }),
                ),
              ),
            );
          }

          if (!_isStudent) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: pagePad * 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: pillPadH, vertical: pillPadV),
                    decoration: BoxDecoration(
                      color: _bluePill,
                      borderRadius: BorderRadius.circular(pillRadius),
                    ),
                    child: Text(
                      'Restablecer contraseñas',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: pillFont,
                      ),
                    ),
                  ),
                  SizedBox(height: clamp(base * 0.04, 18, 28)),
                  Center(child: userHeader()),
                  SizedBox(height: clamp(base * 0.035, 16, 24)),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: clamp(contentW * 0.8, 320, 460),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nueva contraseña',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _plainPwdCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Introduce la nueva contraseña',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _savingPlain ? null : _savePlainPassword,
                              child: _savingPlain
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Guardar contraseña',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: pagePad * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: pillPadH, vertical: pillPadV),
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                  child: Text(
                    'Restablecer contraseñas',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: pillFont,
                    ),
                  ),
                ),

                SizedBox(height: clamp(base * 0.04, 18, 28)),
                Center(child: userHeader()),
                SizedBox(height: clamp(base * 0.035, 16, 24)),

                Center(child: SizedBox(width: contentW, child: passwordRow())),
                SizedBox(height: clamp(base * 0.03, 14, 22)),

                animalsGrid(),
                SizedBox(height: clamp(base * 0.04, 18, 28)),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final password = _pwd.isEmpty ? null : _pwd.join('');
                            try {
                              await UserService().updatePassword(widget.userId, password);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      password == null
                                          ? 'Contraseña eliminada'
                                          : 'Contraseña guardada correctamente',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al guardar: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'GUARDAR CONTRASEÑA',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Animal {
  final String emoji;
  final Color bg;
  const _Animal(this.emoji, this.bg);
}

class _SlotFill {
  final String emoji;
  final Color bg;
  const _SlotFill({required this.emoji, required this.bg});
}

class _PasswordSlot extends StatelessWidget {
  const _PasswordSlot({
    required this.size,
    required this.radius,
    this.filled,
  });

  final double size;
  final double radius;
  final _SlotFill? filled;

  @override
  Widget build(BuildContext context) {
    final bg = filled?.bg ?? Colors.white;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black26, width: 1),
      ),
      alignment: Alignment.center,
      child: filled == null
          ? const SizedBox.shrink()
          : Text(filled!.emoji, style: TextStyle(fontSize: size * 0.58)),
    );
  }
}

class _AnimalButton extends StatelessWidget {
  const _AnimalButton({
    required this.size,
    required this.radius,
    required this.bg,
    required this.emoji,
    required this.emojiSize,
    this.onTap,
  });

  final double size;
  final double radius;
  final Color bg;
  final String emoji;
  final double emojiSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: emojiSize)),
    );

    if (onTap == null) return tile;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: tile,
      ),
    );
  }
}
