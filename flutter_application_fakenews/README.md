# 📰 Fake News Scanner

An AI-powered Flutter mobile app that scans news articles and screenshots to detect misinformation using OCR extraction and credibility analysis.

---

## Features

- **Camera & Gallery Scanning** — Capture news articles in real-time or upload screenshots from your gallery
- **OCR Text Extraction** — Extracts readable text from images automatically
- **AI Credibility Analysis** — Evaluates claims and returns a verdict: Verified, Doubtful, or Fake
- **Credibility Score** — A 0–100% confidence score with a visual gradient scale
- **Claim Detection** — Highlights individual claims found within the article
- **Source Verification** — Cross-references results against known credible sources (WHO, Reuters, Bloomberg, etc.)
- **Bilingual Support** — Full English and Urdu (اردو) language toggle
- **Scan History** — Tracks and displays recent scan results
- **Animated UI** — Splash screen, scan line animation, processing steps, and result transitions

---

## Screenshots

| Idle / Home | Processing | Result |
|-------------|------------|--------|
| Camera viewfinder with scan line | Step-by-step AI analysis | Verdict card with score & sources |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| UI | Material 3, Custom Painters |
| State | `setState` (local state) |
| Animations | `AnimationController`, `TweenAnimationBuilder` |
| OCR (planned) | Google ML Kit / Tesseract |
| AI Backend (planned) | REST API / Claude / OpenAI |
| Languages | English, Urdu (RTL support) |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android SDK or Xcode (for iOS)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/fake-news-scanner.git
cd fake-news-scanner

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart               # Entry point, theme constants, all screens
│
├── models/
│   ├── scan_result.dart    # ScanResult, VerifiedSource models
│   └── enums.dart          # CredibilityLevel, AppLanguage, ScanState
│
├── screens/
│   ├── splash_screen.dart  # Animated splash with progress bar
│   └── home_screen.dart    # Main scanner UI and result display
│
└── widgets/
    ├── verdict_card.dart   # Credibility verdict display
    ├── score_bar.dart      # Animated credibility scale
    └── source_tile.dart    # Individual source verification item
```

> **Note:** The current codebase is in a single `main.dart` file. The structure above reflects the recommended refactored layout.

---

## Credibility Levels

| Level | Color | Description |
|-------|-------|-------------|
| ✅ Verified | Green `#00E87A` | Claim is supported by credible sources |
| ⚠️ Doubtful | Amber `#FFB020` | Partially supported or unconfirmed |
| ❌ Fake | Red `#FF3B5C` | Contradicted by credible sources |

---

## Roadmap

- [ ] Integrate real OCR (Google ML Kit)
- [ ] Connect to a live fact-checking API
- [ ] Persistent scan history with local database (Hive / SQLite)
- [ ] Share result as image card
- [ ] Push notifications for trending misinformation
- [ ] Support for additional languages (Hindi, Arabic)

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
