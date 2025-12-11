import 'package:flutter/material.dart';
import 'change_passwords_screen.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class ResetPasswordsScreen extends StatefulWidget {
  const ResetPasswordsScreen({super.key});

  @override
  State<ResetPasswordsScreen> createState() => _ResetPasswordsScreenState();
}

class _ResetPasswordsScreenState extends State<ResetPasswordsScreen> {
  final UserService _userService = UserService();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando usuarios: $e');
      setState(() => _isLoading = false);
    }
  }

  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _theadBg    = Color(0xFFD9D9D9);
  static const _btnGrey    = Color(0xFFBDBDBD);

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
          final changeBtnW= clamp(base * 0.20, 92, 124);

          // Anchos de columnas: avatar | nombre | rol | cambiar
          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.36;
          final colRoleW   = totalWidth * 0.30;
          final colChangeW = totalWidth - (colAvatarW + colNameW + colRoleW + colGap * 3);

          // Datos del boceto
          // final users = <_User>[
          //   _User(color: const Color(0xFF9ED7E6), emoji: '👤', name: 'Mario',  role: 'Estudiante'),
          //   _User(color: const Color(0xFFF7E07D), emoji: '🐻', name: 'Jesús',  role: 'Estudiante'),
          //   _User(color: const Color(0xFFF6B7A4), emoji: '🦊', name: 'Laura',  role: 'Profesora'),
          //   _User(color: const Color(0xFFB6E2C8), emoji: '🦒', name: 'Rosa',   role: 'Estudiante'),
          //   _User(color: const Color(0xFFCFCBEA), emoji: '🐘', name: 'Pedro',  role: 'Profesor'),
          // ];

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
                    width: colRoleW,
                    child: Center(
                      child: Text(
                        'Rol',
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
                    width: colChangeW,
                    child: Center(
                      child: Text(
                        'Cambiar contraseña',
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

          // Botón "Cambiar" gris (pill)
          Widget changePill({VoidCallback? onTap}) {
            final pill = Container(
              height: btnH,
              width: changeBtnW,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _btnGrey,
                borderRadius: BorderRadius.circular(btnRadius),
              ),
              child: const Text(
                'Cambiar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            );

            // Si no hay acción, lo devolvemos como widget estático
            if (onTap == null) return pill;

            // Si hay acción, lo envolvemos en un InkWell para hacerlo clicable
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
          Widget rowItem(UserModel u, int index) {
            final colors = [
              const Color(0xFF9ED7E6),
              const Color(0xFFF7E07D),
              const Color(0xFFF6B7A4),
              const Color(0xFFB6E2C8),
              const Color(0xFFCFCBEA),
            ];
            final avatarColor = colors[index % colors.length];
            final emojis = ['👤', '🐻', '🦊', '🦒', '🐘'];
            final emoji = emojis[index % emojis.length];

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
                          color: avatarColor,
                          borderRadius: BorderRadius.circular(avatarR.toDouble()),
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji, style: TextStyle(fontSize: avatar * 0.58)),
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Nombre
                  SizedBox(
                    width: colNameW,
                    child: Center(
                      child: Text(
                        u.name,
                        style: TextStyle(fontSize: cellFont, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Rol
                  SizedBox(
                    width: colRoleW,
                    child: Center(
                      child: Text(
                        u.role,
                        style: TextStyle(fontSize: cellFont, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Cambiar contraseña
                  SizedBox(
                    width: colChangeW,
                    child: Center(
                      child: changePill(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangePasswordsScreen(
                                userId: u.id,
                                userName: u.name,
                                avatarColor: avatarColor,
                                emoji: emoji,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            );
          }

          return Padding(
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

                SizedBox(height: pagePad * 0.8),

                headerBar(),

                // Filas
                // Filas
                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_users.isEmpty)
                  const Expanded(child: Center(child: Text("No hay usuarios")))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        return rowItem(_users[index], index);
                      },
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

// class _User {
//   final Color color;
//   final String emoji;
//   final String name;
//   final String role;
//
//   const _User({
//     required this.color,
//     required this.emoji,
//     required this.name,
//     required this.role,
//   });
// }
