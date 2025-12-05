import 'package:flutter/material.dart';
import '/services/app_service.dart';
import '/models/user_model.dart';
import '/screens/home_tutor_screen.dart';
import '/screens/admin_screen.dart';
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
            final double sectionTitle = (w * 0.035).clamp(28, 40);
            final double gridSpacing = (w * 0.025).clamp(20, 32);
            final double logoSize = (w * 0.25).clamp(200, 350);
            final double linksFont = (w * 0.02).clamp(16, 18);

            const int gridCols = 3;

            final double contentWidth = math.min(w, kMaxContentWidth);
            final double cellWidth = (contentWidth - (gridCols - 1) * gridSpacing) / gridCols;
            final double avatarSize = (cellWidth * 0.55).clamp(120, 180);
            final double nameFont = (w * 0.018).clamp(16, 20);

            Widget content = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo POPI
                      SizedBox(
                        width: logoSize,
                        child: Image.asset(
                          'assets/images/popi-logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback al texto si no existe el logo
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: math.max(20, titleLetterSpacing * 5),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 0.5),
                              ),
                              child: Text(
                                'POPI',
                                style: TextStyle(
                                  color: const Color(0xFF2596BE),
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: titleLetterSpacing,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Título "¿Quién eres?"
                      Text(
                        '¿Quién eres?',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: sectionTitle,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Grid de alumnos sin panel
                      _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(60.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF2596BE),
                                strokeWidth: 3,
                              ),
                            )
                          : _students.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(60.0),
                                  child: Text(
                                    'No hay alumnos registrados',
                                    style: TextStyle(
                                      fontSize: sectionTitle * 0.7,
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gridCols,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: _students.length,
                                  itemBuilder: (context, index) {
                                    final student = _students[index];
                                    final isHovered = _hoveredIndex == index;
                                    final isSelected = _selectedIndex == index;
                                    
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
                                        child: Center(
                                          child: AnimatedScale(
                                            scale: isHovered || isSelected ? 1.05 : 1.0,
                                            duration: const Duration(milliseconds: 200),
                                            curve: Curves.easeInOut,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Avatar
                                                AnimatedOpacity(
                                                  opacity: isSelected ? 0.7 : 1.0,
                                                  duration: const Duration(milliseconds: 150),
                                                  child: Container(
                                                    width: avatarSize,
                                                    height: avatarSize,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: isHovered || isSelected
                                                              ? const Color(0xFF2596BE).withOpacity(0.5)
                                                              : Colors.black.withOpacity(0.2),
                                                          offset: const Offset(0, 4),
                                                          blurRadius: isHovered || isSelected ? 16 : 8,
                                                          spreadRadius: isHovered || isSelected ? 2 : 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/avatar${(student.avatarIndex % 6) + 0}.png',
                                                        width: avatarSize,
                                                        height: avatarSize,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            width: avatarSize,
                                                            height: avatarSize,
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xFF2596BE),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.account_circle,
                                                              size: avatarSize * 0.9,
                                                              color: Colors.white,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                                const SizedBox(height: 12),
                                                
                                                // Nombre del estudiante
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  child: Text(
                                                    student.name,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: nameFont,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      
                      const SizedBox(height: 40),
                      
                      // Enlaces tutor y administrador
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: hMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TutorHomeScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Iniciar sesión como tutor',
                                style: TextStyle(
                                  color: const Color(0xFF2596BE),
                                  fontSize: linksFont,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF2596BE),
                                  fontWeight: FontWeight.w500,
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
                                  color: const Color(0xFF2596BE),
                                  fontSize: linksFont,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF2596BE),
                                  fontWeight: FontWeight.w500,
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