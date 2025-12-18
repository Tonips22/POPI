import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ChangeTextPasswordsScreen extends StatefulWidget {
  const ChangeTextPasswordsScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.avatarPath,
    required this.roleLabel,
  });

  final String userId;
  final String userName;
  final String avatarPath;
  final String roleLabel;

  @override
  State<ChangeTextPasswordsScreen> createState() => _ChangeTextPasswordsScreenState();
}

class _ChangeTextPasswordsScreenState extends State<ChangeTextPasswordsScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill   = Color(0xFF77A9F4);

  final _pass1 = TextEditingController();
  final _pass2 = TextEditingController();
  bool _show1 = false;
  bool _show2 = false;
  bool _saving = false;

  @override
  void dispose() {
    _pass1.dispose();
    _pass2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final p1 = _pass1.text.trim();
    final p2 = _pass2.text.trim();

    if (p1.isEmpty || p2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rellena los dos campos.')),
      );
      return;
    }
    if (p1 != p2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }
    if (p1.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mínimo 4 caracteres.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await UserService().updatePassword(widget.userId, p1);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada.'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad   = clamp(w * 0.08, 24, 60);
          final pillPadH  = clamp(w * 0.03, 14, 22);
          final pillPadV  = clamp(w * 0.008, 6, 10);
          final pillRadius= clamp(w * 0.02, 10, 16);
          final pillFont  = clamp(base * 0.026, 14, 20);

          final cardPad   = clamp(base * 0.03, 14, 22);
          final titleFont = clamp(base * 0.030, 16, 22);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: pagePad * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: pillPadH, vertical: pillPadV),
                  decoration: BoxDecoration(
                    color: _bluePill,
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                  child: Text(
                    'Restablecer contraseñas',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: pillFont),
                  ),
                ),
                const SizedBox(height: 18),

                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: clamp(base * 0.10, 44, 70),
                        backgroundImage: AssetImage(widget.avatarPath),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.userName} (${widget.roleLabel})',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: titleFont),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: EdgeInsets.all(cardPad),
                  decoration: BoxDecoration(
                    color: const Color(0xFF77A9F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nueva contraseña', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pass1,
                        obscureText: !_show1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_show1 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _show1 = !_show1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text('Repetir contraseña', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pass2,
                        obscureText: !_show2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_show2 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _show2 = !_show2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              : const Text('GUARDAR CONTRASEÑA', style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
