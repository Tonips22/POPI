import 'package:flutter/material.dart';
import 'create_profile_screen.dart';
import 'password_screen.dart';
import 'admin_screen.dart';
import 'dart:math' as math;
import '../widgets/preference_provider.dart';
import 'home_tutor_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int? _selectedIndex;
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;
            final double h = constraints.maxHeight;

            // Solo desktop/tablet
            final bool isDesktop = w >= 1200;
            final bool isTablet  = w < 1200;

            // Si la altura es muy pequeña (móvil o ventana muy baja), permitimos scroll.
            // En tablets normales NO habrá scroll.
            final bool needScroll = h < 650;

            // Mantener estética en pantallas grandes
            const double kMaxContentWidth = 1200.0;

            // Márgenes laterales del card azul
            final double hMargin = (w * 0.08).clamp(24, 250);

            // Tipos y espaciados
            final double titleFont = (w * 0.08).clamp(60, 100);
            final double titleLetterSpacing = (w * 0.012).clamp(8, 20);
            final double sectionTitle = (w * 0.025).clamp(18, 24);
            final double linksFont = (w * 0.02).clamp(16, 18);
            final double gridSpacing = (w * 0.015).clamp(12, 20);
            final double bluePadV = (w * 0.02).clamp(16, 28);
            final double bluePadH = (w * 0.025).clamp(16, 28);

            final int gridCols = isDesktop ? 4 : 3;

            // Ancho real del contenido para calcular el tamaño del icono
            final double contentWidth =
                math.min(w, kMaxContentWidth) - 2 * hMargin;
            final double gridWidth =
                contentWidth - 2 * bluePadH; // dentro del card azul
            final double cellWidth =
                (gridWidth - (gridCols - 1) * gridSpacing) / gridCols;

            // Icono más grande y proporcional a la celda
            final double iconSize = (cellWidth * 0.65).clamp(72, 150);

            // ==== CONTENIDO PRINCIPAL SIN SCROLL POR DEFECTO ====
            Widget content = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 6,
                    left: 24,
                    right: 24,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ====== TÍTULO POPI ======
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: math.max(20, titleLetterSpacing * 5),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 0.5),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'POPI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF2596BE),
                              fontSize: titleFont,
                              fontWeight: FontWeight.w900,
                              letterSpacing: titleLetterSpacing,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ====== CARD AZUL ======
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: hMargin),
                        padding: EdgeInsets.symmetric(
                          horizontal: bluePadH,
                          vertical: bluePadV,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x802596BE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sectionTitle,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridCols,
                                crossAxisSpacing: gridSpacing,
                                mainAxisSpacing: gridSpacing,
                                childAspectRatio: 1,
                              ),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => _hoveredIndex = index),
                                  onExit: (_) =>
                                      setState(() => _hoveredIndex = null),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() => _selectedIndex = index);

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PasswordScreen(),
                                        ),
                                      );

                                      if (mounted) {
                                        setState(() => _selectedIndex = null);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    child: Center(
                                      child: AnimatedOpacity(
                                        duration:
                                        const Duration(milliseconds: 150),
                                        opacity: (_hoveredIndex == index ||
                                            _selectedIndex == index)
                                            ? 0.6
                                            : 1.0,
                                        child: Icon(
                                          Icons.account_circle,
                                          size: iconSize * 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ====== ENLACES A LOS EXTREMOS ======
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: hMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TutorHomeScreen()),
                                );
                              },
                              child: Text(
                                'Iniciar sesión como tutor',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: linksFont,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AdminScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Iniciar sesión como administrador',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: linksFont,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            // Si la pantalla es muy bajita -> scroll. En tablets normales -> sin scroll.
            if (needScroll) {
              return SingleChildScrollView(
                child: content,
              );
            } else {
              return content;
            }
          },
        ),
      ),
    );
  }
}
