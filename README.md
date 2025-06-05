# 🤱 MomStretch+

> A mobile platform to support postpartum moms with smart fitness tools and mental health tracking.

![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-lightblue)
![Status](https://img.shields.io/badge/status-development-orange)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📌 Overview

**MomStretch+** is a mobile-based health platform designed to assist postpartum mothers in staying physically and mentally healthy. The app integrates guided exercise routines using real-time pose estimation, as well as tools for tracking mental wellness, including the EPDS (Edinburgh Postnatal Depression Scale) test.

The mobile app is developed using Flutter and is supported by a Flask-based backend API.

---

## ✨ Key Features

- 🧘 Guided postpartum workout routines
- 🤖 Real-time pose detection (via camera)
- 🧠 EPDS (mental health) questionnaire
- 🔐 User authentication and profile management
- 📊 Progress tracking

---

## 📱 Technology Stack (Frontend)

| Layer         | Technology          |
|---------------|----------------------|
| Language      | Dart                 |
| Framework     | Flutter              |
| State Mgmt    | GetX                 |
| Camera        | `camera` package     |
| Form UI       | Custom & Dynamic     |
| API Comm.     | HTTP + Interceptors  |

> For backend stack, see: [momstretch-backend](https://github.com/humam-ashaq/momstretch-backend)

---

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/humam-ashaq/momstretch.git
cd momstretch

# Get dependencies
flutter pub get

# Run on device or emulator
flutter run
```

Make sure a device/emulator is connected, and Flutter SDK is installed.

---

## 📂 Project Structure (Simplified)

```
momstretch/
├── lib/
│   ├── main.dart              # Entry point
│   ├── modules/               # Feature-based structure
│   │   ├── auth/              # Login/Register
│   │   ├── workout/           # Exercise modules
│   │   ├── epds/              # Mental health tracking
│   │   └── ...                # Other features
│   ├── services/              # API handling & storage
│   └── widgets/               # Shared UI components
├── assets/                    # Images, icons, etc.
├── pubspec.yaml               # Flutter config
```

---

## 🧪 Testing Features

- EPDS Test form with dynamic scoring
- Camera-based pose detection
- API integration for user login & data sync

---

## 🙌 Contribution Guide

We welcome contributions! To contribute:

1. Fork the repository
2. Create a new branch (`feature/your-feature`)
3. Make your changes and commit
4. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Authors

📎 [Humam Asathin Haqqani](https://github.com/humam-ashaq)  
📎 [Asih Rahmawati](https://github.com/Asihraa)

---

> Made with ❤️ to support healthy motherhood and well-being.
