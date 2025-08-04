# 🛍️ Local Community Marketplace

[![Status: Development](https://img.shields.io/badge/Status-Development-yellow)]()
[![Platform: Mobile](https://img.shields.io/badge/Platform-Mobile-blue)]()

<!-- [![Release](https://img.shields.io/badge/Release-v1.0-blue)](https://github.com/ARTTTT-TTTT/local-community-marketplace/releases/tag/v1.0.0) -->

> **Local Community Marketplace** descritpion.

---

## 🛠️ Tech Stack

| Technology | Icon                                                                                                        |
| ---------- | ----------------------------------------------------------------------------------------------------------- |
| Dart       | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)             |
| Flutter    | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)    |
| Firebase   | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) |

---

## ✨ Quickstart ✨

### ⬇️ Get dependencies

```bash
cd mobile
flutter pub get
```

### 🔥 Firebase Setup

- `Android`

1. Download `google-services.json`
2. Place it in `android/app/` directory

- `iOS`

1. Download `GoogleService-Info.plist`
2. Place it in `ios/Runner/` directory

- `Website`

### 🚀 Run the app

- `macOS, iOS`

```bash
open ios/Runner.xcworkspace
```

```bash
xcrun simctl list devices
xcrun simctl boot "iPhone 16"
```

```bash
open -a Simulator
```

```bash
flutter run
```

### 📝 Testing

```bash
flutter test
```

---

## 📂 Project Structure

```
mobile/
└── lib/
  ├── screens/    # โฟลเดอร์สำหรับหน้าจอหลักแต่ละหน้าของแอป (e.g., login_screen.dart, home_screen.dart)
  ├── widgets/    # โฟลเดอร์สำหรับ Widget ที่นำกลับมาใช้ซ้ำได้ทั่วทั้งแอป (e.g., custom_button.dart, app_bar_widget.dart)
  ├── providers/
  ├── models/     # โฟลเดอร์สำหรับโมเดลข้อมูล (Dart classes) ที่ใช้ในแอป (e.g., user_model.dart, product_model.dart)
  ├── services/   # โฟลเดอร์สำหรับบริการต่างๆ เช่น การเรียกใช้ API, การจัดการ Local Storage, Firebase (e.g., api_service.dart, auth_service.dart)
  ├── utils/      # โฟลเดอร์สำหรับฟังก์ชันหรือคลาสยูทิลิตี้ทั่วไป (e.g., app_constants.dart, helper_functions.dart)
  ├── assets/
  └── main.dart   # จุดเริ่มต้นของแอปพลิเคชัน
docs/
wireframe/
firebase/
```

---

## 🌿 Branch Workflow 🌿

- ทุกฟีเจอร์ใหม่ ให้แตก branch จาก `dev` โดยใช้รูปแบบ:

**🌿 Feature Branch**

```bash
feature/<module>/<task-name>
```
