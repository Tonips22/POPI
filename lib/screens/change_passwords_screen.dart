import 'package:flutter/material.dart';

class ChangePasswordsScreen extends StatefulWidget {
  const ChangePasswordsScreen({
    super.key,
    required this.userName,
    required this.avatarColor,
    required this.emoji,
  });

  final String userName;
  final Color avatarColor;
  final String emoji;

  @override
  State<ChangePasswordsScreen> createState() => _ChangePasswordsScreenState();
}

class _ChangePasswordsScreenState extends State<ChangePasswordsScreen> {
  // Colores coherentes con el resto
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _blueBox    = Color(0xFF77A9F4);
  static const _tileBg     = Color(0xFFD9D9D9);

  // La contraseña son 4 animalitos (guardamos índices)
  final List<int> _pwd = [];

  // Catálogo de animalitos (emoji + color de fondo del botón)
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          // Márgenes y tipografías
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

          // Grid animalitos
          final gridW     = clamp(w * 0.80, 520, 820);
          final gridPad   = clamp(base * 0.02, 12, 18);
          final cellSize  = clamp(base * 0.13, 72, 92);
          final cellR     = clamp(14, 12, 16);
          final cellGap   = clamp(base * 0.016, 10, 16);
          final emojiSize = clamp(cellSize * 0.52, 28, 40);

          // Ancho del bloque central
          final contentW  = clamp(w * 0.80, 540, 860);

          // Widget: avatar + nombre
          Widget userHeader() {
            return Column(
              children: [
                Container(
                  width: avatar,
                  height: avatar,
                  decoration: BoxDecoration(
                    color: widget.avatarColor,
                    borderRadius: BorderRadius.circular(avatarR.toDouble()),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.emoji, style: TextStyle(fontSize: avatar * 0.55)),
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
            // tamaños ya calculados arriba en tu build: boxH, slotSize, slotR, slotGap, boxR, boxPadX
            final delGap   = clamp(base * 0.012, 6, 10);
            final delSize  = slotSize * 0.92;
            // ancho exacto: 4 slots + 3 gaps + gap pequeño + botón borrar + paddings
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
                    // 4 casillas
                    for (int i = 0; i < 4; i++) ...[
                      _PasswordSlot(
                        size: slotSize,
                        radius: slotR.toDouble(),
                        // si hay símbolo, usar su MISMO color de fondo y el emoji
                        filled: _pwd.length > i
                            ? (_SlotFill(emoji: _animals[_pwd[i]].emoji, bg: _animals[_pwd[i]].bg))
                            : null,
                      ),
                      if (i < 3) SizedBox(width: slotGap),
                    ],
                    SizedBox(width: delGap),
                    // Botón borrar (pegado al último slot)
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


          // Widget: etiqueta izquierda + cajetín a la derecha (como el boceto)
          Widget passwordRow() {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Etiqueta
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
                // Cajetín
                passwordBox(),
              ],
            );
          }

          // Widget: grid de animalitos (12) como botones
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


          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: pagePad * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora de título
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

                // Avatar + nombre centrados
                Center(child: userHeader()),

                SizedBox(height: clamp(base * 0.035, 16, 24)),

                // Fila etiqueta + cajetín
                Center(
                  child: SizedBox(width: contentW, child: passwordRow()),
                ),

                SizedBox(height: clamp(base * 0.03, 14, 22)),

                // Grid animalitos
                animalsGrid(),

                // espacio final para que no “ahogue” en pantallas pequeñas
                SizedBox(height: clamp(base * 0.04, 18, 28)),

                // (Opcional) aviso al completar 4
                if (_pwd.length == 4)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Contraseña lista (4 símbolos)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          fontSize: clamp(base * 0.024, 13, 16),
                        ),
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
          : Text(
        filled!.emoji,
        style: TextStyle(fontSize: size * 0.58),
      ),
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
