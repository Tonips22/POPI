import 'package:flutter/material.dart';
import '../models/number_format_preferences.dart';
import '../widgets/number_format_option_card.dart';
import '../widgets/upload_option_card.dart';

class CreateProfileScreen4 extends StatefulWidget {
  const CreateProfileScreen4({super.key});

  @override
  State<CreateProfileScreen4> createState() => _CreateProfileScreen4State();
}

class _CreateProfileScreen4State extends State<CreateProfileScreen4> {
  NumberDisplayType selectedDisplayType = NumberDisplayType.grafia;

  // 🔹 Variables separadas para objetos y contenedores
  String? objectImageUrl;
  String? objectAudioUrl;
  String? containerImageUrl;
  String? containerAudioUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // === APPBAR SUPERIOR ===
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear perfil de alumno',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),

      // === CONTENIDO DE LA PANTALLA ===
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5CA7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferencias de visualización',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Visualización de números',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.7,
                        children: [
                          NumberFormatOptionCard(
                            icon: Icons.numbers,
                            label: NumberDisplayType.grafia.displayName,
                            isSelected:
                            selectedDisplayType == NumberDisplayType.grafia,
                            onTap: () {
                              setState(() =>
                              selectedDisplayType = NumberDisplayType.grafia);
                              _savePreferences();
                            },
                          ),
                          NumberFormatOptionCard(
                            icon: Icons.extension,
                            label: NumberDisplayType.pictograma.displayName,
                            isSelected: selectedDisplayType ==
                                NumberDisplayType.pictograma,
                            onTap: () {
                              setState(() => selectedDisplayType =
                                  NumberDisplayType.pictograma);
                              _savePreferences();
                            },
                          ),
                          NumberFormatOptionCard(
                            icon: Icons.volume_up,
                            label: NumberDisplayType.audio.displayName,
                            isSelected:
                            selectedDisplayType == NumberDisplayType.audio,
                            onTap: () {
                              setState(() =>
                              selectedDisplayType = NumberDisplayType.audio);
                              _savePreferences();
                            },
                          ),
                          NumberFormatOptionCard(
                            icon: Icons.palette,
                            label: NumberDisplayType.dibujo.displayName,
                            isSelected:
                            selectedDisplayType == NumberDisplayType.dibujo,
                            onTap: () {
                              setState(() =>
                              selectedDisplayType = NumberDisplayType.dibujo);
                              _savePreferences();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Colors.black),

                      const Text(
                        'Personalización de objetos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          // === BLOQUE 1: OBJETOS ===
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Objetos de juego',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: UploadOptionCard(
                                          icon: Icons.add_photo_alternate,
                                          label: 'Imagen',
                                          hasContent: objectImageUrl != null,
                                          onTap: () => _uploadCustomImage(true),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: UploadOptionCard(
                                          icon: Icons.mic,
                                          label: 'Audio',
                                          hasContent: objectAudioUrl != null,
                                          onTap: () => _uploadCustomAudio(true),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // === BLOQUE 2: CONTENEDORES ===
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Contenedores de juego',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: UploadOptionCard(
                                          icon: Icons.add_photo_alternate,
                                          label: 'Imagen',
                                          hasContent: containerImageUrl != null,
                                          onTap: () => _uploadCustomImage(false),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: UploadOptionCard(
                                          icon: Icons.mic,
                                          label: 'Audio',
                                          hasContent: containerAudioUrl != null,
                                          onTap: () => _uploadCustomAudio(false),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === BOTONES INFERIORES ===
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5CA7FF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Acción al continuar
                  },
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // === FUNCIONES AUXILIARES ===

  void _savePreferences() {
    final preferences = NumberFormatPreferences(
      displayType: selectedDisplayType,
      customImageUrl: objectImageUrl,
      customAudioUrl: objectAudioUrl,
    );
    print('Preferencias guardadas: ${preferences.toMap()}');
  }

  Future<void> _uploadCustomImage(bool isObject) async {
    _showUploadDialog('Imagen', () {
      setState(() {
        if (isObject) {
          objectImageUrl = 'https://ejemplo.com/imagen_objeto.jpg';
        } else {
          containerImageUrl = 'https://ejemplo.com/imagen_contenedor.jpg';
        }
      });
      _savePreferences();
    });
  }

  Future<void> _uploadCustomAudio(bool isObject) async {
    _showUploadDialog('Audio', () {
      setState(() {
        if (isObject) {
          objectAudioUrl = 'https://ejemplo.com/audio_objeto.mp3';
        } else {
          containerAudioUrl = 'https://ejemplo.com/audio_contenedor.mp3';
        }
      });
      _savePreferences();
    });
  }

  void _showUploadDialog(String type, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subir $type'),
        content: Text(
          'Esta funcionalidad se implementará más adelante.\n\n¿Simular que se subió un $type?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$type subido correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simular subida'),
          ),
        ],
      ),
    );
  }
}
