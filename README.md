**Screenshots**
<p align="center">
  <img src="https://github.com/user-attachments/assets/91b8eba7-6eb7-48fd-b1f7-4292961d3536" width="220" hspace="10"/>
  <img src="https://github.com/user-attachments/assets/31be663f-56e9-4c10-97af-f03f7444278b" width="220" hspace="10"/>
  <img src="https://github.com/user-attachments/assets/fbe65f16-e988-4219-9347-ba13229bc2d4" width="220" hspace="10"/>
</p>

<br/>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d00a1c16-6f22-44a4-9905-059e54189174" width="220" hspace="10"/>
  <img src="https://github.com/user-attachments/assets/3a4f6b79-3d33-4999-8fd4-f2bcc4c2ebce" width="220" hspace="10"/>
  <img src="https://github.com/user-attachments/assets/44f98a11-7f81-49b4-9b46-d539ecc0a38c" width="220" hspace="10"/>
</p>

<br/>

# 📰 Fake News Scanner — Full Stack

> **AI-powered misinformation detection.** Scan any news article or screenshot, extract the text via OCR, and get an instant credibility verdict powered by AI — with full English and Urdu support.

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-339933?style=flat-square&logo=node.js)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.x-000000?style=flat-square&logo=express)](https://expressjs.com/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?style=flat-square&logo=mongodb)](https://www.mongodb.com/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

---

## 📖 Overview

Fake News Scanner is a full-stack mobile application built with **Flutter (frontend)** and **Node.js + Express + MongoDB (backend)**. Users scan or upload news article images; the app extracts the text via OCR, sends it to the backend, which queries an AI fact-checking service, cross-references credible sources, and returns a structured verdict — all within seconds.

| Repository | Tech | Purpose |
|------------|------|---------|
| `fakenews-frontend/` | Flutter + Dart | Mobile UI, camera, OCR, result display |
| `fakenews-backend/` | Node.js + Express + MongoDB | API, AI integration, scan persistence |

---

## ✨ Features

- **Camera & Gallery Scanning** — Capture news articles in real-time or upload screenshots from your gallery
- **OCR Text Extraction** — Extracts readable text from images automatically
- **AI Credibility Analysis** — Evaluates claims and returns a verdict: Verified, Doubtful, or Fake
- **Credibility Score** — A 0–100% confidence score with a visual gradient scale
- **Claim Detection** — Highlights individual claims found within the article
- **Source Verification** — Cross-references results against known credible sources (WHO, Reuters, Bloomberg, etc.)
- **Bilingual Support** — Full English and Urdu (اردو) language toggle with RTL rendering
- **Scan History** — Tracks and displays recent scan results
- **Animated UI** — Splash screen, moving scan line, step-by-step processing, and result transitions

---

## 🏗️ Project Structure

```
fakenews-scanner/
│
├── fakenews-frontend/              # Flutter mobile app
│   └── lib/
│       ├── main.dart               # Entry point, theme, all screens
│       ├── models/
│       │   ├── scan_result.dart    # ScanResult, VerifiedSource models
│       │   └── enums.dart          # CredibilityLevel, AppLanguage, ScanState
│       ├── screens/
│       │   ├── splash_screen.dart  # Animated splash with progress bar
│       │   └── home_screen.dart    # Scanner UI, processing, result display
│       └── widgets/
│           ├── verdict_card.dart   # Credibility verdict display
│           ├── score_bar.dart      # Animated credibility gradient scale
│           └── source_tile.dart    # Individual verified source item
│
└── fakenews-backend/               # Node.js REST API
    ├── controllers/
    │   └── scanController.js       # Receives text → calls AI → formats verdict
    ├── models/
    │   └── Scan.js                 # Mongoose schema for scan records
    ├── routes/
    │   └── scanRoutes.js           # Express router (POST /scan, GET /history)
    ├── .env                        # Environment variables (never commit)
    ├── package.json                # Dependencies and scripts
    └── server.js                   # App entry point, DB connect, middleware
```

---

## 🔁 System Flow

```
User scans / uploads image
          ↓
Flutter (OCR extraction)
          ↓
POST /api/scan  →  scanRoutes.js  →  scanController.js
          ↓
AI Fact-Check API (Claude / OpenAI)
          ↓
Save to MongoDB via Scan.js model
          ↓
JSON verdict returned to Flutter
{ credibility, score, claims, explanation, sources }
          ↓
Result screen — Verdict card, score bar, sources list
```

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/scan` | Submit extracted text for fact-checking |
| `GET` | `/api/scan/history` | Retrieve recent scan results |
| `GET` | `/api/scan/:id` | Get a single scan result by ID |
| `DELETE` | `/api/scan/:id` | Delete a scan from history |

### Example Request

```json
POST /api/scan
{
  "text": "Scientists confirm new vaccine eliminates all viruses permanently.",
  "language": "en"
}
```

### Example Response

```json
{
  "credibility": "fake",
  "score": 0.08,
  "detectedClaims": ["Vaccine eliminates all viruses permanently"],
  "explanation": "No vaccine eliminates all viruses permanently. This is a common misinformation pattern.",
  "sources": [
    { "title": "WHO Vaccine Safety Report", "publisher": "WHO", "supports": false }
  ],
  "scannedAt": "2025-05-26T10:30:00.000Z"
}
```

---

## 🗄️ Database Schema — `Scan.js`

| Field | Type | Description |
|-------|------|-------------|
| `extractedText` | String | Raw OCR text from the scanned image |
| `credibility` | String | `verified` / `doubtful` / `fake` |
| `score` | Number | Confidence score 0.0 – 1.0 |
| `detectedClaims` | [String] | Individual claims extracted from the text |
| `explanation` | String | AI-generated explanation of the verdict |
| `sources` | [Object] | Cross-referenced sources with support flag |
| `language` | String | `en` or `ur` for bilingual response |
| `createdAt` | Date | Auto-generated scan timestamp |

---

## 🎨 Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile Framework | Flutter (Dart) |
| UI | Material 3, Custom Painters |
| State | `setState` (local) |
| Animations | `AnimationController`, `TweenAnimationBuilder` |
| OCR | Google ML Kit (planned) |
| Backend | Node.js + Express.js |
| Database | MongoDB (Mongoose) |
| AI Integration | Claude / OpenAI API |
| Languages | English + Urdu (RTL) |

---

## 🟢 Credibility Levels

| Level | Color | Description |
|-------|-------|-------------|
| ✅ Verified | Green `#00E87A` | Claim is supported by credible sources |
| ⚠️ Doubtful | Amber `#FFB020` | Partially supported or unconfirmed |
| ❌ Fake | Red `#FF3B5C` | Contradicted by credible sources |

---

## ⚙️ Environment Variables — Backend (`.env`)

```env
PORT=5000
MONGO_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/fakenews
AI_API_KEY=your_claude_or_openai_key
AI_MODEL=claude-sonnet-4-20250514
NODE_ENV=development
```

> ⚠️ Add `.env` to `.gitignore` — never commit secrets.

---

## 🚀 Getting Started

### Frontend (Flutter)

```bash
git clone https://github.com/your-username/fakenews-frontend.git
cd fakenews-frontend
flutter pub get
flutter run
```

### Backend (Node.js)

```bash
git clone https://github.com/your-username/fakenews-backend.git
cd fakenews-backend
npm install
cp .env.example .env   # fill in your keys
npm run dev
```

### Build (Flutter)

```bash
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS
```

---

## 📦 Backend Dependencies

| Package | Purpose |
|---------|---------|
| `express` | HTTP server and routing |
| `mongoose` | MongoDB ODM |
| `dotenv` | Environment variable loading |
| `cors` | Cross-origin requests from Flutter |
| `axios` | AI API HTTP calls |
| `helmet` | Secure HTTP headers |
| `morgan` | Request logging |
| `nodemon` *(dev)* | Auto-restart on file changes |

---

## 🗺️ Roadmap

- [ ] Integrate real OCR — Google ML Kit
- [ ] Connect to live fact-checking API
- [ ] Persistent scan history — Hive / SQLite on device
- [ ] Share result as image card
- [ ] Push notifications for trending misinformation
- [ ] Support for additional languages (Hindi, Arabic)
- [ ] User authentication with JWT
- [ ] Admin dashboard for scan analytics

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
