# EchoPod - Next-Gen AI Podcast App

EchoPod is a Flutter-based mobile application designed to redefine the podcast listening experience using Artificial Intelligence.

## 🚀 Vision
Beyond just playing audio, EchoPod understands what you hear. It provides real-time summaries, searchable transcripts, and an interactive AI assistant for every episode.

## 🛠 Features (Phase 1)
- [ ] **AI Summaries**: Get the gist of an hour-long episode in 30 seconds.
- [ ] **Interactive Chat**: Ask "What did they say about Flutter performance?" and get the exact timestamp.
- [ ] **Smart RSS Engine**: High-performance RSS parsing and subscription management.
- [ ] **Premium Audio Core**: Gapless playback, silence trimming, and voice boost.

## 🏗 Tech Stack
- **Framework**: Flutter
- **State Management**: Riverpod
- **Database**: Isar (NoSQL)
- **Audio**: just_audio + audio_service
- **AI Backend**: OpenAI (Whisper for STT, GPT-4o for summaries/chat)

## 📁 Directory Structure
```text
lib/
├── core/           # Common components, themes, errors
├── features/       # Feature-based logic & UI
│   ├── podcast/    # RSS, Discovery, Subscriptions
│   ├── player/     # Audio playback UI & logic
│   ├── ai_agent/   # AI chat & summaries
│   └── share/      # Golden sentence card generation
├── services/       # Singletons: API, DB, Audio Handler, Search
└── main.dart       # App entry point
```

## 📝 Roadmap
1. [x] Project Initialization & `pubspec.yaml`
2. [x] Core Theme & Navigation Setup
3. [x] RSS Discovery & Subscription Service
4. [x] Audio Playback Engine Integration
5. [x] AI Service Integration (Whisper/GPT)
6. [x] iOS Live Activities (Dynamic Island) Support
7. [ ] AI Golden Sentence Card Generation
8. [ ] Semantic Search (Vector Indexing)
9. [ ] Final UI Polish & Performance Tuning
