import 'package:flutter/material.dart';

class DeleteUsersScreen extends StatelessWidget {
  const DeleteUsersScreen({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _DialogCard(
          text: '¿Estás seguro de que quieres\neliminar a $userName?',
          onYes: () {
            // TODO: aquí va la lógica real de borrado (API/estado)
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
                borderColor: const Color(0xFFE53935),
                labelColor: const Color(0xFFE53935),
                onTap: onYes,
              ),
              SizedBox(width: btnGap),
              _DialogButton(
                label: 'No',
                width: btnW,
                height: btnH,
                fontSize: fontBtn,
                borderColor: Colors.black87,
                labelColor: Colors.black,
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
    required this.borderColor,
    required this.labelColor,
  });

  final String label;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onTap;
  final Color borderColor;
  final Color labelColor;

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
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
        ),
      ),
    );
  }
}
