import 'package:flutter/material.dart';
import 'manage_users_screen.dart'; // 👈 import de la nueva pantalla
import 'reset_passwords_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // Colores del boceto
  static const _blueAppBar  = Color(0xFF77A9F4);
  static const _blueTile    = Color(0xFF77A9F4);
  static const _blueCircle  = Color(0xFFD3E3FF);
  static const _textColor   = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: _textColor,
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
      // El truco: calcular tamaños con el alto/ancho real del BODY
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Siempre 2x2 como en el boceto
          const cols = 2;
          const rows = 2;

          // Márgenes y separación proporcionales (con límites)
          final width  = constraints.maxWidth;
          final height = constraints.maxHeight;

          final padding = _clampDouble(width * 0.04, 12, 28); // ext/int
          final spacing = _clampDouble(width * 0.035, 10, 24);

          // Área efectiva
          final gridWidth  = width  - padding * 2;
          final gridHeight = height - padding * 2;

          // Tamaño exacto de celda para que NO haya scroll
          final tileWidth  = (gridWidth  - spacing * (cols - 1)) / cols;
          final tileHeight = (gridHeight - spacing * (rows - 1)) / rows;

          // Relación de aspecto perfecta para el Grid
          final childAspectRatio = tileWidth / tileHeight;

          // Escala para iconos/textos a partir del lado “pequeño” de la celda
          final base = tileWidth < tileHeight ? tileWidth : tileHeight;

          final circleSize = _clampDouble(base * 0.42, 44, 82);
          final iconSize   = _clampDouble(circleSize * 0.52, 20, 40);
          final fontSize   = _clampDouble(base * 0.14, 14, 20);
          final borderR    = _clampDouble(base * 0.12, 10, 20);
          final innerPad   = _clampDouble(base * 0.14, 12, 22);
          final gapY       = _clampDouble(base * 0.12, 10, 20);

          // Título también responsivo
          final appBarTitleSize =
          _clampDouble(width * 0.035, 18, 26); // móvil→desktop
          // Forzar tamaño del título envolviendo en Theme
          final themed = Theme.of(context).copyWith(
            appBarTheme: Theme.of(context).appBarTheme.copyWith(
              titleTextStyle: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                fontSize: appBarTitleSize,
              ),
            ),
          );

          return Theme(
            data: themed,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: GridView.count(
                crossAxisCount: cols,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                physics: const NeverScrollableScrollPhysics(), // sin scroll
                childAspectRatio: childAspectRatio,
                children: [
                  // 👉 Aquí añadimos la navegación
                  _AdminCard(
                    icon: Icons.settings_outlined,
                    label: 'Gestionar usuarios',
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    borderRadius: borderR,
                    innerPadding: innerPad,
                    gapY: gapY,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageUsersScreen(),
                        ),
                      );
                    },
                  ),
                  _AdminCard(
                    icon: Icons.group_outlined,
                    label: 'Vincular usuarios',
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    borderRadius: borderR,
                    innerPadding: innerPad,
                    gapY: gapY,
                  ),
                  _AdminCard(
                    icon: Icons.folder_open_outlined,
                    label: 'Registro de\nusuarios',
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    borderRadius: borderR,
                    innerPadding: innerPad,
                    gapY: gapY,
                  ),
                  _AdminCard(
                    icon: Icons.close_outlined,
                    label: 'Restablecer\ncontraseñas',
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    borderRadius: borderR,
                    innerPadding: innerPad,
                    gapY: gapY,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResetPasswordsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static double _clampDouble(double v, double min, double max) {
    if (v < min) return min;
    if (v > max) return max;
    return v;
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.label,
    required this.circleSize,
    required this.iconSize,
    required this.fontSize,
    required this.borderRadius,
    required this.innerPadding,
    required this.gapY,
    this.onTap, // 👈 NUEVO
  });

  final IconData icon;
  final String label;
  final double circleSize;
  final double iconSize;
  final double fontSize;
  final double borderRadius;
  final double innerPadding;
  final double gapY;
  final VoidCallback? onTap; // 👈 NUEVO

  static const _blueTile   = AdminScreen._blueTile;
  static const _blueCircle = AdminScreen._blueCircle;
  static const _textColor  = AdminScreen._textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _blueTile,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap, // 👈 ahora usa la callback si viene
        child: Padding(
          padding: EdgeInsets.all(innerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: const BoxDecoration(
                  color: _blueCircle,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: iconSize, color: Colors.black87),
              ),
              SizedBox(height: gapY),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
