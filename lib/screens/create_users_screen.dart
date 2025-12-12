import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

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
  final _tutorCtrl  = TextEditingController();
  
  // Para el Dropdown de Rol (Sin Admin)
  String? _selectedRole;
  final List<String> _roles = ['Estudiante', 'Tutor'];

  // Para el Avatar
  int _selectedAvatarIndex = 0;
  final List<String> _avatarNames = ['avatar0','avatar1', 'avatar2', 'avatar3', 'avatar4', 'avatar5'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _tutorCtrl.dispose();
    super.dispose();
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            children: [
              const Text(
                'Elige un avatar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _avatarNames.length,
                  itemBuilder: (context, index) {
                    final avatarName = _avatarNames[index];
                    final isSelected = _selectedAvatarIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatarIndex = index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? _blueAppBar : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/$avatarName.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
          final fieldH    = clamp(base * 0.070, 48, 60); // Un poco más alto para el dropdown
          final fieldRad  = clamp(8, 6, 10);
          final rowGap    = clamp(base * 0.020, 16, 24); // Más espacio entre filas

          // Botón verde (mismo tamaño que en gestionar usuarios)
          final btnPadH   = 40.0; 
          final btnPadV   = 18.0;
          final btnFont   = 18.0;
          final btnRad    = 10.0;

          return SingleChildScrollView( // Añadido Scroll por si la pantalla es pequeña
            child: Padding(
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
                          // Selector de Avatar (Imagen Grande)
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: _showAvatarSelection,
                                  child: Container(
                                    width: photoSize,
                                    height: photoSize,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/${_avatarNames[_selectedAvatarIndex]}.png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: photoSize * 0.5,
                                            color: Colors.grey.shade400,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: photoGap),
                                Text(
                                  'Toca para cambiar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: photoLabel * 0.8,
                                    color: Colors.grey.shade600,
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
                            child: TextField(
                              controller: _nombreCtrl,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(fontSize: labelFont, color: Colors.black87),
                              decoration: _inputDecoration(
                                hintText: 'Introduce el nombre',
                                icon: Icons.person_outline,
                                fieldRadius: fieldRad,
                                labelFont: labelFont,
                              ),
                            ),
                          ),
                          SizedBox(height: rowGap),
                          
                          _FieldRow(
                            label: 'Rol',
                            labelWidth: labelW,
                            labelFont: labelFont,
                            fieldHeight: fieldH,
                            fieldRadius: fieldRad,
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              items: _roles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedRole = val),
                              style: TextStyle(fontSize: labelFont, color: Colors.black87),
                              decoration: _inputDecoration(
                                hintText: 'Selecciona un rol',
                                icon: Icons.school_outlined,
                                fieldRadius: fieldRad,
                                labelFont: labelFont,
                              ),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                            ),
                          ),
                          
                          SizedBox(height: rowGap),
                          _FieldRow(
                            label: 'Tutor',
                            labelWidth: labelW,
                            labelFont: labelFont,
                            fieldHeight: fieldH,
                            fieldRadius: fieldRad,
                            child: TextField(
                              controller: _tutorCtrl,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(fontSize: labelFont, color: Colors.black87),
                              decoration: _inputDecoration(
                                hintText: 'Nombre del tutor (si aplica)',
                                icon: Icons.supervisor_account_outlined,
                                fieldRadius: fieldRad,
                                labelFont: labelFont,
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 32),
            
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
                                elevation: 2,
                              ),
                              onPressed: () async {
                                final nombre = _nombreCtrl.text.trim();
                                final rol = _selectedRole;
                                
                                if (nombre.isEmpty || rol == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor, completa nombre y selecciona un rol'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
            
                                // Mostrar loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => const Center(child: CircularProgressIndicator()),
                                );
            
                                try {
                                  // Creamos un objeto temporal. El ID se ignorará en el servicio
                                  // porque generará uno nuevo numérico.
                                  final tempUser = UserModel(
                                    id: '', 
                                    name: nombre,
                                    role: _normalizeRole(rol),
                                    avatarIndex: _selectedAvatarIndex,
                                    preferences: UserPreferences(),
                                  );
            
                                  await UserService().createUser(tempUser);
            
                                  if (context.mounted) {
                                    Navigator.pop(context); // Cerrar loading
                                    Navigator.pop(context); // Cerrar pantalla
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Usuario "$nombre" creado con éxito'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context); // Cerrar loading
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al crear usuario: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Crear usuario'),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _normalizeRole(String displayRole) {
    if (displayRole == 'Estudiante') return 'student';
    if (displayRole == 'Tutor') return 'tutor';
    return 'student';
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    required double fieldRadius,
    required double labelFont,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black45, fontSize: labelFont * 0.9),
      prefixIcon: Icon(icon, color: Colors.black54),
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldRadius),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldRadius),
        borderSide: const BorderSide(color: Color(0xFF77A9F4), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
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
    required this.child,
  });

  final String label;
  final double labelWidth;
  final double labelFont;
  final double fieldHeight;
  final double fieldRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center, // Alineación vertical centrada
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: fieldHeight),
            child: child,
          ),
        ),
      ],
    );
  }
}

