import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static const String _collectionName = 'users';

  final ScrollController _scrollController = ScrollController();

  // Tutor seleccionado (document)
  _Tutor? _selectedTutor;

  // Cache de selección local por docId -> bool (para poder marcar/desmarcar)
  final Map<String, bool> _selectedStudents = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // -----------------------------
  // Firestore streams
  // -----------------------------
  Stream<List<_Tutor>> _tutorsStream() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where('role', isEqualTo: 'tutor')
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) {
        final data = d.data();
        return _Tutor(
          docId: d.id,
          id: (data['id'] ?? d.id).toString(), // tu campo "id" (num/string)
          name: (data['name'] ?? 'Sin nombre').toString(),
        );
      }).toList();

      // Orden alfabético
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    });
  }

  Stream<List<_Student>> _studentsStream() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) {
        final data = d.data();
        return _Student(
          docId: d.id,
          id: (data['id'] ?? d.id).toString(),
          name: (data['name'] ?? 'Sin nombre').toString(),
          tutorId: (data['tutorId'] ?? '').toString(),
        );
      }).toList();

      // Orden alfabético
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    });
  }

  // -----------------------------
  // Cuando cambias de tutor:
  // - recalculamos selección en base a tutorId
  // -----------------------------
  void _syncSelectionForTutor(_Tutor tutor, List<_Student> students) {
    _selectedStudents.clear();
    for (final s in students) {
      _selectedStudents[s.docId] = (s.tutorId == tutor.id);
    }
  }

  // -----------------------------
  // Aplicar cambios: batch update
  // -----------------------------
  Future<void> _applyChanges({
    required _Tutor tutor,
    required List<_Student> students,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final usersRef = FirebaseFirestore.instance.collection(_collectionName);

    int willLink = 0;
    int willUnlink = 0;

    for (final s in students) {
      final selected = _selectedStudents[s.docId] ?? false;
      final wasLinkedToThisTutor = (s.tutorId == tutor.id);

      // Si está seleccionado -> debe quedar con tutorId = tutor.id
      if (selected) {
        if (!wasLinkedToThisTutor) willLink++;
        batch.update(usersRef.doc(s.docId), {'tutorId': tutor.id});
      } else {
        // Si NO está seleccionado pero antes estaba con este tutor -> lo desvinculamos
        if (wasLinkedToThisTutor) {
          willUnlink++;
          batch.update(usersRef.doc(s.docId), {'tutorId': null});
        }
      }
    }

    try {
      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cambios aplicados: +$willLink vinculados, -$willUnlink desvinculados.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error aplicando cambios: $e')),
      );
    }
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
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            final base = w < h ? w : h;

            double clamp(double v, double min, double max) =>
                v < min ? min : (v > max ? max : v);

            final pagePad = clamp(w * 0.08, 24, 60);

            // Píldora
            final pillPadH = clamp(w * 0.03, 14, 22);
            final pillPadV = clamp(w * 0.008, 6, 10);
            final pillRad  = clamp(w * 0.02, 10, 16);
            final pillFont = clamp(base * 0.026, 14, 20);

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

                  // ✅ CLAVE: el contenido “largo” SIEMPRE dentro de Expanded
                  Expanded(
                    child: _VinculateContent(
                      scrollController: _scrollController,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

    );
  }
}

// -----------------------------
// Models internos
// -----------------------------
class _Tutor {
  final String docId; // id del documento
  final String id;    // campo "id" que usas como número/string
  final String name;

  _Tutor({
    required this.docId,
    required this.id,
    required this.name,
  });

  @override
  String toString() => 'Tutor($id - $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _Tutor && runtimeType == other.runtimeType && docId == other.docId;

  @override
  int get hashCode => docId.hashCode;
}

class _Student {
  final String docId;
  final String id;
  final String name;
  final String tutorId; // id del tutor asignado (campo tutorId del estudiante)

  _Student({
    required this.docId,
    required this.id,
    required this.name,
    required this.tutorId,
  });
}

