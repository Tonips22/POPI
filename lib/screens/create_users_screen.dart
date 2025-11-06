import 'package:flutter/material.dart';

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _text       = Colors.black;

  // Controladores de los campos
  final _nombreCtrl = TextEditingController();
  final _rolCtrl    = TextEditingController();
  final _tutorCtrl  = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _rolCtrl.dispose();
    _tutorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _blueAppBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'ADMINISTRADOR',
          style: TextStyle(
            color: _text,
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

          // Márgenes generales
          final pagePad   = clamp(w * 0.06, 20, 56);

          // Píldora (idéntica a gestionar)
          final pillPadH  = clamp(w * 0.035, 18, 28);
          final pillPadV  = clamp(w * 0.010, 8, 12);
          final pillRad   = clamp(w * 0.022, 10, 16);
          final pillFont  = clamp(base * 0.030, 16, 22);

          // Contenedor central (el conjunto queda centrado en la página)
          final contentW  = clamp(w * 0.80, 520, 820);

          // Foto más grande con borde negro
          final photoSize = clamp(base * 0.22, 110, 170);
          final photoRad  = clamp(14, 12, 16);
          final photoGap  = clamp(base * 0.018, 10, 16);
          final photoLabel= clamp(base * 0.026, 15, 20);

          // Campos más grandes y más a la izquierda dentro del bloque centrado
          final labelW    = clamp(base * 0.22, 120, 160);
          final labelFont = clamp(base * 0.030, 16, 20);
          final fieldH    = clamp(base * 0.070, 44, 56);
          final fieldRad  = clamp(8, 6, 10);
          final rowGap    = clamp(base * 0.020, 12, 18);

          // Botón verde (mismo tamaño que en gestionar usuarios)
          final btnPadH   = 40.0; // igual que allí
          final btnPadV   = 18.0;
          final btnFont   = 18.0;
          final btnRad    = 10.0;

          return Padding(
            padding: EdgeInsets.all(pagePad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora título
                Container(
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRad),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: pillPadH,
                    vertical: pillPadV,
                  ),
                  child: Text(
                    'Crear usuarios',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: pillFont,
                    ),
                  ),
                ),
                SizedBox(height: clamp(base * 0.050, 24, 36)),

                Center(
                  child: SizedBox(
                    width: contentW,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto centrada dentro del bloque
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: photoSize,
                                height: photoSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(photoRad.toDouble()),
                                  border: Border.all(color: Colors.black, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: photoGap),
                              Text(
                                'Foto',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: photoLabel,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: clamp(base * 0.045, 20, 34)),

                        _FieldRow(
                          label: 'Nombre',
                          labelWidth: labelW,
                          labelFont: labelFont,
                          fieldHeight: fieldH,
                          fieldRadius: fieldRad,
                          controller: _nombreCtrl,
                          hintText: 'Introduce el nombre',
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: rowGap),
                        _FieldRow(
                          label: 'Rol',
                          labelWidth: labelW,
                          labelFont: labelFont,
                          fieldHeight: fieldH,
                          fieldRadius: fieldRad,
                          controller: _rolCtrl,
                          hintText: 'Estudiante / Profesor…',
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: rowGap),
                        _FieldRow(
                          label: 'Tutor',
                          labelWidth: labelW,
                          labelFont: labelFont,
                          fieldHeight: fieldH,
                          fieldRadius: fieldRad,
                          controller: _tutorCtrl,
                          hintText: 'Nombre del tutor (si aplica)',
                          textInputAction: TextInputAction.done,
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: btnPadH,
                                vertical: btnPadV,
                              ),
                              textStyle: TextStyle(
                                fontSize: btnFont,
                                fontWeight: FontWeight.w700,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(btnRad),
                              ),
                            ),
                            onPressed: () {
                              // TODO: lógica real de creación (API/estado)
                              // Por ahora, mostramos un resumen rápido:
                              final nombre = _nombreCtrl.text.trim();
                              final rol    = _rolCtrl.text.trim();
                              final tutor  = _tutorCtrl.text.trim();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Creado: $nombre | $rol | ${tutor.isEmpty ? "—" : tutor}'),
                                ),
                              );
                            },
                            child: const Text('Crear usuario'),
                          ),
                        ),
                      ],
                    ),
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

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.labelWidth,
    required this.labelFont,
    required this.fieldHeight,
    required this.fieldRadius,
    required this.controller,
    required this.hintText,
    required this.textInputAction,
  });

  final String label;
  final double labelWidth;
  final double labelFont;
  final double fieldHeight;
  final double fieldRadius;

  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: labelFont,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: SizedBox(
            height: fieldHeight,
            child: TextField(
              controller: controller,
              textInputAction: textInputAction,
              style: TextStyle(
                fontSize: labelFont,
                color: Colors.black87,
                height: 1.1,
              ),
              cursorColor: Colors.black87,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.black54, fontSize: labelFont * 0.95),
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: (fieldHeight - labelFont) * 0.28,
                ),
                // Bordes redondeados sin línea visible (como tu caja gris)
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: const BorderSide(color: Colors.black54, width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
