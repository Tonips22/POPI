import 'package:flutter/material.dart';
import '/services/app_service.dart';
import '/models/user_model.dart';
import 'dart:math' as math;

class LoginScreenExample extends StatefulWidget {
  const LoginScreenExample({super.key});

  @override
  State<LoginScreenExample> createState() => _LoginScreenExampleState();
}

class _LoginScreenExampleState extends State<LoginScreenExample> {
  final AppService _service = AppService();

  List<UserModel> _students = [];
  bool _isLoading = true;
  int? _selectedIndex;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      List<UserModel> students = await _service.getStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onStudentSelected(UserModel student, int index) async {
    setState(() => _selectedIndex = index);
    _service.login(student);
    
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/games');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;
            final double h = constraints.maxHeight;

            final bool isDesktop = w >= 1200;
            final bool needScroll = h < 650;

            const double kMaxContentWidth = 1200.0;
            final double hMargin = (w * 0.08).clamp(24, 250);

            final double titleFont = (w * 0.08).clamp(60, 100);
            final double titleLetterSpacing = (w * 0.012).clamp(8, 20);
            final double sectionTitle = (w * 0.025).clamp(18, 24);
            final double gridSpacing = (w * 0.015).clamp(12, 20);
            final double bluePadV = (w * 0.02).clamp(16, 28);
            final double bluePadH = (w * 0.025).clamp(16, 28);

            final int gridCols = isDesktop ? 4 : 3;

            final double contentWidth = math.min(w, kMaxContentWidth) - 2 * hMargin;
            final double gridWidth = contentWidth - 2 * bluePadH;
            final double cellWidth = (gridWidth - (gridCols - 1) * gridSpacing) / gridCols;
            final double iconSize = (cellWidth * 0.65).clamp(72, 150);

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
                      // Título POPI
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

                      // Card azul con alumnos
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

                            _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : _students.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(40.0),
                                        child: Text(
                                          'No hay alumnos registrados',
                                          style: TextStyle(
                                            fontSize: sectionTitle * 0.8,
                                          ),
                                        ),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: gridCols,
                                          crossAxisSpacing: gridSpacing,
                                          mainAxisSpacing: gridSpacing,
                                          childAspectRatio: 1,
                                        ),
                                        itemCount: _students.length,
                                        itemBuilder: (context, index) {
                                          final student = _students[index];
                                          return MouseRegion(
                                            onEnter: (_) =>
                                                setState(() => _hoveredIndex = index),
                                            onExit: (_) =>
                                                setState(() => _hoveredIndex = null),
                                            child: InkWell(
                                              onTap: () => _onStudentSelected(student, index),
                                              borderRadius: BorderRadius.circular(999),
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              splashFactory: NoSplash.splashFactory,
                                              child: Center(
                                                child: AnimatedOpacity(
                                                  duration: const Duration(milliseconds: 150),
                                                  opacity: (_hoveredIndex == index ||
                                                          _selectedIndex == index)
                                                      ? 0.6
                                                      : 1.0,
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      'assets/images/avatar${(student.avatarIndex % 4) + 1}.png',
                                                      width: iconSize * 1.5,
                                                      height: iconSize * 1.5,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Icon(
                                                          Icons.account_circle,
                                                          size: iconSize * 1.5,
                                                          color: Colors.white,
                                                        );
                                                      },
                                                    ),
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
                    ],
                  ),
                ),
              ),
            );

            if (needScroll) {
              return SingleChildScrollView(child: content);
            } else {
              return content;
            }
          },
        ),
      ),
    );
  }
}