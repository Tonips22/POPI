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

  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _theadBg    = Color(0xFFD9D9D9);
  static const _btnGrey    = Color(0xFFBDBDBD);

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
      // ignore: avoid_print
      print('Error cargando usuarios: $e');
      setState(() => _isLoading = false);
    }
  }

  // ================== HELPERS ==================

  String _roleEs(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return 'Estudiante';
      case 'tutor':
        return 'Tutor';
      case 'admin':
        return 'Administrador';
      default:
        return role;
    }
  }

  String _avatarPathFromIndex(dynamic avatarIndex) {
    final idx = (avatarIndex is int) ? avatarIndex : int.tryParse('$avatarIndex') ?? 0;
    final safe = idx.clamp(0, 11);
    return 'assets/images/avatar$safe.jpg';
  }

  // =================================================

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

          final rowH      = clamp(base * 0.095, 44, 64);
          final avatar    = clamp(rowH * 0.74, 30, 52);
          final headFont  = clamp(base * 0.025, 13, 17);
          final cellFont  = clamp(base * 0.026, 14, 18);

          final colGap    = clamp(w * 0.02, 12, 24);
          final btnH      = clamp(rowH * 0.62, 26, 40);
          final btnRadius = clamp(20, 14, 20);
          final changeBtnW= clamp(base * 0.20, 92, 124);

          // Anchos: avatar | nombre | rol | cambiar
          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.36;
          final colRoleW   = totalWidth * 0.30;
          final colChangeW = totalWidth - (colAvatarW + colNameW + colRoleW + colGap * 3);

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

          // Botón pill
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
          Widget rowItem(UserModel u, int index) {
            final avatarPath = _avatarPathFromIndex(u.avatarIndex);
            final roleLower = u.role.toLowerCase();
            final roleEs = _roleEs(u.role);
            final bool isStudent = roleLower == 'student';

            return SizedBox(
              height: rowH,
              child: Row(
                children: [
                  // Avatar REAL
                  SizedBox(
                    width: colAvatarW,
                    child: Center(
                      child: isStudent
                          ? CircleAvatar(
                              radius: avatar / 2,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: AssetImage(avatarPath),
                            )
                          : SizedBox(
                              width: avatar,
                              height: avatar,
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

                  // Rol traducido
                  SizedBox(
                    width: colRoleW,
                    child: Center(
                      child: Text(
                        roleEs,
                        style: TextStyle(fontSize: cellFont, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Cambiar contraseña (según rol)
                  SizedBox(
                    width: colChangeW,
                    child: Center(
                      child: changePill(
                        onTap: () {
                          if (roleLower == 'student') {
                            // Estudiante -> animalitos
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangePasswordsScreen(
                                  userId: u.id,
                                  userName: u.name,
                                  avatarIndex: u.avatarIndex, // <-- asegúrate de que exista en UserModel
                                  role: u.role,
                                ),
                              ),
                            );
                          } else {
                            // Tutor/Admin -> contraseña escrita
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangePasswordsScreen(
                                  userId: u.id,
                                  userName: u.name,
                                  avatarIndex: u.avatarIndex, // <-- asegúrate de que exista en UserModel
                                  role: u.role,
                                ),
                              ),
                            );
                          }
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
                // Título pill
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

                // Lista
                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_users.isEmpty)
                  const Expanded(child: Center(child: Text("No hay usuarios")))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) => rowItem(_users[index], index),
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
