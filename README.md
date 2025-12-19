<div align="center">

# 🎓 POPI

### Plataforma Educativa Accesible para Matemáticas

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud-FFCA28?style=flat&logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/%20Android%20|%20Web-blue?style=flat)]()

*Una aplicación educativa diseñada para estudiantes con diversidad funcional, centrada en el aprendizaje matemático inclusivo y personalizado.*

[Características](#-características-principales) • [Arquitectura](#-arquitectura) • [Instalación](#-instalación) • [Uso](#-guía-de-uso) • [Documentación](#-documentación)

</div>

---

## 📋 Tabla de Contenidos

- [Visión General](#-visión-general)
- [Características Principales](#-características-principales)
- [Arquitectura](#-arquitectura)
- [Tecnologías](#-tecnologías)
- [Instalación](#-instalación)
- [Configuración](#-configuración)
- [Guía de Uso](#-guía-de-uso)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Juegos Educativos](#-juegos-educativos)
- [Sistema de Personalización](#-sistema-de-personalización)
- [Gestión de Usuarios](#-gestión-de-usuarios)
- [Análisis y Reportes](#-análisis-y-reportes)
- [Contribución](#-contribución)
- [Licencia](#-licencia)

---

## 🌟 Visión General

**POPI** es una aplicación educativa multiplataforma desarrollada con Flutter, diseñada específicamente para estudiantes con diversidad funcional cognitiva. La aplicación ofrece una experiencia de aprendizaje matemático personalizada, accesible y motivadora a través de minijuegos interactivos adaptables.

### Objetivos del Proyecto

- **Accesibilidad Universal**: Diseño inclusivo que se adapta a diferentes necesidades cognitivas y sensoriales
- **Personalización Total**: Cada estudiante puede tener una experiencia completamente adaptada a sus preferencias y capacidades
- **Seguimiento Pedagógico**: Herramientas avanzadas para que tutores y educadores monitoreen el progreso
- **Motivación Continua**: Sistema de refuerzos positivos personalizables para mantener el compromiso del estudiante

---

## ✨ Características Principales

### 🎮 Cuatro Juegos Matemáticos Interactivos

1. **"Toca el Número"** - Reconocimiento numérico con síntesis de voz
2. **"Ordena la Secuencia"** - Ordenación de números con drag & drop
3. **"Reparte Igual"** - Sumas y distribución equitativa
4. **"Deja Igual"** - Restas para igualar cantidades

### 🎨 Personalización Avanzada

- **Visual**: Colores, tipografías (Comic Neue, OpenDyslexic), tamaño de texto
- **Audio**: Síntesis de voz (TTS) configurable, audios personalizados
- **Formato de Números**: Grafía, pictogramas, audio, o dibujos
- **Refuerzos Positivos**: Mensajes y sonidos personalizables por estudiante

### 👥 Sistema Multi-Rol

- **Estudiantes**: Acceso simplificado con contraseñas visuales (animales/colores)
- **Tutores**: Gestión de perfiles, configuración de juegos, análisis de progreso
- **Administradores**: Control total del sistema, gestión de usuarios y vinculaciones

### 📊 Análisis y Seguimiento

- **Registro de Sesiones**: Tracking automático de todas las partidas
- **Estadísticas Detalladas**: Hits, errores, tiempo de juego, evolución diaria
- **Informes PDF**: Reportes profesionales con gráficas y recomendaciones pedagógicas
- **Visualizaciones**: Gráficos de progreso con FL Chart

### 🔒 Seguridad y Privacidad

- **Firebase Authentication**: Sistema seguro de autenticación
- **Cloud Firestore**: Base de datos en tiempo real con reglas de seguridad
- **Roles y Permisos**: Separación clara de capacidades por rol
- **Datos Encriptados**: Protección de información sensible

---

## 🏗️ Arquitectura

POPI está construido siguiendo principios de arquitectura limpia y patrones de diseño profesionales:

### Patrón de Arquitectura

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER             │
│    (Screens, Widgets, UI Components)        │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│               BUSINESS LOGIC                │
│  (Controllers, Services, State Management)  │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│                DATA LAYER                   │
│    (Models, Firebase, Local Storage)        │
└─────────────────────────────────────────────┘
```

### Componentes Clave

- **Services (Singleton)**: `AppService`, `UserService`, `GameSessionTracker`, `PdfReportService`
- **Controllers**: Lógica de juego específica para cada minijuego
- **Models**: `UserModel`, `UserPreferences`, `SesionJuego`, `StudentReport`
- **Widgets Reutilizables**: Sistema de componentes modulares y configurables

---

## 🛠️ Tecnologías

### Framework y Lenguaje

- **Flutter 3.9.2**: Framework multiplataforma de Google
- **Dart SDK ^3.9.2**: Lenguaje de programación optimizado

### Backend y Base de Datos

- **Firebase Core**: Plataforma de desarrollo de aplicaciones
- **Cloud Firestore**: Base de datos NoSQL en tiempo real
- **Firebase Storage**: Almacenamiento de archivos multimedia

### Librerías Principales

| Librería | Versión | Propósito |
|----------|---------|-----------|
| `flutter_tts` | ^4.2.3 | Síntesis de voz (Text-to-Speech) |
| `fl_chart` | ^1.1.1 | Gráficas y visualizaciones |
| `pdf` | ^3.10.7 | Generación de informes PDF |
| `printing` | ^5.11.0 | Impresión y exportación de PDFs |
| `file_picker` | ^10.3.7 | Selección de archivos del sistema |
| `audioplayers` | ^6.5.1 | Reproducción de audio personalizado |

### Fuentes Tipográficas

- **Arial**: Fuente base por defecto
- **Comic Neue**: Fuente amigable y legible
- **OpenDyslexic**: Fuente especializada para dislexia

---

## 📦 Instalación

### Prerrequisitos

- Flutter SDK 3.9.2 o superior ([Instalar Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK ^3.9.2
- Android Studio / Xcode (para desarrollo móvil)
- Cuenta de Firebase configurada

### Pasos de Instalación

1. **Clonar el repositorio**

```bash
git clone https://github.com/tu-organizacion/popi.git
cd popi
```

2. **Instalar dependencias**

```bash
flutter pub get
```

3. **Configurar Firebase**

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase para el proyecto
flutterfire configure
```

4. **Ejecutar la aplicación**

```bash
# Modo desarrollo
flutter run

# Modo release (Android)
flutter build apk --release

# Modo release (iOS)
flutter build ios --release
```

---

## ⚙️ Configuración

### Firebase

1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar **Cloud Firestore** y **Authentication**
3. Configurar reglas de seguridad de Firestore
4. Añadir los archivos de configuración:
   - Android: `google-services.json` en `android/app/`
   - iOS: `GoogleService-Info.plist` en `ios/Runner/`

### Estructura de Base de Datos

```
users/
  └─ {userId}/
      ├─ name: string
      ├─ role: "student" | "tutor" | "admin"
      ├─ avatarIndex: number
      ├─ password: string (opcional)
      ├─ tutorId: string (para estudiantes)
      ├─ isActive: boolean
      ├─ preferences: {...}
      └─ createdAt: timestamp

sesiones_juego/
  └─ {sessionId}/
      ├─ userId: string
      ├─ gameId: number
      ├─ hits: number
      ├─ fails: number
      ├─ timestamp: timestamp
      └─ duration: number
```

---

## 📖 Guía de Uso

### Para Estudiantes

1. **Inicio de Sesión**
   - Seleccionar avatar en la pantalla de estudiantes
   - Ingresar contraseña visual (secuencia de animales y colores)

2. **Selección de Juego**
   - Elegir uno de los cuatro juegos disponibles
   - Ver tutorial si es la primera vez (opcional)

3. **Jugar**
   - Seguir las instrucciones de voz
   - Completar las rondas configuradas
   - Recibir refuerzos positivos personalizados

### Para Tutores

1. **Acceso al Panel**
   - Login con usuario y contraseña de texto
   - Acceder al panel de tutor

2. **Gestión de Perfiles**
   - Crear nuevos perfiles de estudiantes
   - Editar preferencias de personalización
   - Configurar dificultad de juegos
   - Personalizar refuerzos positivos

3. **Consultar Progreso**
   - Ver estadísticas detalladas
   - Generar informes PDF
   - Analizar evolución diaria

### Para Administradores

1. **Gestión de Usuarios**
   - Crear cuentas de tutores y estudiantes
   - Activar/desactivar usuarios
   - Resetear contraseñas
   - Vincular estudiantes con tutores

2. **Configuración Global**
   - Gestionar permisos de personalización
   - Administrar recursos multimedia
   - Supervisar uso del sistema

---

## 📁 Estructura del Proyecto

```
popi/
├── lib/
│   ├── main.dart                    # Punto de entrada
│   ├── firebase_options.dart        # Configuración Firebase
│   │
│   ├── screens/                     # Pantallas de la aplicación
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── game_selector_screen.dart
│   │   ├── number_screen.dart       # Juego 1: Toca el número
│   │   ├── sort_numbers_game.dart   # Juego 2: Ordena
│   │   ├── equal_share_screen.dart  # Juego 3: Reparte
│   │   ├── equal_subtraction_screen.dart # Juego 4: Resta
│   │   ├── admin_screen.dart
│   │   ├── tutor_edit_profile_*.dart
│   │   └── ...
│   │
│   ├── models/                      # Modelos de datos
│   │   ├── user_model.dart
│   │   ├── sesion_juego.dart
│   │   ├── student_report.dart
│   │   └── number_format_preferences.dart
│   │
│   ├── services/                    # Lógica de negocio
│   │   ├── app_service.dart
│   │   ├── user_service.dart
│   │   ├── game_session_tracker.dart
│   │   ├── pdf_report_service.dart
│   │   ├── reaction_message_service.dart
│   │   └── reaction_sound_player.dart
│   │
│   ├── logic/                       # Controladores de juego
│   │   ├── game_controller.dart
│   │   ├── game_controller_ordenar.dart
│   │   └── voice_controller.dart
│   │
│   ├── widgets/                     # Componentes reutilizables
│   │   ├── number_tile.dart
│   │   ├── target_slot.dart
│   │   ├── check_icon_overlay.dart
│   │   ├── reaction_overlay.dart
│   │   └── ...
│   │
│   └── utils/                       # Utilidades
│       └── color_constants.dart
│
├── assets/                          # Recursos multimedia
│   ├── images/
│   ├── icons/
│   ├── sounds/
│   └── fonts/
│
├── android/                         # Configuración Android
├── ios/                            # Configuración iOS
├── web/                            # Configuración Web
└── test/                           # Tests unitarios
```

---

## 🎮 Juegos Educativos

### 1. Toca el Número 🔊

**Objetivo**: Reconocimiento numérico auditivo y visual

**Mecánica**:
- Se genera una cuadrícula de números aleatorios
- El sistema pronuncia un número usando TTS
- El estudiante debe tocar el número correcto
- Retroalimentación inmediata con animaciones

**Configuración**:
- Rango numérico (min-max)
- Cantidad de números en la cuadrícula
- Número de rondas por partida
- Velocidad de voz

### 2. Ordena la Secuencia 📊

**Objetivo**: Comprensión del orden numérico

**Mecánica**:
- Números desordenados en la parte superior
- Espacios objetivo en la parte inferior
- Drag & drop para ordenar de menor a mayor
- Validación al completar la secuencia

**Configuración**:
- Cantidad de números a ordenar
- Rango numérico
- Número de rondas
- Dificultad (ascendente/descendente)

### 3. Reparte Igual ➕

**Objetivo**: Sumas y distribución equitativa

**Mecánica**:
- Bolas con valores numéricos
- Recipientes con números objetivo
- Arrastrar bolas para que la suma en cada recipiente sea igual al objetivo
- Validación automática

**Configuración**:
- Cantidad de bolas
- Rango de valores
- Número de recipientes
- Complejidad de las sumas

### 4. Deja Igual ➖

**Objetivo**: Restas para igualar cantidades

**Mecánica**:
- Jarras con diferentes cantidades de bolas
- Eliminar bolas hasta igualar todas las cantidades
- Objetivo: todas las jarras con el mismo número de bolas

**Configuración**:
- Número de jarras (2-6)
- Rango de bolas iniciales
- Complejidad de las restas

---

## 🎨 Sistema de Personalización

### Personalización Visual

```dart
// Colores personalizables
- Color primario de la interfaz
- Color de fondo
- Color de texto
- Colores de refuerzos positivos

// Tipografía
- Familia: Comic Neue, OpenDyslexic, Roboto
- Tamaño: Pequeño (16px), Mediano (20px), Grande (24px)
```

### Personalización de Contenido

- **Formato de Números**: Texto, pictogramas, audio, o combinaciones
- **Avatares**: Selección de 20+ avatares diferentes
- **Mensajes de Refuerzo**: Personalizables por estudiante
- **Sonidos de Refuerzo**: Biblioteca de sonidos o uploads personalizados

### Personalización de Juegos

Cada juego puede configurarse individualmente:
- Nivel de dificultad (1-5)
- Rangos numéricos específicos
- Número de rondas por partida
- Activación de tutoriales
- Tipos de refuerzos positivos

---

## 👥 Gestión de Usuarios

### Modelo de Usuario

```dart
class UserModel {
  String id;
  String name;
  String role; // "student", "tutor", "admin"
  int avatarIndex;
  String? password;
  String? tutorId; // Vinculación tutor-estudiante
  UserPreferences preferences;
  bool isActive;
  Timestamp? createdAt;
}
```

### Flujo de Creación de Perfil (Estudiantes)

1. **Pantalla 1**: Selección de avatar
2. **Pantalla 2**: Datos personales y contraseña visual
3. **Pantalla 3**: Preferencias de visualización
4. **Pantalla 4**: Configuración de juegos y refuerzos

### Sistema de Autenticación

- **Estudiantes**: Contraseña visual (secuencia de 4 animales con colores)
- **Tutores/Admin**: Usuario y contraseña tradicional
- **Seguridad**: Contraseñas encriptadas, sesiones controladas

---

## 📊 Análisis y Reportes

### Seguimiento de Sesiones

Cada partida registra:
- Usuario y juego
- Hits y errores
- Timestamp y duración
- Configuración utilizada

### Informes PDF Profesionales

Los informes incluyen:
- **Cabecera**: Datos del estudiante y periodo
- **Resumen Ejecutivo**: Sesiones totales, días activos, tasa de éxito global
- **Evolución Diaria**: Gráfica de barras hits/errores por día
- **Detalle por Juego**: Tabla con estadísticas específicas
- **Recomendaciones Pedagógicas**: Sugerencias basadas en el rendimiento

### Servicio de Reportes

```dart
class StudentReportService {
  Future<StudentReportData> generateReport(
    String userId,
    DateTime start,
    DateTime end
  );
}
```

---

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Test con cobertura
flutter test --coverage

# Tests específicos
flutter test test/widget_test.dart
```

---

## 🚀 Despliegue

### Android

```bash
flutter build apk --release --split-per-abi
```

### Web

```bash
flutter build web --release
```

---

## 🤝 Contribución

Este es un proyecto educativo cerrado, pero abierto a sugerencias y mejoras.

### Estándares de Código

- **Linting**: Uso de `flutter_lints ^6.0.0`
- **Formato**: `dart format lib/`
- **Naming**: Convenciones de Dart estándar
- **Comentarios**: Documentación de métodos públicos

---

## 3. Funcionalidades Implementadas
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
## 👨‍💻 Autores

- Juan Ramón Gallardo Casado
- Jose Manuel Medina Horta
- Camelia Peña Alcón
- Alejandra Gómez Soriano
- Helena Ruiz Aranda
- Antonio García Torres
