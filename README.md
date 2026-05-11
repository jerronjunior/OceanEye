# OceanEye AI

> Empowering youth to protect our oceans through AI, community action, and environmental education.

## Project Overview
OceanEye AI is a production-ready Flutter application designed to reduce marine pollution. It combines:
1. AI-powered ocean waste detection (via Roboflow)
2. Community pollution reporting
3. Cleanup event mobilization
4. EcoPoints rewards system
5. Environmental education
6. Brand accountability analytics
7. Admin dashboard

## Technologies Used
- **Flutter & Dart**
- **Clean Architecture**
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Backend:** Firebase (Auth, Firestore, Storage, Messaging)
- **Maps:** Google Maps Flutter, Geolocator
- **AI Integration:** Roboflow API

## Project Structure
The project follows a standard Clean Architecture structure:
- `lib/core`: App theme, routing, constants, and shared external services.
- `lib/data`: Models, repositories, and data sources (Firebase implementations).
- `lib/features`: Feature modules like auth, home, scan, map, etc., each containing presentation (UI) and domain layers.
- `lib/shared`: Shared reusable UI widgets.

## Setup Instructions

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Set up [Firebase CLI](https://firebase.google.com/docs/cli) and login.
3. Install `flutterfire_cli` globally: `dart pub global activate flutterfire_cli`.

### Configuration
1. Clone or generate the project.
2. Run `flutter pub get`.
3. Configure Firebase for your project by running:
   ```bash
   flutterfire configure
   ```
4. Update `lib/core/services/ai_detection_service.dart` with your **Roboflow API Key** and model endpoint.
5. Setup Google Maps API keys for Android (`android/app/src/main/AndroidManifest.xml`) and iOS (`ios/Runner/AppDelegate.swift`).
6. Run the application:
   ```bash
   flutter run
   ```

## Priority MVP Features (Phase 1)
- Authentication
- Home screen
- AI scanning (Roboflow Integration)
- Report submission
- Pollution map

## Future Enhancements
- Cleanup Events & Volunteer Management
- EcoPoints Gamification
- Environmental Education Modules
- Brand Accountability Dashboard
- Admin Panel (Flutter Web)
