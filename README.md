# POPI — Juego educativo de Matemáticas accesible para tabletas

POPI es una aplicación educativa para tabletas pensada para alumnado con discapacidad cognitiva. Está diseñada para ser accesible, altamente personalizable y fácil de usar por tutores y estudiantes. El objetivo es ofrecer minijuegos compactos que trabajen reconocimiento de números, orden, clasificación y operaciones básicas con ayuda audiovisual y adaptaciones según las necesidades de cada estudiante.

Este repositorio contiene el prototipo inicial y la estructura sobre la que se desarrollará la app.

---

## Contenido de este documento

1. Visión general
2. Estado actual del proyecto
3. Funcionalidades (actuales y planificadas)
4. Estructura de carpetas recomendada
5. Autores

---

## 1. Visión general

POPI propone una serie de minijuegos pensados para tabletas, con enfoque en accesibilidad y personalización de la experiencia:

- Perfiles de estudiantes (datos, preferencias visuales y de audio).
- Personalización: colores, tipografías, tamaño de letra, formas de mostrar números (grafía, pictograma, audio, dibujo), imágenes y audios personalizados.
- Cuatro minijuegos esenciales que se adaptan a distintos rangos numéricos y niveles de dificultad.
- Registro de progreso (gráficas de aciertos/errores) y roles: administrador, tutor y estudiante.
- Ayuda multimedia (vídeos subtitulados por juego) y reforzadores positivos personalizados al finalizar cada partida.

---

## 2. Estado actual (qué hay en el repositorio)

El proyecto ya contiene varias pantallas y widgets base, en español, con diseño pensado para tabletas:

- Pantallas:
  - CustomizationScreen (pantalla principal de personalización)
  - ColorSettingsScreen (selección de color)
  - FontSettingsScreen (tipografías y tamaño)
  - NumberFormatScreen (preferencias de visualización de números)

- Widgets reutilizables:
  - CustomizationOptionCard, ColorSettingCard, ColorPickerDialog
  - NumberFormatOptionCard, UploadOptionCard

- Modelos:
  - number_format_preferences.dart (modelo para preferencias de visualización)

- Utilidades:
  - color_constants.dart

- Archivo principal:
  - main.dart (app shell / ejemplo)

Es una base limpia y comentada, pensada para un equipo de principiantes.

---

## 3. Funcionalidades actuales y planificadas

Funcionalidades ya implementadas (prototipo / UI):

- Navegación básica entre pantallas de personalización.
- Selección visual de colores y tipografías (UI y diálogos).
- Interfaz para escoger cómo mostrar números (grafía, pictograma, audio, dibujo).
- Tarjetas para subir imagen/audio (funcionalidad simulada, no subida real aún).
- Modelos para serializar preferencias (toMap / fromMap).

Funcionalidades planeadas (priorizadas):

1. Integración con Firebase:
   - Autenticación (admin / tutor / estudiante).
   - Firestore para datos de perfiles, preferencias y progreso.
   - Firebase Storage para imágenes y audios personalizados.

2. Implementación completa de subida y reproducción:
   - image_picker + firebase_storage para imágenes.
   - record (o flutter_sound) + firebase_storage para audios.
   - Reproducción de audio (a partir de URL) y control básico.

3. Minijuegos:
   - “Toca el número que suena”
   - “Ordena la secuencia”
   - “Reparte/Deja el mismo número en cada recipiente”
   - Lógica por niveles y aleatorización (5 repeticiones por juego)

4. Ayuda multimedia por juego (vídeo + subtítulos) y mensajes de refuerzo.

5. Panel de tutor y administrador:
   - Crear y vincular cuentas
   - Visualización de progreso (gráficas simples)
   - Chat accesible tutor-estudiante (mensajes simples)

6. Accesibilidad:
   - Contraste configurables, tamaños de toque y áreas táctiles grandes.
   - Navegación simplificada y soporte para asistencia por hardware si se requiere.

---

## 4. Estructura de carpetas recomendada (sencilla y clara)

Sencilla y pensada para un equipo de seis principiantes:

- lib/
  - main.dart
  - screens/           # Pantallas (cada pantalla en su archivo)
  - widgets/           # Widgets reutilizables
  - models/            # Modelos de datos (ej: NumberFormatPreferences)
  - services/          # Lógica de servicios (Firebase, storage, audio)
  - utils/             # Constantes y utilidades (colores, helpers)
  - l10n/              # Localización si se añade
- assets/
  - images/
  - audio/
  - fonts/
- test/                 # Test básicos (unit y widget tests)

Mantén la lógica separada de la UI: los servicios (subidas, autenticación, consulta a Firestore) van en /services.

---
## 5. Autores

- Juan Ramón Gallardo Casado
- Jose Manuel Medina Horta
- Camelia Peña Alcón
- Alejandra Gómez Soriano
- Helena Ruiz Aranda
- Antonio García Torres
