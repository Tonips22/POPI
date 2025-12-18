import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioDetallesScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const UsuarioDetallesScreen({super.key, required this.usuario});

  @override
  State<UsuarioDetallesScreen> createState() => _UsuarioDetallesScreenState();
}

class _UsuarioDetallesScreenState extends State<UsuarioDetallesScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);

  late final Map<String, dynamic> _user;
  late final Map<String, dynamic> _prefs;

  @override
  void initState() {
    super.initState();
    _user = widget.usuario;

    // Preferencias pueden venir:
    // - como mapa anidado: usuario['preferences']
    // - o como campos sueltos (si lo hicieras así en algún punto)
    _prefs = (_user['preferences'] is Map<String, dynamic>)
        ? Map<String, dynamic>.from(_user['preferences'])
        : <String, dynamic>{};
  }

  // ----------------------------
  // Helpers de formato/lectura
  // ----------------------------
  String _translateRole(dynamic role) {
    final r = (role ?? '').toString().trim().toLowerCase();
    switch (r) {
      case 'student':
        return 'Estudiante';
      case 'tutor':
        return 'Tutor';
      case 'admin':
        return 'Administrador';
      default:
        return r.isEmpty ? 'N/A' : role.toString();
    }
  }

  String _asString(dynamic v) {
    if (v == null) return 'N/A';
    if (v is Timestamp) {
      final date = v.toDate();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return v.toString();
  }

  bool _asBool(dynamic v, {bool fallback = false}) {
    if (v == null) return fallback;
    if (v is bool) return v;
    final s = v.toString().toLowerCase().trim();
    if (s == 'true' || s == '1' || s == 'yes' || s == 'sí' || s == 'si') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
    return fallback;
  }

  // Acepta "0xFF2196F3", "#2196F3", "2196F3", "0xFFFFFFFF", etc.
  Color? _parseColor(dynamic value) {
    if (value == null) return null;

    String s = value.toString().trim();
    if (s.isEmpty) return null;

    // Quitar comillas por si viene como '"0xFF..."'
    s = s.replaceAll('"', '').replaceAll("'", '');

    if (s.startsWith('#')) {
      s = s.substring(1);
    }

    if (s.startsWith('0x') || s.startsWith('0X')) {
      // 0xAARRGGBB
      try {
        final intColor = int.parse(s.substring(2), radix: 16);
        return Color(intColor);
      } catch (_) {
        return null;
      }
    }

    // Si viene como RRGGBB -> asumimos FF + RRGGBB
    // Si viene como AARRGGBB -> lo usamos tal cual
    try {
      if (s.length == 6) {
        return Color(int.parse('FF$s', radix: 16));
      }
      if (s.length == 8) {
        return Color(int.parse(s, radix: 16));
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  // ----------------------------
  // Tutor lookup
  // ----------------------------
  Future<String> _fetchTutorName() async {
    final tutorId = _user['tutorId'] ?? _user['tutor_id'] ?? _user['tutor'];
    if (tutorId == null) return 'N/A';

    final String tid = tutorId.toString();

    try {
      final q = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: tid)
          .where('role', isEqualTo: 'tutor')
          .limit(1)
          .get();

      if (q.docs.isEmpty) return 'N/A';
      final data = q.docs.first.data();
      return (data['name'] ?? 'N/A').toString();
    } catch (_) {
      return 'N/A';
    }
  }

  // ----------------------------
  // UI blocks
  // ----------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _boolRow(String label, dynamic value) {
    final b = _asBool(value, fallback: false);
    return _detailRow(label, b ? 'Sí' : 'No');
  }

  Widget _colorRow(String label, dynamic value) {
    final code = _asString(value);
    final color = _parseColor(value);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (color != null) ...[
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26),
              ),
            ),
          ],
          Expanded(child: Text(code)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Campos principales (aguantando nombres alternativos)
    final name = _asString(_user['name'] ?? _user['nombre']);
    final roleEs = _translateRole(_user['role'] ?? _user['rol']);

    final createdAt = _user['created_at'] ?? _user['createdAt'] ?? _user['fecha_creacion'];
    final createdAtStr = _asString(createdAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detalles del usuario',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: _blueAppBar,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _sectionTitle('Usuario'),
            _detailRow('Nombre', name),
            _detailRow('Rol', roleEs),
            _detailRow('Fecha de creación', createdAtStr),

            FutureBuilder<String>(
              future: _fetchTutorName(),
              builder: (context, snap) {
                final tutorName = (snap.connectionState == ConnectionState.done)
                    ? (snap.data ?? 'N/A')
                    : 'Cargando...';
                return _detailRow('Tutor', tutorName);
              },
            ),

            _sectionTitle('Preferencias'),

            _colorRow('Color de fondo', _prefs['backgroundColor']),
            _boolRow('Puede customizar', _prefs['canCustomize']),
            _detailRow('Fuente', _asString(_prefs['fontFamily'])),
            _detailRow('Tamaño fuente', _asString(_prefs['fontSize'])),
            _colorRow('Color primario', _prefs['primaryColor']),
            _colorRow('Color secundario', _prefs['secondaryColor']),
            _detailRow('Forma', _asString(_prefs['shape'])),

            _detailRow('Rondas tocar número', _asString(_prefs['touchGameRounds'])),
            _detailRow('Rondas ordenar secuencia', _asString(_prefs['sortGameRounds'])),
            _detailRow('Rondas repartir números', _asString(_prefs['shareGameRounds'])),
            _detailRow('Rondas deja el mismo número', _asString(_prefs['subtractGameRounds'])),
            _boolRow('Mostrar tutorial juego 1', _prefs['showTutorialJuego1']),
            _boolRow('Mostrar tutorial juego 2', _prefs['showTutorialJuego2']),
            _boolRow('Mostrar tutorial juego 3', _prefs['showTutorialJuego3']),
            _boolRow('Mostrar tutorial juego 4', _prefs['showTutorialJuego4']),
            _detailRow('Tipo de reacción', _asString(_prefs['tipo_reaccion'])),
            _detailRow('Texto de voz', _asString(_prefs['voiceText'])),
          ],
        ),
      ),
    );
  }
}
