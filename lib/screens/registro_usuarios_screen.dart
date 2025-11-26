import 'dart:math';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_options.dart';

class RegistroUsuariosScreen extends StatelessWidget {
  const RegistroUsuariosScreen({super.key});

  // Colores base (alineados con tu ManageUsersScreen)
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _theadBg    = Color(0xFFD9D9D9);
  static const _btnDetails = Color(0xFF2E7D32); // verde

  Future<void> _initFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    final app = Firebase.app();
    // DEBUG corto
    // ignore: avoid_print
    print('🔥 Firebase conectado a projectId: ${app.options.projectId}');
    // ignore: avoid_print
    print('🔥 Apps registradas: ${Firebase.apps.map((a) => a.name).toList()}');

    // Por si algún día hubiera emulador por env
    // ignore: avoid_print
    print('🌐 ENV FIRESTORE_EMULATOR_HOST = ${Platform.environment['FIRESTORE_EMULATOR_HOST']}');
    // ignore: avoid_print
    print('🌐 ENV FIREBASE_EMULATOR_HOST = ${Platform.environment['FIREBASE_EMULATOR_HOST']}');
    // ignore: avoid_print
    print('🌐 ENV FIREBASE_FIRESTORE_EMULATOR_ADDRESS = ${Platform.environment['FIREBASE_FIRESTORE_EMULATOR_ADDRESS']}');

    // Si quisieras desactivar caché, podrías hacerlo aquí:
    // FirebaseFirestore.instance.settings = const Settings(
    //   persistenceEnabled: false,
    // );

    final settings = FirebaseFirestore.instance.settings;
    // ignore: avoid_print
    print('⚙️ Firestore settings: host=${settings.host}, '
        'sslEnabled=${settings.sslEnabled}, '
        'persistenceEnabled=${settings.persistenceEnabled}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error al inicializar Firebase:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return _buildLayout(context);
      },
    );
  }

  Widget _buildLayout(BuildContext context) {
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
          'REGISTRO DE USUARIOS',
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
          final base = min(w, h);

          double clampDouble(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad   = clampDouble(w * 0.08, 24, 60);

          final pillPadH  = clampDouble(w * 0.03, 14, 22);
          final pillPadV  = clampDouble(w * 0.008, 6, 10);
          final pillRadius= clampDouble(w * 0.02, 10, 16);
          final pillFont  = clampDouble(base * 0.026, 14, 20);

          final rowH      = clampDouble(base * 0.095, 44, 64);
          final avatar    = clampDouble(rowH * 0.74, 30, 52);
          final avatarR   = clampDouble(12, 8, 16);

          final headFont  = clampDouble(base * 0.025, 13, 17);
          final cellFont  = clampDouble(base * 0.026, 14, 18);

          final colGap    = clampDouble(w * 0.02, 12, 24);
          final btnH      = clampDouble(rowH * 0.62, 26, 40);
          final btnFont   = clampDouble(base * 0.022, 12, 15);
          final btnRadius = clampDouble(20, 14, 20);

          // Anchos de columnas
          final totalWidth = w - pagePad * 2;
          final colAvatarW = avatar;
          final colNameW   = totalWidth * 0.28;
          final colRoleW   = totalWidth * 0.22;
          final colTutorW  = totalWidth * 0.22;
          final colActionsW= totalWidth - (
              colAvatarW + colNameW + colRoleW + colTutorW + colGap * 4
          );

          final detailsBtnW = clampDouble(base * 0.22, 110, 140);

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
                          fontSize: headFont,
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
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colTutorW,
                    child: Center(
                      child: Text(
                        'Tutor',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: headFont,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: colGap),
                  SizedBox(
                    width: colActionsW,
                    child: Center(
                      child: Text(
                        'Acciones',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: headFont,
                        ),
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

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pagePad,
              vertical: pagePad * 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora "Registro de usuarios"
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
                    'Registro de usuarios',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: pillFont,
                    ),
                  ),
                ),
                SizedBox(height: pagePad * 0.8),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                    // cuando unifiques el campo de fecha, ya ordenamos aquí:
                    // .orderBy('fecha_creacion', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error cargando usuarios:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      // DEBUG stream
                      // ignore: avoid_print
                      print('🔥 Docs recibidos en /usuarios (stream): ${docs.length}');
                      for (final d in docs) {
                        // ignore: avoid_print
                        print('   → ${d.id} -> ${d.data()}');
                      }

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay usuarios registrados.',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          headerBar(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data = docs[index].data()
                                as Map<String, dynamic>;

                                final nombre =
                                (data['nombre'] ?? '') as String;
                                final rol =
                                (data['rol'] ?? '') as String;
                                final tutor =
                                (data['tutor'] ?? '') as String;
                                final activo =
                                (data['activo'] ?? false) as bool;

                                final avatarColor =
                                activo ? const Color(0xFFB6E2C8)
                                    : const Color(0xFFF6B7A4);

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
                                              BorderRadius.circular(
                                                  avatarR.toDouble()),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              nombre.isNotEmpty
                                                  ? nombre[0].toUpperCase()
                                                  : '?',
                                              style: TextStyle(
                                                fontSize: avatar * 0.58,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: colGap),
                                      SizedBox(
                                        width: colNameW,
                                        child: Center(
                                          child: Text(
                                            nombre.isNotEmpty
                                                ? nombre
                                                : docs[index].id,
                                            style: TextStyle(
                                              fontSize: cellFont,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: colGap),
                                      SizedBox(
                                        width: colRoleW,
                                        child: Center(
                                          child: Text(
                                            rol.isEmpty ? '—' : rol,
                                            style: TextStyle(
                                              fontSize: cellFont,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: colGap),
                                      SizedBox(
                                        width: colTutorW,
                                        child: Center(
                                          child: Text(
                                            tutor.isEmpty ? '—' : tutor,
                                            style: TextStyle(
                                              fontSize: cellFont,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: colGap),
                                      SizedBox(
                                        width: colActionsW,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: actionPill(
                                            label: 'Ver detalles',
                                            bg: _btnDetails,
                                            fg: Colors.white,
                                            width: detailsBtnW,
                                            onTap: () => _showDetailsDialog(
                                              context,
                                              docs[index].id,
                                              data,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
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

  void _showDetailsDialog(
      BuildContext context,
      String docId,
      Map<String, dynamic> data,
      ) {
    final nombre = (data['nombre'] ?? '') as String;
    final rol    = (data['rol'] ?? '') as String;
    final tutor  = (data['tutor'] ?? '') as String;
    final activo = (data['activo'] ?? false) as bool;
    final fecha  = data['fecha_creacion']?.toString() ??
        data['fechaCreacion']?.toString() ??
        '—';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(nombre.isEmpty ? docId : nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rol: ${rol.isEmpty ? "—" : rol}'),
            Text('Tutor: ${tutor.isEmpty ? "—" : tutor}'),
            Text('Estado: ${activo ? "Activo" : "Inactivo"}'),
            const SizedBox(height: 8),
            Text('fecha_creación: $fecha'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