class _VinculateContent extends StatefulWidget {
  const _VinculateContent({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<_VinculateContent> createState() => _VinculateContentState();
}

class _VinculateContentState extends State<_VinculateContent> {
  static const _listBg     = Color(0xFFFFF5FF);
  static const _btnApply   = Color(0xFF2E7D32);
  static const _checkColor = Color(0xFF673AB7);
  static const String _collectionName = 'users';

  _Tutor? _selectedTutor;
  final Map<String, bool> _selectedStudents = {};

  Stream<List<_Tutor>> _tutorsStream() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where('role', isEqualTo: 'tutor')
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) {
        final data = d.data();
        return _Tutor(
          docId: d.id,
          id: (data['id'] ?? d.id).toString(),
          name: (data['name'] ?? 'Sin nombre').toString(),
        );
      }).toList();
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    });
  }

  Stream<List<_Student>> _studentsStream() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) {
        final data = d.data();
        return _Student(
          docId: d.id,
          id: (data['id'] ?? d.id).toString(),
          name: (data['name'] ?? 'Sin nombre').toString(),
          tutorId: (data['tutorId'] ?? '').toString(),
        );
      }).toList();
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    });
  }

  void _syncSelectionForTutor(_Tutor tutor, List<_Student> students) {
    _selectedStudents.clear();
    for (final s in students) {
      _selectedStudents[s.docId] = (s.tutorId == tutor.id);
    }
  }

  Future<void> _applyChanges({
    required _Tutor tutor,
    required List<_Student> students,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final usersRef = FirebaseFirestore.instance.collection(_collectionName);

    for (final s in students) {
      final selected = _selectedStudents[s.docId] ?? false;
      final wasLinked = (s.tutorId == tutor.id);

      if (selected) {
        batch.update(usersRef.doc(s.docId), {'tutorId': tutor.id});
      } else {
        if (wasLinked) {
          batch.update(usersRef.doc(s.docId), {'tutorId': null});
        }
      }
    }

    await batch.commit();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios aplicados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final base = w < h ? w : h;

        double clamp(double v, double min, double max) =>
            v < min ? min : (v > max ? max : v);

        final labelFont   = clamp(base * 0.028, 16, 22);
        final helperFont  = clamp(base * 0.018, 11, 14);
        final dropdownW   = clamp(w * 0.42, 240, 420);

        final listRadius  = clamp(w * 0.03, 16, 26);
        final rowHeight   = clamp(base * 0.075, 42, 58);
        final nameFont    = clamp(base * 0.026, 15, 19);

        final btnHeight   = clamp(base * 0.09, 44, 56);
        final btnFont     = clamp(base * 0.028, 15, 19);
        final btnPadH     = clamp(w * 0.05, 40, 80);

        return StreamBuilder<List<_Tutor>>(
          stream: _tutorsStream(),
          builder: (context, tutorSnap) {
            if (tutorSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (tutorSnap.hasError) {
              return Text('Error cargando tutores: ${tutorSnap.error}');
            }

            final tutors = tutorSnap.data ?? [];
            if (tutors.isEmpty) {
              return const Center(child: Text('No hay tutores en la base de datos.'));
            }

            _selectedTutor ??= tutors.first;

            return StreamBuilder<List<_Student>>(
              stream: _studentsStream(),
              builder: (context, studentSnap) {
                if (studentSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (studentSnap.hasError) {
                  return Text('Error cargando estudiantes: ${studentSnap.error}');
                }

                final students = studentSnap.data ?? [];

                // Recalcular selección si está vacía (primera vez)
                if (_selectedStudents.isEmpty && _selectedTutor != null) {
                  _syncSelectionForTutor(_selectedTutor!, students);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tutor', style: TextStyle(fontSize: labelFont, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),

                    SizedBox(
                      width: dropdownW,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 4),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.black54, width: 1.0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<_Tutor>(
                                isExpanded: true,
                                value: _selectedTutor,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: tutors.map((t) => DropdownMenuItem<_Tutor>(
                                  value: t,
                                  child: Text(t.name, style: TextStyle(fontSize: labelFont)),
                                )).toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedTutor = value;
                                    _syncSelectionForTutor(value, students);
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Seleccione los alumnos a vincular y confirme.',
                            style: TextStyle(fontSize: helperFont, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _listBg,
                          borderRadius: BorderRadius.circular(listRadius),
                        ),
                        child: students.isEmpty
                            ? const Center(child: Text('No hay estudiantes en la base de datos.'))
                            : Scrollbar(
                          thumbVisibility: true,
                          controller: widget.scrollController,
                          child: ListView.separated(
                            controller: widget.scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            itemCount: students.length,
                            itemBuilder: (context, i) {
                              final s = students[i];
                              final selected = _selectedStudents[s.docId] ?? false;

                              return SizedBox(
                                height: rowHeight,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        s.name,
                                        style: TextStyle(fontSize: nameFont, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Checkbox(
                                      value: selected,
                                      onChanged: (v) => setState(() {
                                        _selectedStudents[s.docId] = v ?? false;
                                      }),
                                      side: const BorderSide(color: _checkColor, width: 2),
                                      activeColor: _checkColor,
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

                    const SizedBox(height: 16),

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
                          onPressed: _selectedTutor == null
                              ? null
                              : () => _applyChanges(tutor: _selectedTutor!, students: students),
                          child: Text(
                            'Aplicar cambios',
                            style: TextStyle(fontSize: btnFont, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
