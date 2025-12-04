import 'package:flutter/material.dart';
import '../models/number_format_preferences.dart';
import '../widgets/number_format_option_card.dart';
import '../widgets/upload_option_card.dart';
import '../services/app_service.dart';

/// Pantalla de configuración de visualización de números
/// 
/// Permite al estudiante personalizar:
/// 1. Cómo se muestran los números (grafía, pictograma, audio, dibujo)
/// 2. Imágenes personalizadas para los objetos
/// 3. Audios personalizados para los números
/// 
/// Estos ajustes mejoran la accesibilidad y adaptación del juego
/// a las necesidades específicas de cada estudiante
class NumberFormatScreen extends StatefulWidget {
  const NumberFormatScreen({super.key});

  @override
  State<NumberFormatScreen> createState() => _NumberFormatScreenState();
}

class _NumberFormatScreenState extends State<NumberFormatScreen> {
  // === ESTADO DE LA PANTALLA ===
  // Estos valores deberían cargarse desde Firebase al iniciar
  // y guardarse cuando se modifiquen
  
  // Tipo de visualización seleccionado
  NumberDisplayType selectedDisplayType = NumberDisplayType.grafia;
  
  // URLs de contenido personalizado
  String? customImageUrl;
  String? customAudioUrl;

  @override
  Widget build(BuildContext context) {
    final currentUser = AppService().currentUser;
    final backgroundColor = currentUser != null
        ? Color(int.parse(currentUser.preferences.backgroundColor))
        : Colors.grey[100]!;
        
    return Scaffold(
      backgroundColor: backgroundColor,
      
      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Visualización de números',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      
      // === CONTENIDO DE LA PANTALLA ===
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === SECCIÓN 1: VISUALIZACIÓN DE NÚMEROS ===
            _buildNumberDisplaySection(),
            
            const SizedBox(height: 48),
            
            // === SECCIÓN 2: PERSONALIZACIÓN DE OBJETOS ===
            _buildCustomizationSection(),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de selección de visualización de números
  Widget _buildNumberDisplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // No necesitamos título, el título está en el AppBar
        
        // === GRID DE OPCIONES (4 botones en 2 filas) ===
        GridView.count(
          // Desactivamos el scroll del GridView porque ya está dentro de un SingleChildScrollView
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          
          // 4 columnas (una por opción, pero se adaptará en tablets pequeñas)
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          // Ajustamos la proporción para que los botones sean cuadrados
          childAspectRatio: 1.0,
          
          children: [
            // OPCIÓN 1: Grafía de números (123)
            NumberFormatOptionCard(
              icon: Icons.numbers,
              label: NumberDisplayType.grafia.displayName,
              isSelected: selectedDisplayType == NumberDisplayType.grafia,
              onTap: () {
                setState(() {
                  selectedDisplayType = NumberDisplayType.grafia;
                });
                _savePreferences();
              },
            ),
            
            // OPCIÓN 2: Pictograma
            NumberFormatOptionCard(
              icon: Icons.extension,
              label: NumberDisplayType.pictograma.displayName,
              isSelected: selectedDisplayType == NumberDisplayType.pictograma,
              onTap: () {
                setState(() {
                  selectedDisplayType = NumberDisplayType.pictograma;
                });
                _savePreferences();
              },
            ),
            
            // OPCIÓN 3: Audio
            NumberFormatOptionCard(
              icon: Icons.volume_up,
              label: NumberDisplayType.audio.displayName,
              isSelected: selectedDisplayType == NumberDisplayType.audio,
              onTap: () {
                setState(() {
                  selectedDisplayType = NumberDisplayType.audio;
                });
                _savePreferences();
              },
            ),
            
            // OPCIÓN 4: Dibujo
            NumberFormatOptionCard(
              icon: Icons.palette,
              label: NumberDisplayType.dibujo.displayName,
              isSelected: selectedDisplayType == NumberDisplayType.dibujo,
              onTap: () {
                setState(() {
                  selectedDisplayType = NumberDisplayType.dibujo;
                });
                _savePreferences();
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de personalización de objetos
  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === TÍTULO DE LA SECCIÓN ===
        const Text(
          'Personalización de objetos',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // === FILA CON 2 OPCIONES ===
        Row(
          children: [
            // OPCIÓN 1: Subir imagen propia
            Expanded(
              child: UploadOptionCard(
                icon: Icons.add_photo_alternate,
                label: 'Subir imagen propia',
                hasContent: customImageUrl != null,
                onTap: () {
                  _uploadCustomImage();
                },
              ),
            ),
            
            const SizedBox(width: 24),
            
            // OPCIÓN 2: Subir audio propio
            Expanded(
              child: UploadOptionCard(
                icon: Icons.mic,
                label: 'Subir audio propio',
                hasContent: customAudioUrl != null,
                onTap: () {
                  _uploadCustomAudio();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Guarda las preferencias en Firebase
  /// 
  /// TODO: Implementar cuando Firebase esté configurado
  void _savePreferences() {
    final preferences = NumberFormatPreferences(
      displayType: selectedDisplayType,
      customImageUrl: customImageUrl,
      customAudioUrl: customAudioUrl,
    );
    
    // TODO: Guardar en Firebase
    // await FirebaseFirestore.instance
    //   .collection('students')
    //   .doc(studentId)
    //   .update({
    //     'preferences.numberFormat': preferences.toMap(),
    //   });
    
    print('Preferencias guardadas: ${preferences.toMap()}');
  }

  /// Abre el selector de imágenes para subir una imagen personalizada
  /// 
  /// TODO: Implementar con image_picker y Firebase Storage
  Future<void> _uploadCustomImage() async {
    // TODO: Implementar selector de imágenes
    // 1. Usar el paquete image_picker para seleccionar una imagen
    // 2. Subir la imagen a Firebase Storage
    // 3. Obtener la URL de descarga
    // 4. Guardar la URL en customImageUrl
    
    print('Abrir selector de imágenes');
    
    // Ejemplo de cómo se haría (comentado para más adelante):
    /*
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Subir a Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('student_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      await storageRef.putFile(File(image.path));
      final url = await storageRef.getDownloadURL();
      
      setState(() {
        customImageUrl = url;
      });
      
      _savePreferences();
    }
    */
    
    // Por ahora, simulamos que se subió una imagen
    _showUploadDialog('Imagen', () {
      setState(() {
        customImageUrl = 'https://ejemplo.com/imagen.jpg';
      });
      _savePreferences();
    });
  }

  /// Abre el selector/grabador de audio para subir un audio personalizado
  /// 
  /// TODO: Implementar con record y Firebase Storage
  Future<void> _uploadCustomAudio() async {
    // TODO: Implementar grabador o selector de audio
    // 1. Usar el paquete record para grabar audio o file_picker para seleccionarlo
    // 2. Subir el audio a Firebase Storage
    // 3. Obtener la URL de descarga
    // 4. Guardar la URL en customAudioUrl
    
    print('Abrir grabador/selector de audio');
    
    // Por ahora, simulamos que se subió un audio
    _showUploadDialog('Audio', () {
      setState(() {
        customAudioUrl = 'https://ejemplo.com/audio.mp3';
      });
      _savePreferences();
    });
  }

  /// Muestra un diálogo de simulación de subida
  /// (Solo para testing, se eliminará cuando se implemente de verdad)
  void _showUploadDialog(String type, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subir $type'),
        content: Text(
          'Esta funcionalidad se implementará más adelante.\n\n'
          '¿Simular que se subió un $type?',
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
              
              // Mostramos un mensaje de confirmación
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