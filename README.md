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

El proyecto ya contiene varias pantallas y widgets funcionales, en español, con diseño pensado para tabletas:

### Pantallas principales:
  - **CustomizationScreen**: Pantalla principal de personalización
  - **ColorSettingsScreen**: Selección de colores personalizados
  - **FontsSettingsScreen**: Configuración de tipografías y tamaño de texto
  - **NumberFormatScreen**: Preferencias de visualización de números
  - **SettingsScreen**: Configuración general del juego
  - **DifficultyScreen**: Ajuste de dificultad y rangos numéricos

### Pantallas de gestión y administración:
  - **AdminScreen**: Panel principal del administrador
  - **ManageUsersScreen**: Gestión de usuarios (crear, desactivar, eliminar)
  - **CreateUsersScreen**: Creación de nuevas cuentas
  - **DesactivateUsersScreen**: Desactivación de usuarios
  - **DeleteUsersScreen**: Eliminación de usuarios del sistema
  - **ResetPasswordsScreen**: Restablecimiento de contraseñas
  - **ChangePasswordsScreen**: Cambio de contraseñas

### Pantallas de creación de perfiles:
  - **CreateProfileScreen** (1-4): Flujo completo de creación de perfil de estudiante con selección de avatar, datos personales y configuración

### Pantallas de juegos:
  - **GameSelectorScreen**: Selector de minijuegos disponibles
  - **NumberScreen**: Minijuego "Toca el número que suena" (implementado con TTS)
  - **SortNumbersGame**: Minijuego "Ordena la secuencia" con drag & drop

### Pantallas de autenticación:
  - **LoginScreen**: Pantalla de inicio de sesión con selección de usuario
  - **PasswordScreen**: Pantalla de contraseña con sistema de animales y colores

### Widgets reutilizables:
  - **CustomizationOptionCard**, **ColorSettingCard**, **ColorPickerDialog**: Personalización visual
  - **NumberFormatOptionCard**, **UploadOptionCard**: Preferencias de formato
  - **NumberGrid**, **NumberCircle**: Componentes del juego de números
  - **NumberTile**, **TargetSlot**: Componentes para el juego de ordenar números con drag & drop

### Lógica de juego:
  - **GameController**: Controlador singleton para gestión de dificultad, rangos numéricos y generación de números aleatorios

### Modelos:
  - **number_format_preferences.dart**: Modelo para preferencias de visualización de números

### Utilidades:
  - **color_constants.dart**: Constantes de colores de la aplicación

### Archivo principal:
  - **main.dart**: Punto de entrada de la aplicación

Es una base funcional con múltiples características ya implementadas, pensada para un equipo de principiantes.

---

## 3. Funcionalidades actuales y planificadas

### Funcionalidades ya implementadas:

#### Interfaz y personalización:
- Navegación completa entre pantallas de personalización
- Selección visual de colores y tipografías (UI y diálogos funcionales)
- Interfaz para escoger cómo mostrar números (grafía, pictograma, audio, dibujo)
- Tarjetas para subir imagen/audio (UI preparada)
- Modelos para serializar preferencias (toMap / fromMap)
- Ajuste de dificultad con slider y selección de rangos numéricos

#### Gestión de usuarios:
- Panel de administrador completo
- Flujo de creación de perfiles de estudiantes (4 pantallas)
- Selección de avatares personalizados (16 opciones)
- Gestión de usuarios: crear, desactivar, eliminar
- Sistema de restablecimiento y cambio de contraseñas

#### Minijuegos funcionales:
- **"Toca el número que suena"**: Implementado con Text-to-Speech (flutter_tts)
  - Generación aleatoria de números según dificultad
  - Grid adaptativo según cantidad de números
  - Retroalimentación visual (✅/❌)
  - Control de dificultad (3-12 números)
  - Rangos configurables (0-10, 0-20, 0-100, 0-1000)

- **"Ordena la secuencia"**: Implementado con sistema drag & drop
  - Arrastrar y soltar números en casillas
  - Intercambio de fichas entre casillas
  - Retroalimentación visual con "pill" cuando se coloca correctamente
  - Validación automática al completar la secuencia
  - 10 números (0-9) para ordenar

#### Sistema de autenticación:
- Pantalla de login con selección visual de usuario
- Sistema de contraseña con animales y colores (accesible)
- Navegación según rol (administrador/tutor/estudiante)

#### Lógica de juego:
- GameController singleton para gestión centralizada
- Sistema de generación de números únicos aleatorios
- Validación de respuestas correctas/incorrectas

### Funcionalidades planeadas (priorizadas):

1. **Integración con Firebase**:
   - Autenticación (admin / tutor / estudiante)
   - Firestore para datos de perfiles, preferencias y progreso
   - Firebase Storage para imágenes y audios personalizados

2. **Implementación completa de subida y reproducción**:
   - image_picker + firebase_storage para imágenes
   - record (o flutter_sound) + firebase_storage para audios
   - Reproducción de audio (a partir de URL) y control básico

3. **Minijuegos adicionales**:
   - "Reparte/Deja el mismo número en cada recipiente"
   - Sistema de niveles progresivos
   - Aleatorización (5 repeticiones por juego)
   - Mejoras en retroalimentación y animaciones

4. **Ayuda multimedia por juego**:
   - Vídeos tutoriales con subtítulos
   - Mensajes de refuerzo personalizados

5. **Panel de tutor ampliado**:
   - Visualización de progreso con gráficas
   - Sistema de vinculación de cuentas tutor-estudiante
   - Chat accesible tutor-estudiante

6. **Accesibilidad mejorada**:
   - Aplicación completa de contrastes configurables
   - Optimización de áreas táctiles
   - Soporte para asistencia por hardware

---

## 4. Estructura de carpetas recomendada (sencilla y clara)

Sencilla y pensada para un equipo de seis principiantes:

- lib/
  - main.dart
  - screens/           # Pantallas (cada pantalla en su archivo)
  - widgets/           # Widgets reutilizables (carpeta widgets/)
  - widget/            # Widgets específicos de juegos (carpeta widget/)
  - logic/             # Lógica de juego (GameController, etc.)
  - models/            # Modelos de datos (ej: NumberFormatPreferences)
  - services/          # Lógica de servicios (Firebase, storage, audio)
  - utils/             # Constantes y utilidades (colores, helpers)
  - l10n/              # Localización si se añade
- assets/
  - images/
  - audio/
  - fonts/
- test/                 # Test básicos (unit y widget tests)

Mantén la lógica separada de la UI: los servicios (subidas, autenticación, consulta a Firestore) van en /services, y la lógica de juego en /logic.

---

## 5. Dependencias principales

El proyecto utiliza las siguientes dependencias clave:

- **flutter_tts** (^3.6.0): Text-to-Speech para el minijuego "Toca el número que suena"
- **cupertino_icons** (^1.0.8): Iconos del sistema iOS/Material

### Dependencias planeadas:
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- image_picker
- flutter_sound o record

---
## 6. Autores

- Juan Ramón Gallardo Casado
- Jose Manuel Medina Horta
- Camelia Peña Alcón
- Alejandra Gómez Soriano
- Helena Ruiz Aranda
- Antonio García Torres
