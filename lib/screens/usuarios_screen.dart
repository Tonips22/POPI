import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  // Controladores para el formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tutorController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  bool _activo = true;

  // Referencia a la colección de usuarios
  final CollectionReference usuariosRef =
  FirebaseFirestore.instance.collection('usuarios');

  /// Añadir nuevo usuario a Firestore
  Future<void> _agregarUsuario() async {
    if (_nombreController.text.trim().isEmpty ||
        _tutorController.text.trim().isEmpty ||
        _rolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    await usuariosRef.add({
      'nombre': _nombreController.text.trim(),
      'tutor': _tutorController.text.trim(),
      'rol': _rolController.text.trim(),
      'activo': _activo,
      'fecha_creacion': FieldValue.serverTimestamp(),
    });

    // Limpia el formulario
    _nombreController.clear();
    _tutorController.clear();
    _rolController.clear();
    setState(() => _activo = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Formulario para crear usuario
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _tutorController,
                      decoration: const InputDecoration(labelText: 'Tutor'),
                    ),
                    TextField(
                      controller: _rolController,
                      decoration: const InputDecoration(labelText: 'Rol'),
                    ),
                    SwitchListTile(
                      title: const Text('Activo'),
                      value: _activo,
                      onChanged: (v) => setState(() => _activo = v),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _agregarUsuario,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Usuario'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Lista en tiempo real de usuarios
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usuariosRef.orderBy('fecha_creacion', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay usuarios registrados.'));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final usuario = docs[index].data() as Map<String, dynamic>;

                      return ListTile(
                        leading: Icon(
                          usuario['activo'] == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: usuario['activo'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(usuario['nombre'] ?? 'Sin nombre'),
                        subtitle: Text(
                          'Tutor: ${usuario['tutor'] ?? ''} | Rol: ${usuario['rol'] ?? ''}',
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
