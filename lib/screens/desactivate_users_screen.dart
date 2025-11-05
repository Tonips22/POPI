import 'package:flutter/material.dart';

class DesactivateUsersScreen extends StatelessWidget {
  const DesactivateUsersScreen({
    super.key,
    required this.userName,
    required this.isActive,
  });

  final String userName;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final accion = isActive ? 'desactivar' : 'activar';

    return Scaffold(
      backgroundColor: Colors.transparent, // fondo lo pone el route (barrierColor)
      body: Center(
        child: _DialogCard(
          text: '¿Estás seguro de que quieres\n$accion a $userName?',
          onYes: () {
            // TODO: aquí iría lógica real (API/estado)
            Navigator.pop(context);
          },
          onNo: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _DialogCard extends StatelessWidget {
  const _DialogCard({
    required this.text,
    required this.onYes,
    required this.onNo,
  });

  final String text;
  final VoidCallback onYes;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double clamp(double v, double min, double max) =>
        v < min ? min : (v > max ? max : v);

    final cardW   = clamp(w * 0.78, 320, 620);
    final padX    = clamp(w * 0.04, 18, 28);
    final padY    = clamp(w * 0.03, 16, 22);
    final radius  = 16.0;
    final gapY    = 22.0;

    final btnW    = clamp(w * 0.24, 110, 150);
    final btnH    = 46.0;
    final btnGap  = 24.0;
    final fontQ   = clamp(w * 0.045, 18, 22);
    final fontBtn = 18.0;

    return Container(
      width: cardW,
      padding: EdgeInsets.symmetric(horizontal: padX, vertical: padY),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black54, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontQ,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          SizedBox(height: gapY),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DialogButton(
                label: 'Sí',
                width: btnW,
                height: btnH,
                fontSize: fontBtn,
                onTap: onYes,
              ),
              SizedBox(width: btnGap),
              _DialogButton(
                label: 'No',
                width: btnW,
                height: btnH,
                fontSize: fontBtn,
                onTap: onNo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.onTap,
  });

  final String label;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
