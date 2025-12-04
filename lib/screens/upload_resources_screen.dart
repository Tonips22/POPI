import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum ResourceType { image, audio }

class UploadResourcesScreen extends StatefulWidget {
  const UploadResourcesScreen({super.key});

  @override
  State<UploadResourcesScreen> createState() => _UploadResourcesScreenState();
}

class _UploadResourcesScreenState extends State<UploadResourcesScreen> {
  static const _blueAppBar = Color(0xFF77A9F4);
  static const _bluePill = Color(0xFF77A9F4);
  static const _greenButton = Color(0xFF2E7D32);

  String? _fileName;
  ResourceType? _resourceType;

  // Rutas a tus iconos
  static const _imageAssetPath = 'assets/icons/upload_image.png';
  static const _audioAssetPath = 'assets/icons/upload_audio.png';

  bool get _hasFileLoaded => _fileName != null;

  Future<void> _pickImage() async {
    if (_hasFileLoaded) {
      _showSnack('Ya hay un archivo cargado. Elimina el actual para subir otro.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.first.name;
        _resourceType = ResourceType.image;
      });
      _showSnack('Imagen seleccionada: $_fileName');
    }
  }

  Future<void> _pickAudio() async {
    if (_hasFileLoaded) {
      _showSnack('Ya hay un archivo cargado. Elimina el actual para subir otro.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );

    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.first.name;
        _resourceType = ResourceType.audio;
      });
      _showSnack('Audio seleccionado: $_fileName');
    }
  }

  void _clearFile() {
    setState(() {
      _fileName = null;
      _resourceType = null;
    });
  }

  void _uploadResource() {
    if (!_hasFileLoaded) {
      _showSnack('Selecciona primero una imagen o un audio.');
      return;
    }

    _showSnack('Recurso "${_fileName!}" subido correctamente (simulación).');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
          'TUTOR',
          style: TextStyle(
            color: Colors.black,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final base = w < h ? w : h;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          final pagePad = clamp(w * 0.08, 24, 60);
          final pillPadH = clamp(w * 0.03, 14, 22);
          final pillPadV = clamp(w * 0.008, 6, 10);
          final pillRad = clamp(w * 0.02, 10, 16);
          final pillFont = clamp(base * 0.026, 14, 20);

          // ICONOS MÁS GRANDES
          final iconSize = clamp(base * 0.34, 150, 260.0);
          // SEPARACIÓN MAYOR ENTRE ICONOS
          final iconsSpacing = clamp(w * 0.20, 70, 140);

          final btnHeight = clamp(base * 0.09, 44, 56);
          final btnFont = clamp(base * 0.028, 15, 19);
          final btnWidth = clamp(w * 0.35, 160, 220);
          final infoFont = clamp(base * 0.022, 12, 16);

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pagePad,
              vertical: pagePad * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Píldora "Subir recursos"
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
                    'Subir recursos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: pillFont,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: pagePad * 1.2),

                // Dos iconos grandes centrados
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _UploadIcon(
                          assetPath: _imageAssetPath,
                          size: iconSize,
                          onTap: _pickImage,
                          disabled: _hasFileLoaded &&
                              _resourceType != ResourceType.image,
                        ),
                        SizedBox(width: iconsSpacing),
                        _UploadIcon(
                          assetPath: _audioAssetPath,
                          size: iconSize,
                          onTap: _pickAudio,
                          disabled: _hasFileLoaded &&
                              _resourceType != ResourceType.audio,
                        ),
                      ],
                    ),
                  ),
                ),

                // Mensaje de archivo cargado
                if (_hasFileLoaded) ...[
                  SizedBox(height: pagePad * 0.6),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file_outlined, size: 18),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: w * 0.55),
                            child: Text(
                              'Archivo cargado: $_fileName',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: infoFont,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            // AQUÍ CAMBIO LA FLECHA POR UNA X
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                            ),
                            tooltip: 'Eliminar archivo',
                            onPressed: _clearFile,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else
                  SizedBox(height: pagePad * 0.6),

                SizedBox(height: pagePad * 0.6),

                // Botón inferior "Subir recurso"
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: btnWidth,
                    height: btnHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _greenButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnHeight * 0.4),
                        ),
                      ),
                      onPressed: _uploadResource,
                      child: Text(
                        'Subir recurso',
                        style: TextStyle(
                          fontSize: btnFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

/// Icono grande usando las imágenes que has pasado
class _UploadIcon extends StatefulWidget {
  const _UploadIcon({
    required this.assetPath,
    required this.size,
    required this.onTap,
    this.disabled = false,
  });

  final String assetPath;
  final double size;
  final VoidCallback onTap;
  final bool disabled;

  @override
  State<_UploadIcon> createState() => _UploadIconState();
}

class _UploadIconState extends State<_UploadIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.disabled) {
          setState(() => _hovering = true);
        }
      },
      onExit: (_) {
        if (!widget.disabled) {
          setState(() => _hovering = false);
        }
      },
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onTap,
        child: AnimatedScale(
          scale: _hovering && !widget.disabled ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            // Sin fondo, sin borde, solo tu PNG con su forma
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                widget.assetPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

