# 📱 Flutter Project Name

A cross-platform mobile app built using Flutter following Clean Architecture principles, integrated with Bloc for state management, Firebase for backend services, and Docker for reproducibility.  
Automated testing and CI/CD via GitHub Actions.

---

## 🚀 Features

- 🔐 Firebase Authentication
- 🔄 Bloc State Management
- ☁️ Firebase Firestore & Storage
- 🌙 Dark & Light Theme
- 🌐 Responsive UI (mobile, tablet, web)
- 🧪 Complete Test Suite (unit, widget, integration)
- 🐳 Docker Support
- 🚀 GitHub Actions CI/CD Pipeline

---

## 🛠️ Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Docker](https://www.docker.com/)
- [Android Studio](https://developer.android.com/studio) / [VS Code](https://code.visualstudio.com/)
- Xcode (macOS for iOS development)

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/flutter-project-name.git
cd flutter-project-name
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Setup Firebase

- Create a Firebase project in Firebase Console
- Add google-services.json (Android) to android/app/
- Add GoogleService-Info.plist (iOS) to ios/Runner/
- Enable required services like Authentication, Firestore, etc.

Initialize Firebase:

```bash
firebase login
firebase init
```

## 🧱 Clean Architecture Structure

```
lib/
├── core/                  # Shared utilities, themes, constants
├── features/
│   ├── feature_name/
│   │   ├── data/          # DTOs, repositories
│   │   ├── domain/        # Entities, use cases
│   │   └── presentation/  # Bloc, UI widgets, screens
├── main.dart              # Entry point
test/
integration_test/
```

## 🔄 State Management (Bloc)

Using flutter_bloc

```bash
flutter pub add flutter_bloc
```

Basic Bloc Structure:

```
presentation/
├── bloc/
│   ├── feature_bloc.dart
│   ├── feature_event.dart
│   └── feature_state.dart
```

Usage in widget:

```dart
BlocProvider(
  create: (_) => FeatureBloc()..add(LoadFeatureEvent()),
  child: FeatureScreen(),
)
```

## Development

```bash
pact-stub-server --file ./test/outputs/contracts/mobile-authn.json --loglevel debug --port 42985 --cors
```

Android Emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:42985
```

Web:

```bash
flutter run -d web-server --web-port=8080 --dart-define=API_BASE_URL=http://localhost:42985
```

## 🧪 Testing

### Unit & Widget Tests

```bash
flutter test
```

Run a specific test:

```bash
flutter test test/path_to_test.dart
```

### Contract Tests

```bash
PACT_DART_LIB_DOWNLOAD_PATH=./bin flutter pub run pact_dart:install
PACT_DART_LIB_DOWNLOAD_PATH=./bin flutter test test/contract/query_matching_test.dart
```

### Integration Tests

Add to pubspec.yaml:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

Run all integration tests:

```bash
flutter test integration_test
```

Or use:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
```

## 🐳 Docker Support
### Build Docker Image

```bash
docker build -t flutter_app .
```

### Run Container

```bash
docker run -p 8080:80 flutter_app
```

> Note: You may need to use flutter-web with webdev for Dockerized web deployments.

## ⚙️ GitHub Actions CI/CD

Create `.github/workflows/flutter_ci.yml`:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'

    - name: Install Dependencies
      run: flutter pub get

    - name: Run Analyzer
      run: flutter analyze

    - name: Run Tests
      run: flutter test
```

## 📂 Directory Overview

```
.
├── lib/
├── test/
├── integration_test/
├── Dockerfile
├── .github/workflows/
├── pubspec.yaml
├── README.md
└── ...
```

## 📄 License

This project is licensed under the MIT License.

## 🙋 Support

Feel free to open an issue or contact [yourname@domain.com] for help.

## 🌟 Star This Repo

If you found this project helpful, consider starring ⭐ the repo to show your support!


---

Let me know if you'd like the `Dockerfile`, Firebase configuration files (`firebase.json`, `google-services.json`), or a sample GitHub Actions secrets setup as well.
