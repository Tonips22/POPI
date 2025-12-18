import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/app_service.dart';
import 'game_selector_screen.dart';
import 'password_screen.dart'; // Importar pantalla de contraseña
import 'home_screen.dart';
// import '../widgets/voice_text.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      // Verificar si el usuario tiene contraseña
      if (student.password != null && student.password!.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordScreen(user: student),
          ),
        );
      } else {
        // Login directo si no tiene contraseña
        _service.login(student);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChooseGameScreen(),
          ),
        );
      }
    }
  }

  Color _applyOpacity(Color color, double opacity) {
    final double clamped = opacity.clamp(0.0, 1.0);
    return color.withAlpha((255 * clamped).round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Selecciona tu perfil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;
            final double h = constraints.maxHeight;

            const double kMaxContentWidth = 1200.0;

            final double titleFont = (w * 0.08).clamp(60, 100);
            final double titleLetterSpacing = (w * 0.012).clamp(8, 20);
            final double sectionTitle = (w * 0.035).clamp(28, 40);
            final double gridSpacing = (w * 0.025).clamp(20, 32);
            final double logoSize = (w * 0.25).clamp(200, 350);

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
                                                              ? _applyOpacity(const Color(0xFF2596BE), 0.5)
                                                              : _applyOpacity(Colors.black, 0.2),
                                                          offset: const Offset(0, 4),
                                                          blurRadius: isHovered || isSelected ? 16 : 8,
                                                          spreadRadius: isHovered || isSelected ? 2 : 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/avatar${(student.avatarIndex % 12) + 0}.jpg',
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
                      
                    ],
                  ),
                ),
              ),
            );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h),
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}
