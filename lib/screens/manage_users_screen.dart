import 'package:flutter/material.dart';
import 'create_users_screen.dart';
import 'desactivate_users_screen.dart';
import 'delete_users_screen.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  // Colores
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _theadBg    = Color(0xFFD9D9D9);

  static const _btnDelete  = Color(0xFFE53935);
  static const _btnDisable = Color(0xFFBDBDBD);
  static const _btnEnable  = Color(0xFFFFEB3B);
  static const _btnCreate  = Color(0xFF2E7D32);

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
          final base = (w < h ? w : h);

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad   = clamp(w * 0.08, 24, 60);

          final pillPadH  = clamp(w * 0.03, 14, 22);
          final pillPadV  = clamp(w * 0.008, 6, 10);
          final pillRadius= clamp(w * 0.02, 10, 16);
          final pillFont  = clamp(base * 0.026, 14, 20);

          final rowH      = clamp(base * 0.095, 44, 64);
          final avatar    = clamp(rowH * 0.74, 30, 52);
          final avatarR   = clamp(12, 8, 16);

          final headFont  = clamp(base * 0.025, 13, 17);
          final cellFont  = clamp(base * 0.026, 14, 18);

          final colGap    = clamp(w * 0.02, 12, 24);
          final btnH      = clamp(rowH * 0.62, 26, 40);
          final btnFont   = clamp(base * 0.022, 12, 15);
          final btnRadius = clamp(20, 14, 20);
          final btnGap    = clamp(w * 0.012, 6, 12);

          // Anchos de columnas
          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.28;
          final colRoleW   = totalWidth * 0.22;
          final colTutorW  = totalWidth * 0.22;
          final colActionsW= totalWidth - (colAvatarW + colNameW + colRoleW + colTutorW + colGap * 4);

          // Botones
          final delBtnW    = clamp(base * 0.18, 86, 110);
          final secBtnW    = clamp(base * 0.20, 92, 124);

          final users = <_User>[
            _User(color: const Color(0xFF9ED7E6), emoji: '👤', name: 'Mario',  role: 'Estudiante', tutor: 'Laura',   active: true),
            _User(color: const Color(0xFFF7E07D), emoji: '🐻', name: 'Jesús',  role: 'Estudiante', tutor: 'Laura',   active: false),
            _User(color: const Color(0xFFF6B7A4), emoji: '🦊', name: 'Laura',  role: 'Profesora',  tutor: '—',       active: true),
            _User(color: const Color(0xFFB6E2C8), emoji: '🦒', name: 'Rosa',   role: 'Estudiante', tutor: 'Pedro',   active: true),
            _User(color: const Color(0xFFCFCBEA), emoji: '🐘', name: 'Pedro',  role: 'Profesor',   tutor: '—',       active: true),
          ];

          // Cabecera
          Widget headerBar() {
            return Container(
              height: rowH,
              width: double.infinity,
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
                      child: Text('Nombre',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: headFont),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colRoleW,
                    child: Center(
                      child: Text('Rol',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: headFont),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colTutorW,
                    child: Center(
                      child: Text('Tutor',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: headFont),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colActionsW,
                    child: Center(
                      child: Text('Acciones',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: headFont),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          Widget actionPill({
            required String label,
            required Color bg,
            required Color fg,
            required double width,
            VoidCallback? onTap,
          }) {
            final pill = Container(
              height: btnH,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(btnRadius),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w800,
                  fontSize: btnFont,
                ),
              ),
            );

            if (onTap == null) return pill;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(btnRadius),
                onTap: onTap,
                child: pill,
              ),
            );
          }

          // Fila
          Widget rowItem(_User u) {
            return SizedBox(
              height: rowH,
              child: Row(
                children: [
                  SizedBox(
                    width: colAvatarW,
                    child: Center(
                      child: Container(
                        width: avatar,
                        height: avatar,
                        decoration: BoxDecoration(
                          color: u.color,
                          borderRadius: BorderRadius.circular(avatarR.toDouble()),
                        ),
                        alignment: Alignment.center,
                        child: Text(u.emoji, style: TextStyle(fontSize: avatar * 0.58)),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colNameW,
                    child: Center(
                      child: Text(u.name,
                        style: TextStyle(fontSize: cellFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colRoleW,
                    child: Center(
                      child: Text(u.role,
                        style: TextStyle(fontSize: cellFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colTutorW,
                    child: Center(
                      child: Text(u.tutor,
                        style: TextStyle(fontSize: cellFont),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  // Acciones autoajustables (sin overflow) + navegación
                  SizedBox(
                    width: colActionsW,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actionPill(
                            label: 'Eliminar',
                            bg: _btnDelete,
                            fg: Colors.white,
                            width: delBtnW,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  barrierColor: Colors.black38,
                                  pageBuilder: (_, __, ___) => DeleteUsersScreen(
                                    userName: u.name,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(width: btnGap),
                          u.active
                              ? actionPill(
                            label: 'Desactivar',
                            bg: _btnDisable,
                            fg: Colors.white,
                            width: secBtnW,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  barrierColor: Colors.black38,
                                  pageBuilder: (_, __, ___) => DesactivateUsersScreen(
                                    userName: u.name,
                                    isActive: true,
                                  ),
                                ),
                              );
                            },
                          )
                              : actionPill(
                            label: 'Activar',
                            bg: _btnEnable,
                            fg: Colors.black87,
                            width: secBtnW,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  barrierColor: Colors.black38,
                                  pageBuilder: (_, __, ___) => DesactivateUsersScreen(
                                    userName: u.name,
                                    isActive: false,
                                  ),
                                ),
                              );
                            },
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
                // Píldora "Gestionar usuarios"
                Container(
                  padding: EdgeInsets.symmetric(horizontal: pillPadH, vertical: pillPadV),
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                  child: Text(
                    'Gestionar usuarios',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: pillFont,
                    ),
                  ),
                ),
                SizedBox(height: pagePad * 0.8),
                headerBar(),
                ...users.map(rowItem),
                SizedBox(height: pagePad * 0.8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _btnCreate,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CrearUsuarioScreen()),
                      );
                    },
                    child: const Text('Crear usuario'),
                  ),
                ),
                SizedBox(height: pagePad * 0.4),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _User {
  final Color color;
  final String emoji;
  final String name;
  final String role;
  final String tutor;
  final bool active;

  const _User({
    required this.color,
    required this.emoji,
    required this.name,
    required this.role,
    required this.tutor,
    required this.active,
  });
}
