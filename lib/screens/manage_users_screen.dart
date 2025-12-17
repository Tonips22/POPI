import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static const String _collectionName = 'users';

  // 🔤 Traducción de roles
  String translateRole(String role) {
    switch (role) {
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

          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.28;
          final colRoleW   = totalWidth * 0.22;
          final colTutorW  = totalWidth * 0.22;
          final colActionsW= totalWidth -
              (colAvatarW + colNameW + colRoleW + colTutorW + colGap * 4);

          final delBtnW    = clamp(base * 0.18, 86, 110);
          final secBtnW    = clamp(base * 0.20, 92, 124);

          Widget headerBar() {
            return Container(
              height: rowH,
              width: double.infinity,
              color: _theadBg,
              child: Row(
                children: [
                  SizedBox(width: colAvatarW + colGap),
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

            return onTap == null
                ? pill
                : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(btnRadius),
                onTap: onTap,
                child: pill,
              ),
            );
          }

          Widget rowItem({
            required String docId,
            required String name,
            required String role,
            required dynamic tutorId,
            required int avatarIndex,
          }) {
            const active = true;

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
                          color: const Color(0xFFD3E3FF),
                          borderRadius: BorderRadius.circular(avatarR.toDouble()),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/avatar$avatarIndex.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person),
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
                        name,
                        style: TextStyle(fontSize: cellFont),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Rol traducido
                  SizedBox(
                    width: colRoleW,
                    child: Center(
                      child: Text(
                        translateRole(role),
                        style: TextStyle(fontSize: cellFont),
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Tutor (nombre real)
                  SizedBox(
                    width: colTutorW,
                    child: Center(
                      child: tutorId == null || tutorId.toString().isEmpty
                          ? const Text('-')
                          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(_collectionName)
                            .where('id', isEqualTo: tutorId)
                            .where('role', isEqualTo: 'tutor')
                            .limit(1)
                            .snapshots(),
                        builder: (context, snap) {
                          if (!snap.hasData || snap.data!.docs.isEmpty) {
                            return const Text('-');
                          }
                          final tutorData = snap.data!.docs.first.data();
                          return Text(
                            tutorData['name'] ?? '-',
                            style: TextStyle(fontSize: cellFont),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: colGap),

                  // Acciones
                  SizedBox(
                    width: colActionsW,
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
                                pageBuilder: (_, __, ___) =>
                                    DeleteUsersScreen(userName: name),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: btnGap),
                        actionPill(
                          label: 'Desactivar',
                          bg: _btnDisable,
                          fg: Colors.white,
                          width: secBtnW,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black38,
                                pageBuilder: (_, __, ___) =>
                                    DesactivateUsersScreen(
                                      userName: name,
                                      isActive: active,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
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

                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection(_collectionName)
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Column(
                      children: snap.data!.docs.map((d) {
                        final data = d.data();
                        return rowItem(
                          docId: d.id,
                          name: data['name'] ?? '(sin nombre)',
                          role: data['role'] ?? '',
                          tutorId: data['tutorId'],
                          avatarIndex: data['avatarIndex'] ?? 0,
                        );
                      }).toList(),
                    );
                  },
                ),

                SizedBox(height: pagePad * 0.8),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _btnCreate,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CrearUsuarioScreen()),
                    );
                  },
                  child: const Text('Crear usuario'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
