import 'package:flutter/material.dart';

class UsuarioDetallesScreen extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const UsuarioDetallesScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Nombre', usuario['name'] ?? 'N/A'),
            _buildDetailRow('Rol', usuario['role'] ?? 'N/A'),
            _buildDetailRow('Fecha de creación', usuario['createdAt'] ?? 'N/A'),
            _buildDetailRow('Tutor', usuario['tutor'] ?? 'N/A'),
            _buildDetailRow('Permite personalizar', (usuario['permitir_personalizar'] ?? false) ? 'Sí' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}