import 'package:flutter/material.dart';

class VinculateUsersScreen extends StatefulWidget {
  const VinculateUsersScreen({super.key});

  @override
  State<VinculateUsersScreen> createState() => _VinculateUsersScreenState();
}

class _VinculateUsersScreenState extends State<VinculateUsersScreen> {
  // Colores coherentes con el resto de pantallas
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);
  static const _listBg     = Color(0xFFFFF5FF); // fondo rosita claro
  static const _btnApply   = Color(0xFF2E7D32); // mismo verde de "Crear usuario"
  static const _checkColor = Color(0xFF673AB7); // morado para los checks

  final ScrollController _scrollController = ScrollController();

  // Valor del desplegable (en el boceto solo sale "Tutor")
  final List<String> _roles = ['Jose', 'Pablo', 'Rosa', 'Maria', 'Pepe'];
  String _selectedRole = 'Jose';

  // Lista de alumnos de ejemplo (los del boceto)
  final List<_StudentLink> _students = [
    _StudentLink('Pepe García'),
    _StudentLink('María Ruiz'),
    _StudentLink('Lucas Romero'),
    _StudentLink('Luis Sánchez'),
    _StudentLink('Bea Fernández'),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
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
          final w    = c.maxWidth;
          final h    = c.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          // Márgenes de la página
          final pagePad   = clamp(w * 0.08, 24, 60);

          // Píldora “Vincular usuarios”
          final pillPadH  = clamp(w * 0.03, 14, 22);
          final pillPadV  = clamp(w * 0.008, 6, 10);
          final pillRad   = clamp(w * 0.02, 10, 16);
          final pillFont  = clamp(base * 0.026, 14, 20);

          // Bloque del desplegable
          final labelFont   = clamp(base * 0.028, 16, 22);
          final helperFont  = clamp(base * 0.018, 11, 14);
          final dropdownW   = clamp(w * 0.32, 220, 340);

          // Lista de alumnos
          final listRadius  = clamp(w * 0.03, 16, 26);
          final rowHeight   = clamp(base * 0.075, 42, 58);
          final nameFont    = clamp(base * 0.026, 15, 19);

          // Botón “Aplicar cambios”
          final btnHeight   = clamp(base * 0.09, 44, 56);
          final btnFont     = clamp(base * 0.028, 15, 19);
          final btnPadH     = clamp(w * 0.05, 40, 80);

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pagePad,
              vertical: pagePad * 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora superior
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pillPadH,
                    vertical: pillPadV,
                  ),
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRad),
                  ),
                  child: Text(
                    'Vincular usuarios',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: pillFont,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: pagePad * 0.9),

                // Selector de rol (Tutor) + texto explicativo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tutor',
                      style: TextStyle(
                        fontSize: labelFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: dropdownW,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedRole,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: _roles
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: labelFont,
                                      ),
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Seleccione los alumnos a vincular y confirme.',
                            style: TextStyle(
                              fontSize: helperFont,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: pagePad * 0.8),

                // Lista de alumnos + scroll
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _listBg,
                      borderRadius: BorderRadius.circular(listRadius),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      thickness: 6,
                      radius: const Radius.circular(20),
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: clamp(w * 0.06, 22, 40),
                          vertical: clamp(h * 0.03, 12, 18),
                        ),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final s = _students[index];
                          return SizedBox(
                            height: rowHeight,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.name,
                                    style: TextStyle(
                                      fontSize: nameFont,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: s.selected,
                                  onChanged: (value) {
                                    setState(() {
                                      s.selected = value ?? false;
                                    });
                                  },
                                  side: const BorderSide(
                                    color: _checkColor,
                                    width: 2,
                                  ),
                                  activeColor: _checkColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: pagePad * 0.8),

                // Botón "Aplicar cambios"
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: btnHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnApply,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnHeight * 0.4),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: btnPadH),
                      ),
                      onPressed: () {
                        final total = _students.length;
                        final selected = _students.where((s) => s.selected).length;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Vinculados $selected de $total alumnos al rol $_selectedRole (solo simulación).',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Aplicar cambios',
                        style: TextStyle(
                          fontSize: btnFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

class _StudentLink {
  _StudentLink(this.name, {this.selected = true});

  final String name;
  bool selected;
}
