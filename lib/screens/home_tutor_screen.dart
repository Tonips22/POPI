import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'tutor_edit_profile_screen.dart';
import 'tutor_edit_game_profile_screen.dart';
import 'create_profile_screen.dart';
import 'resultados.dart';

// --- TUS IMPORTACIONES (AÑADIDAS) ---
import 'package:printing/printing.dart';
import '../services/student_report_service.dart';
import '../services/pdf_report_service.dart';
// ------------------------------------

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  final AppService _service = AppService();
  final UserService _userService = UserService();
  List<UserModel> _students = [];
  bool _isLoading = true;

  // Estado de permitir/bloquear para cada estudiante
  final Map<String, bool> _allowedMap = {};
  final Map<String, bool> _updatingMap = {};

  @override
  void initState() {
    super.initState();
    _loadAssignedStudents();
  }

  // ======================================================
  //     TUS FUNCIONES DE DESCARGA (AÑADIDAS AQUÍ)
  // ======================================================

  Future<void> _choosePeriodAndDownload(UserModel student) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Hoy'),
              onTap: () => Navigator.pop(ctx, 'today'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Últimos 7 días'),
              onTap: () => Navigator.pop(ctx, '7'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Mes en curso'),
              onTap: () => Navigator.pop(ctx, 'month'),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Personalizado…'),
              onTap: () => Navigator.pop(ctx, 'custom'),
            ),
          ],
        ),
      ),
    );

    if (choice == null) return;

    DateTime start;
    DateTime end = DateTime.now();

    if (choice == 'today') {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, now.day);
      end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    } else if (choice == '7') {
      start = end.subtract(const Duration(days: 7));
    } else if (choice == 'month') {
      start = DateTime(end.year, end.month, 1);
    } else {
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (range == null) return;
      start = range.start;
      end = range.end.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    }

    await _downloadReportForStudent(student, start: start, end: end);
  }

  Future<void> _downloadReportForStudent(
      UserModel student, {
        required DateTime start,
        required DateTime end,
      }) async {
    try {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }

      final reportData = await StudentReportService().build(
        student: student,
        start: start,
        end: end,
      );

      final bytes = await PdfReportService().buildPdf(reportData);

      if (mounted) Navigator.pop(context);

      await Printing.sharePdf(
        bytes: bytes,
        filename: 'informe_${student.name}.pdf',
      );
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar informe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ======================================================

  Future<void> _loadAssignedStudents() async {
    setState(() => _isLoading = true);

    if (_service.currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final tutorId = _service.currentUser!.id;
    final students = await _service.getStudentsByTutor(tutorId);

    if (!mounted) return;

    setState(() {
      _students = students;
      _allowedMap
        ..clear();
      for (var s in students) {
        _allowedMap[s.id] = s.preferences.canCustomize;
      }
      _isLoading = false;
    });
  }

  Future<void> _togglePersonalization(UserModel student) async {
    final currentAllowed =
        _allowedMap[student.id] ?? student.preferences.canCustomize;

    setState(() {
      _updatingMap[student.id] = true;
    });

    final success = await _service.toggleCanCustomize(
      userId: student.id,
      currentValue: currentAllowed,
    );

    if (!mounted) return;

    setState(() {
      _updatingMap.remove(student.id);
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar la personalización. Intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newValue = !currentAllowed;

    setState(() {
      _allowedMap[student.id] = newValue;
      final studentIndex =
          _students.indexWhere((element) => element.id == student.id);
      if (studentIndex != -1) {
        final oldStudent = _students[studentIndex];
        final updatedPrefs =
            oldStudent.preferences.copyWith(canCustomize: newValue);
        _students[studentIndex] =
            oldStudent.copyWith(preferences: updatedPrefs);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newValue
              ? 'Personalización permitida para ${student.name}.'
              : 'Personalización bloqueada para ${student.name}.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B1FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "TUTOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======= Píldora "Listado de estudiantes" =======
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8DBDFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Listado de estudiantes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= CABECERA DE TABLA =================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: const [
                SizedBox(width: 44),
                SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: Text(
                    "Nombre",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      "Acciones",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= LISTA DE ESTUDIANTES =================
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF71B1FF),
              ),
            )
                : _students.isEmpty
                ? const Center(
              child: Text(
                'No tienes estudiantes asignados',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                final avatarPath =
                    'assets/images/avatar${student.avatarIndex}.jpg';
                final allowed = _allowedMap[student.id] ??
                    student.preferences.canCustomize;
                final isUpdating = _updatingMap.containsKey(student.id);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage(avatarPath),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: Text(
                          student.name,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Tooltip(
                              message: 'Descargar informe',
                              child: IconButton(
                                icon: const Icon(Icons.download, color: Colors.black),
                                onPressed: () => _choosePeriodAndDownload(student),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResultadosScreen(
                                      userId: student.id,
                                      studentName: student.name,
                                    ),
                                  ),
                                );
                              },
                              child: _buildGreyButton("Ver resultados"),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final updated = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TutorEditProfileScreen(
                                      studentId: student.id,
                                    ),
                                  ),
                                );
                                if (updated == true) {
                                  await _loadAssignedStudents();
                                }
                              },
                              child: _buildGreyButton("Configurar perfil"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TutorChooseGameScreen(
                                      studentId: student.id,
                                      studentName: student.name,
                                      avatarPath: avatarPath,
                                    ),
                                  ),
                                );
                              },
                              child: _buildGreyButton(
                                  "Configurar perfil de juegos"),
                            ),
                            GestureDetector(
                              onTap: isUpdating
                                  ? null
                                  : () => _togglePersonalization(student),
                              child: Opacity(
                                opacity: isUpdating ? 0.6 : 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        allowed ? Colors.red : Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isUpdating) ...[
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        allowed
                                            ? "Bloquear personalización"
                                            : "Permitir personalización",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Desvincular alumno'),
                                    content: Text(
                                      '¿Seguro que quieres desvincular a "${student.name}"?\n'
                                          'Dejará de estar asignado a tu perfil, pero seguirá existiendo en la plataforma.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        child: const Text('Desvincular'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;

                                try {
                                  await _userService.clearTutor(student.id);

                                  // Recargar lista
                                  await _loadAssignedStudents();

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Alumno "${student.name}" desvinculado'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al desvincular alumno: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Desvincular alumno",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ================ BOTÓN CREAR NUEVO ALUMNO =================
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateProfileScreen(),
                    ),
                  );

                  if (created == true) {
                    await _loadAssignedStudents();
                  }
                },

                child: const Text(
                  "Crear nuevo alumno",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
