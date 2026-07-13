# SpeakNow English Academy 🐼

SpeakNow es una aplicación de aprendizaje de inglés para hispanohablantes, inspirada en Duolingo, con lecciones estructuradas, ejercicios interactivos tipo cartas, reconocimiento de voz, corrección de escritura y comprensión auditiva.

## ✨ Funcionalidades del MVP

### Tipos de ejercicio (sistema de cartas)
| Tipo | Descripción |
|------|-------------|
| 🃏 **Seleccionar carta** | Pregunta con 4 cartas (emoji + texto); el usuario elige la correcta |
| 🔊 **Escuchar** | El TTS pronuncia la frase en inglés (velocidad normal o lenta 🐢) y el usuario selecciona lo que oyó |
| 🎙️ **Hablar** | El usuario pronuncia la frase y se evalúa con reconocimiento de voz (tolerante a imprecisiones) |
| ✍️ **Escribir** | Traducción escrita con corrección: ignora mayúsculas/acentos/puntuación, expande contracciones (`I'm` = `I am`), tolera errores tipográficos leves ("¡Casi perfecto!") y acepta respuestas alternativas |

### Gamificación
- ⭐ **XP**: 20 por lección nueva, +5 por lección perfecta, 10 por repaso/práctica
- 🔥 **Racha diaria**: se extiende al practicar cada día y se rompe si faltas más de un día
- 💜 **Corazones (vidas)**: 5 máximo; pierdes 1 por error, se recargan con el tiempo (1 cada 30 min) o completando una práctica
- 🔓 **Progresión**: las lecciones se desbloquean en orden; los ejercicios fallados se vuelven a preguntar al final (como Duolingo)

### Pantallas
- **Splash** animado con la mascota y gradiente de marca
- **Onboarding** (4 páginas) con captura de nombre
- **Ruta de aprendizaje**: camino serpenteante de lecciones agrupadas en 4 unidades
- **Lección**: barra de progreso animada, corazones, feedback verde/rojo estilo Duolingo
- **Lección completada**: celebración con XP ganado y precisión
- **Práctica**: repaso aleatorio de lecciones completadas (recupera 1 corazón)
- **Perfil**: estadísticas, progreso del curso, modo oscuro y reinicio de progreso

### Contenido del curso
4 unidades × 3 lecciones (~90 ejercicios): Saludos y presentaciones, Comida y bebidas, Viajes y direcciones, Familia y vida diaria.

## 🎨 Paleta de colores

| Uso | Color |
|-----|-------|
| Morado profundo (primario) | `#4C2882` |
| Lavanda (secundario) | `#B18BD6` |
| Púrpura (acento) | `#800080` |
| Fondo modo oscuro | `#1A1033` |

Soporta **modo claro y oscuro** (conmutables desde Perfil).

## 🖼️ Logo

Coloca el logo del panda en `assets/images/logo.png` (PNG cuadrado, mínimo 512×512). Mientras no exista, la app muestra una mascota de respaldo con los colores de la marca.

## 🚀 Cómo ejecutar

Requisitos: [Flutter](https://docs.flutter.dev/get-started/install) 3.44+ (instalado en `C:\Users\Usuario\flutter`).

```powershell
# Dependencias
flutter pub get

# Web (Chrome)
flutter run -d chrome

# Android (emulador o dispositivo conectado)
flutter run -d android

# Tests y análisis
flutter test
flutter analyze
```

> **Nota (Windows):** para compilar con plugins es necesario activar el **Modo de desarrollador** (`start ms-settings:developers`) por el soporte de symlinks.

> **Reconocimiento de voz:** funciona en Android, iOS y web (Chrome). El ejercicio de habla ofrece "Omitir" si el micrófono no está disponible.

## 🏗️ Arquitectura

```
lib/
├── main.dart                  # Punto de entrada + providers globales
├── core/                      # Tema, colores y utilidades de corrección de texto
├── models/                    # Unit, Lesson, Exercise, CardOption
├── data/course_data.dart      # Contenido del curso (estático en el MVP)
├── services/                  # TTS (flutter_tts) y voz (speech_to_text)
├── providers/                 # ProgressProvider (XP/racha/corazones, persistido),
│                              # LessonController (cola de ejercicios), ThemeProvider
├── screens/                   # splash, onboarding, ruta, lección, práctica, perfil
└── widgets/                   # DuoButton 3D, mascota, cartas y widgets de ejercicio
```

**Dependencias:** `provider`, `shared_preferences`, `flutter_tts`, `speech_to_text`, `google_fonts` (Nunito).
