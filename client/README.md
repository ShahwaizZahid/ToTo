# 🍔 TOTO (Top Of The Order) - Food Delivery App

TOTO is a modern, responsive food delivery application built with **Flutter**. The app allows users to browse food items, add them to the cart with customizations, view detailed receipts, and track delivery progress — all with light/dark mode and persistent login using `SharedPreferences`.

## 📁 Project Structure

```
toto/
├── lib/
│   ├── models/
│   │   ├── cart_item_model.dart
│   │   ├── order_model.dart
│   │   └── user_model.dart
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   ├── cart/
│   │   │   └── cart_page.dart
│   │   ├── delivery/
│   │   │   └── delivery_page.dart
│   │   ├── help/
│   │   │   └── help_page.dart
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── receipt/
│   │   │   └── receipt_page.dart
│   │   └── about/
│   │       └── about_page.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── auth_service.dart
│   ├── widgets/
│   │   ├── app_bar.dart
│   │   ├── cart_item.dart
│   │   ├── receipt_item.dart
│   │   └── theme_switcher.dart
│   ├── main.dart
│   └── theme.dart
├── assets/
│   ├── images/
│   └── fonts/
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Setup Instructions

### 1. 📦 Prerequisites

Make sure you have the following installed:

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- An emulator or connected device
- Backend API running (see API endpoint config in `fetchCartItems`)

---

### 2. 🛠️ Installation Steps

```bash
git clone https://github.com/yourusername/toto_food_delivery_app.git
cd toto_food_delivery_app
flutter pub get
```

### 3. 🏃‍♂️ Running the App

```bash
flutter run
```

---
