# Fralign v2.0 — Modernized UI/UX Concept & Technical Specification

## 1. Executive Summary & Design Vision

**Fralign** is a minimal, distraction-free pronunciation, speech-to-text spelling assistant, and contextual dictionary app. The redesign modernizes the classic 2020 theme with a fresh, contemporary aesthetic, high-contrast accessible typography, micro-interactions, and multi-language capabilities.

---

## 2. Design System Tokens

Located in [`lib/core/theme/design_tokens.dart`](file:///d:/fralign/lib/core/theme/design_tokens.dart):

```dart
// Primary Accent (Red) — Action trigger, listen button, voice wave
static const Color coralRed = Color(0xFFFF3B30);
static const Color coralRedDark = Color(0xFFE53935);
static const Color coralRedLight = Color(0xFFFF6B6B);

// Secondary Accent (Green) — Phonetics, active status, success highlights
static const Color emeraldGreen = Color(0xFF10B981);
static const Color emeraldGreenDark = Color(0xFF059669);

// Accent Focus / Border (Amber/Orange) — Input focus outline, parts of speech
static const Color vibrantAmber = Color(0xFFF59E0B);
static const Color amberLight = Color(0xFFFBBF24);

// Neutrals
static const Color backgroundLight = Color(0xFFF8FAFC);
static const Color surfaceLight    = Color(0xFFFFFFFF);
static const Color backgroundDark  = Color(0xFF0F172A);
static const Color surfaceDark     = Color(0xFF1E293B);
```

---

## 3. Component Hierarchy & Architecture

```
FralignApp (MaterialApp + Multi-theme support)
└── HomeScreen (SafeArea + SingleChildScrollView)
    ├── FralignHeader
    │   ├── BrandLogo ('Fralign' + dynamic audio wave icon)
    │   ├── LanguagePill (Current flag + label -> ModalBottomSheet)
    │   └── SettingsButton (ModalBottomSheet for Dark Mode & Speed Slider)
    │
    ├── InputCard
    │   ├── TextField (Amber focus border, clear button, favorite toggle)
    │   └── ListenButton (Full-width Coral Red elevated CTA)
    │
    ├── MicrophoneSection
    │   ├── Triple Animated Ripple Rings (Expanding scale + opacity drop)
    │   ├── Floating Microphone Button (Elastic pulse animation)
    │   ├── Live Transcription / Status Hint
    │   └── Letter-by-Letter Spelling Card (JetBrains Mono monospace display)
    │
    ├── DictionaryCard
    │   ├── Drag handle
    │   ├── Tab Bar (📖 Definition & Examples | 🗣️ Phonetic Breakdown | 💡 Synonyms)
    │   └── Tab View Content (IPA notation, part-of-speech badge, inline audio trigger)
    │
    └── Footer ('Fralign by Frank • v2.0')
```

---

## 4. Production Code Structure

The implementation is verified and compiles without warnings:

- [`lib/main.dart`](file:///d:/fralign/lib/main.dart): Application initialization, orientation lock, and dynamic `SystemChrome` styling.
- [`lib/core/theme/design_tokens.dart`](file:///d:/fralign/lib/core/theme/design_tokens.dart): Exact spacing, elevation, border radiuses, and color palettes.
- [`lib/core/theme/app_theme.dart`](file:///d:/fralign/lib/core/theme/app_theme.dart): Material 3 ThemeData with Google Fonts Inter typography.
- [`lib/models/language_model.dart`](file:///d:/fralign/lib/models/language_model.dart): 14 global locales with country flags, native scripts, and TTS mapping.
- [`lib/models/dictionary_model.dart`](file:///d:/fralign/lib/models/dictionary_model.dart): Full Free Dictionary API schema parser.
- [`lib/services/tts_service.dart`](file:///d:/fralign/lib/services/tts_service.dart): `flutter_tts` integration with speech rate and pitch control.
- [`lib/services/stt_service.dart`](file:///d:/fralign/lib/services/stt_service.dart): `speech_to_text` integration with modern `SpeechListenOptions`.
- [`lib/services/dictionary_service.dart`](file:///d:/fralign/lib/services/dictionary_service.dart): Async HTTP client for definition lookups.
- [`lib/providers/fralign_provider.dart`](file:///d:/fralign/lib/providers/fralign_provider.dart): Central Provider managing state, persistence with `shared_preferences`, and event dispatching.
- [`lib/screens/home_screen.dart`](file:///d:/fralign/lib/screens/home_screen.dart): Fluid entrance animations via `flutter_animate`.
