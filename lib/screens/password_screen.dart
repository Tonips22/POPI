import 'package:flutter/material.dart';
import 'game_selector_screen.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final List<int> _pwd = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
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

          // === Ajustes de tamaño ===
          final pagePad   = clamp(w * 0.08, 24, 60);

          final avatar    = clamp(base * 0.32, 140, 200); // más grande
          final boxH      = clamp(base * 0.18, 90, 130); // rectángulo más alto
          final slotSize  = clamp(boxH * 0.70, 52, 70);
          final slotGap   = clamp(base * 0.025, 14, 20);
          final slotR     = 12.0;
          final boxR      = 16.0;
          final boxPadX   = clamp(base * 0.03, 20, 28);

          // grid más pequeño para restar protagonismo
          final gridW     = clamp(w * 0.70, 480, 680);
          final gridPad   = clamp(base * 0.02, 10, 14);
          final cellSize  = clamp(base * 0.10, 64, 78);
          final cellR     = 14.0;
          final cellGap   = clamp(base * 0.012, 8, 12);
          final emojiSize = clamp(cellSize * 0.48, 24, 34);

          // ===== Avatar (icono grande arriba) =====
          Widget topAvatar() {
            return Container(
              width: avatar,
              height: avatar,
              decoration: BoxDecoration(
                color: const Color(0xFF2596BE),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(Icons.account_circle, size: avatar * 1, color: Colors.white),
            );
          }

          // ===== Rectángulo azul con casillas y botón borrar =====
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
                  color: const Color(0xFF77A9F4),
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
                        radius: slotR,
                        filled: _pwd.length > i
                            ? _SlotFill(
                          emoji: _animals[_pwd[i]].emoji,
                          bg: _animals[_pwd[i]].bg,
                        )
                            : null,
                      ),
                      if (i < 3) SizedBox(width: slotGap),
                    ],
                    SizedBox(width: delGap),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(slotR),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(slotR),
                        onTap: _pwd.isEmpty ? null : _backspace,
                        child: Container(
                          width: delSize,
                          height: delSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(slotR),
                            border: Border.all(color: Colors.black54, width: 1.5),
                          ),
                          child: const Icon(Icons.backspace_outlined,
                              size: 22, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ===== Botón “Iniciar sesión” =====
          Widget loginButton(BuildContext context) {
            return ElevatedButton(
              onPressed: _pwd.isEmpty
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseGameScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2596BE),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "INICIAR SESIÓN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 1.5,
                ),
              ),
            );
          }


          // ===== Teclado de animalitos =====
          Widget animalsGrid() {
            final disabled = _pwd.length >= 4;

            return Center(
              child: Container(
                width: gridW,
                padding: EdgeInsets.all(gridPad),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
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
                    return _AnimalButton(
                      size: cellSize,
                      radius: cellR,
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

          // ===== Layout final =====
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: pagePad * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                topAvatar(),
                SizedBox(height: clamp(base * 0.04, 20, 30)),
                passwordBox(),
                SizedBox(height: clamp(base * 0.04, 22, 34)),
                loginButton(context), // 👈 botón nuevo
                SizedBox(height: clamp(base * 0.04, 20, 30)),
                animalsGrid(),
                if (_pwd.length == 4) ...[
                  const SizedBox(height: 14),
                  const Text('Contraseña lista (4 símbolos)',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======= Clases auxiliares =======
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
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
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
