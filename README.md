# AndroMarkets

**Mobile App**  
Multi-trading platform for forex, stocks, and cryptocurrencies using ECM Token as the primary currency.

---

## 🛠️ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Latest stable)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio or VS Code
- Xcode (for iOS development, macOS only)
- Recent versions of Android/iOS device/emulator

---

## ⚡ Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/devhimuBlockVerse/andromarkets.git
   cd andromarkets
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Platform-specific setup**

   - **Android:**  
     Confirm that `android/app/build.gradle` specifies minimum SDK version meeting requirements for your plugins.

   - **iOS:**  
     From the `ios/` directory, run:
     ```bash
     pod install
     ```
     Ensure Xcode command-line tools are installed (`xcode-select --install`).

---

## ▶️ Running the App

- **Android Emulator**
  ```bash
  flutter run
  ```
- **Specific Device**
  ```bash
  flutter devices       # list devices
  flutter run -d <device_id>
  ```

- **iOS (macOS only)**
  ```bash
  flutter run
  ```

---

## 📁 Project Structure

- `/lib` : Main Dart source code
- `/android` : Native Android config (Kotlin/Java/C++)
- `/ios` : Native iOS config (Swift/Objective-C)
- `/test` : Dart unit/widget tests
- `/assets` : Images, fonts, etc.

Includes C++, CMake, Swift modules for platform integrations and advanced features.

---

## 🤝 Contributing

1. Fork the repo and create your feature branch (`git checkout -b feature/YourFeature`)
2. Commit your changes (`git commit -am 'Add new feature'`)
3. Push to the branch (`git push origin feature/YourFeature`)
4. Create a Pull Request

---

## ❓ Troubleshooting

- **Missing dependencies:** Run `flutter pub get` or `pod install` (in `ios/`).
- **Platform issues:** Check Flutter doctor for setup problems
  ```bash
  flutter doctor
  ```
- **Build errors:** Clean project (`flutter clean`), restart IDE, verify min/max SDK versions.
 
---


