# 🛍️ Local Community Marketplace

[![Status: Development](https://img.shields.io/badge/Status-Development-yellow)]()
[![Platform: Mobile](https://img.shields.io/badge/Platform-Mobile-blue)]()

<!-- [![Release](https://img.shields.io/badge/Release-v1.0-blue)](https://github.com/ARTTTT-TTTT/local-community-marketplace/releases/tag/v1.0.0) -->

> **Local Community Marketplace** descritpion.

---

## ✨ Quickstart ✨

### ⬇️ Get dependencies

```bash
flutter pub get
```

### 🚀 Run the app

- `macOS, iOS`

```bash
open ios/Runner.xcworkspace
```

```bash
flutter run
```

### 📝 Testing

```bash
flutter test
```

---

## 🛠️ Tech Stack

| Technology | Icon                                                                                                        |
| ---------- | ----------------------------------------------------------------------------------------------------------- |
| Dart       | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)             |
| Flutter    | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)    |
| Firebase   | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) |

---

## 📂 Project Structure

```
lib/
├── screens/    # โฟลเดอร์สำหรับหน้าจอหลักแต่ละหน้าของแอป (e.g., login_screen.dart, home_screen.dart)
├── widgets/    # โฟลเดอร์สำหรับ Widget ที่นำกลับมาใช้ซ้ำได้ทั่วทั้งแอป (e.g., custom_button.dart, app_bar_widget.dart)
├── models/     # โฟลเดอร์สำหรับโมเดลข้อมูล (Dart classes) ที่ใช้ในแอป (e.g., user_model.dart, product_model.dart)
├── services/   # โฟลเดอร์สำหรับบริการต่างๆ เช่น การเรียกใช้ API, การจัดการ Local Storage, Firebase (e.g., api_service.dart, auth_service.dart)
├── utils/      # โฟลเดอร์สำหรับฟังก์ชันหรือคลาสยูทิลิตี้ทั่วไป (e.g., app_constants.dart, helper_functions.dart)
└── main.dart   # จุดเริ่มต้นของแอปพลิเคชัน
```
