import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔥 Iniciando Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase inicializado correctamente.');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Usuarios Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UsuariosScreen(),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController tutorCtrl = TextEditingController();
  final TextEditingController rolCtrl = TextEditingController();
  bool activo = true;

  Future<void> _agregarUsuario() async {
    final nombre = nombreCtrl.text.trim();
    final tutor = tutorCtrl.text.trim();
    final rol = rolCtrl.text.trim();

    if (nombre.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nombre': nombre,
        'tutor': tutor.isNotEmpty ? tutor : 'N/A',
        'rol': rol.isNotEmpty ? rol : 'usuario',
        'activo': activo,
        'fecha_creacion': DateTime.now(),
      });

      print("✅ Usuario '$nombre' añadido correctamente.");
      nombreCtrl.clear();
      tutorCtrl.clear();
      rolCtrl.clear();
      setState(() => activo = true);
    } catch (e) {
      print("❌ Error al crear usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuariosRef = FirebaseFirestore.instance.collection('usuarios');

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios (Firestore)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Formulario para crear usuario
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: tutorCtrl,
              decoration: const InputDecoration(labelText: 'Tutor'),
            ),
            TextField(
              controller: rolCtrl,
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            Row(
              children: [
                const Text('Activo: '),
                Switch(
                  value: activo,
                  onChanged: (v) => setState(() => activo = v),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _agregarUsuario,
              child: const Text('Añadir usuario'),
            ),
            const Divider(height: 30),

            // 🔹 Lista en tiempo real de usuarios
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usuariosRef
                    .orderBy('fecha_creacion', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final usuarios = snapshot.data!.docs;

                  if (usuarios.isEmpty) {
                    return const Center(child: Text('No hay usuarios.'));
                  }

                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final user =
                      usuarios[index].data() as Map<String, dynamic>;
                      final id = usuarios[index].id;

                      final fecha = (user['fecha_creacion'] as Timestamp?)?.toDate();
                      final fechaStr = fecha != null
                          ? '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}'
                          : 'Sin fecha';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            user['activo'] == true
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: user['activo'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(user['nombre'] ?? 'Sin nombre'),
                          subtitle: Text(
                            'Rol: ${user['rol'] ?? 'N/A'}\nTutor: ${user['tutor'] ?? 'N/A'}\nCreado: $fechaStr',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await usuariosRef.doc(id).delete();
                              print("🗑️ Usuario eliminado: $id");
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
