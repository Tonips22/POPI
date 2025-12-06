import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import '../screens/detalles_usuario.dart';

class RegistroUsuariosScreen extends StatefulWidget {
  const RegistroUsuariosScreen({super.key});

  @override
  State<RegistroUsuariosScreen> createState() => _RegistroUsuariosScreenState();
}

class _RegistroUsuariosScreenState extends State<RegistroUsuariosScreen> {
  final UserService _userService = UserService();
  List<UserProfile> _users = [];
  bool _isLoading = true;

  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill = Color(0xFF77A9F4);
  static const _theadBg = Color(0xFFD9D9D9);

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final h = c.maxHeight;
                final base = (w < h ? w : h);

                double clamp(double v, double min, double max) =>
                    v < min ? min : (v > max ? max : v);

                final pagePad = clamp(w * 0.08, 24, 60);
                final pillPadH = clamp(w * 0.03, 14, 22);
                final pillPadV = clamp(w * 0.008, 6, 10);
                final pillRadius = clamp(w * 0.02, 10, 16);
                final pillFont = clamp(base * 0.026, 14, 20);
                final rowH = clamp(base * 0.095, 44, 64);
                final avatar = clamp(rowH * 0.74, 30, 52);
                final avatarR = clamp(12, 8, 16);
                final headFont = clamp(base * 0.025, 13, 17);
                final cellFont = clamp(base * 0.026, 14, 18);
                final colGap = clamp(w * 0.02, 12, 24);

                final totalWidth = w - pagePad * 2;
                final colAvatarW = avatar;
                final colNameW = totalWidth * 0.35;
                final colRoleW = totalWidth * 0.25;
                final colButtonW = totalWidth -
                    (colAvatarW + colNameW + colRoleW + colGap * 4);

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
                            child: Text(
                              'Nombre',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: headFont),
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
                                  fontSize: headFont),
                            ),
                          ),
                        ),
                        SizedBox(width: colGap),
                        SizedBox(
                          width: colButtonW,
                          child: Center(
                            child: Text(
                              'Acciones',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: headFont),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                Widget rowItem(UserProfile user, int index) {
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
                        SizedBox(
                          width: colAvatarW,
                          child: Center(
                            child: Container(
                              width: avatar,
                              height: avatar,
                              decoration: BoxDecoration(
                                color: avatarColor,
                                borderRadius:
                                    BorderRadius.circular(avatarR.toDouble()),
                              ),
                              alignment: Alignment.center,
                              child: Text(emoji,
                                  style: TextStyle(fontSize: avatar * 0.58)),
                            ),
                          ),
                        ),
                        SizedBox(width: colGap),
                        SizedBox(
                          width: colNameW,
                          child: Center(
                            child: Text(
                              user.name,
                              style: TextStyle(fontSize: cellFont),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: colGap),
                        SizedBox(
                          width: colRoleW,
                          child: Center(
                            child: Text(
                              user.role,
                              style: TextStyle(fontSize: cellFont),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: colGap),
                        SizedBox(
                          width: colButtonW,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => UsuarioDetallesScreen(usuario: user.toMap()))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Ver detalles',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: pagePad, vertical: pagePad * 0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: pillPadH, vertical: pillPadV),
                        decoration: BoxDecoration(
                          color: _bluePill,
                          borderRadius: BorderRadius.circular(pillRadius),
                        ),
                        child: Text(
                          'Registro de usuarios',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: pillFont,
                          ),
                        ),
                      ),
                      SizedBox(height: pagePad * 0.8),
                      headerBar(),
                      Expanded(
                        child: _users.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay usuarios registrados',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _users.length,
                                itemBuilder: (context, index) =>
                                    rowItem(_users[index], index),
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