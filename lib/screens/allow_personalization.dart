import 'package:flutter/material.dart';

class AllowPersonalizationScreen extends StatefulWidget {
  const AllowPersonalizationScreen({super.key});

  @override
  State<AllowPersonalizationScreen> createState() =>
      _AllowPersonalizationScreenState();
}

class _AllowPersonalizationScreenState
    extends State<AllowPersonalizationScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _theadBg    = Color(0xFFD9D9D9);
  static const _greenAllow = Color(0xFF2E7D32);
  static const _redBlock   = Color(0xFFF44336);

  // 👇 AHORA la lista es parte del estado
  final List<_Student> _students = [
    _Student(color: const Color(0xFF9ED7E6), emoji: '👤', name: 'Mario',  allowed: true),
    _Student(color: const Color(0xFFF7E07D), emoji: '🐻', name: 'Jesús',  allowed: false),
    _Student(color: const Color(0xFFF6B7A4), emoji: '🦊', name: 'Laura',  allowed: true),
    _Student(color: const Color(0xFFB6E2C8), emoji: '🦒', name: 'Rosa',   allowed: true),
    _Student(color: const Color(0xFFCFCBEA), emoji: '🐘', name: 'Pedro',  allowed: false),
  ];

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
          'TUTOR',
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
          final w    = c.maxWidth;
          final h    = c.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad    = clamp(w * 0.08, 24, 60);

          final pillPadH   = clamp(w * 0.03, 14, 22);
          final pillPadV   = clamp(w * 0.008, 6, 10);
          final pillRadius = clamp(w * 0.02, 10, 16);
          final pillFont   = clamp(base * 0.026, 14, 20);

          final rowH       = clamp(base * 0.095, 44, 64);
          final avatar     = clamp(rowH * 0.74, 30, 52);
          final avatarR    = clamp(12, 8, 16);

          final headFont   = clamp(base * 0.025, 13, 17);
          final cellFont   = clamp(base * 0.026, 14, 18);

          final colGap     = clamp(w * 0.02, 12, 24);
          final btnH       = clamp(rowH * 0.62, 26, 40);
          final btnFont    = clamp(base * 0.022, 12, 15);
          final btnRadius  = clamp(20, 14, 20);
          final actionBtnW = clamp(base * 0.20, 92, 124);

          // Anchos de columnas: avatar | nombre | estado | acción
          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.36;
          final colStateW  = totalWidth * 0.24;
          final colActionW = totalWidth - (colAvatarW + colNameW + colStateW + colGap * 3);

          // Cabecera
          Widget headerBar() {
            return Container(
              height: rowH,
              color: _theadBg,
              child: Row(
                children: [
                  Container(
                    width: colAvatarW + (colGap * 0.6),
                    color: Colors.white,
                  ),
                  SizedBox(width: colGap * 0.4),
                  SizedBox(
                    width: colNameW,
                    child: Center(
                      child: Text(
                        'Nombre',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: headFont,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colStateW,
                    child: Center(
                      child: Text(
                        'Estado',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: headFont,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colActionW,
                    child: Center(
                      child: Text(
                        'Acción',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: headFont,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Botón rojo/verde tipo pill
          Widget actionPill(_Student s) {
            final bg   = s.allowed ? _redBlock : _greenAllow;
            final text = s.allowed ? 'Bloquear' : 'Permitir';

            final pill = Container(
              height: btnH,
              width: actionBtnW,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(btnRadius),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: btnFont,
                ),
              ),
            );

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(btnRadius),
                onTap: () {
                  setState(() {
                    // 👇 aquí cambiamos el estado
                    s.allowed = !s.allowed;
                  });
                },
                child: pill,
              ),
            );
          }

          // Fila
          Widget rowItem(_Student s) {
            return SizedBox(
              height: rowH,
              child: Row(
                children: [
                  // Avatar
                  SizedBox(
                    width: colAvatarW,
                    child: Center(
                      child: Container(
                        width: avatar,
                        height: avatar,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(avatarR.toDouble()),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          s.emoji,
                          style: TextStyle(fontSize: avatar * 0.58),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Nombre
                  SizedBox(
                    width: colNameW,
                    child: Center(
                      child: Text(
                        s.name,
                        style: TextStyle(fontSize: cellFont, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Estado
                  SizedBox(
                    width: colStateW,
                    child: Center(
                      child: Text(
                        s.allowed ? 'Permitido' : 'Bloqueado',
                        style: TextStyle(fontSize: cellFont, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Acción
                  SizedBox(
                    width: colActionW,
                    child: Center(
                      child: actionPill(s),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pagePad,
              vertical: pagePad * 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora de título
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pillPadH,
                    vertical: pillPadV,
                  ),
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                  child: Text(
                    'Permitir personalización',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: pillFont,
                    ),
                  ),
                ),

                SizedBox(height: pagePad * 0.8),

                headerBar(),

                // Filas
                ..._students.map(rowItem),

                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Student {
  final Color color;
  final String emoji;
  final String name;
  bool allowed;

  _Student({
    required this.color,
    required this.emoji,
    required this.name,
    required this.allowed,
  });
}
