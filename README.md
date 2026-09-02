# 🌸 Flowery App

A modern, full-featured E-Commerce & Flower Delivery Flutter application built with **Clean Architecture**, **Cubit State Management**, and **RESTful API / Firebase Integration**.

---

## 👥 Development Team

This project was engineered and developed by:

| Developer | GitHub Profile |
| :--- | :--- |
| **AbdEl-Rahman Mohamed Shalaan** | [@AER-Shalaan](https://github.com/AER-Shalaan) |
| **Ahmed Mohsen** | [@ahmedmohsen087](https://github.com/ahmedmohsen087) |
| **Mohamed Abbas** | [@MohamedAbbas289](https://github.com/MohamedAbbas289) |
| **Mohamed Ebrahim** | [@MohamedEbrahim10](https://github.com/MohamedEbrahim10) |

---

## 🚀 Key Features

* 🔐 **Authentication & Security**
  * User Registration & Login with Remember Me functionality.
  * Password recovery via OTP email verification & password reset.
  * Secure token storage using `FlutterSecureStorage`.

* 📍 **Smart Delivery Address System**
  * Auto-resolves current location via GPS and reverse geocoding.
  * Intelligent Distance Matching: Automatically calculates & selects the **nearest saved address** relative to user's real-time position.
  * Full Address Management (Add, Edit, Delete, Set Default).

* 🛍️ **Home & Product Catalog**
  * Interactive categories, best sellers, and occasion-based flower arrangements.
  * Live search with instant filtering.
  * Detailed product views with image galleries & stock tracking.

* 🛒 **Cart & Checkout Flow**
  * Flexible Cart management (Quantity adjustments, item removal, price summary).
  * Multiple Payment Methods: Cash on Delivery & Online Card Payment via Stripe.
  * Gift Ordering Option: Send arrangements directly to recipients with custom recipient name & phone.
  * Confirmation dialogs for current location delivery.

* 🗺️ **Live Order Tracking & Maps**
  * Real-time driver location updates via Firestore streams.
  * Interactive map route display powered by OSRM route service.
  * Live delivery status progress tracking.

* 🌐 **Localization & Theming**
  * Full bilingual support for **Arabic (العربية)** and **English**.
  * Custom Material 3 theme & typography.

---

## 🏗️ Architecture & Tech Stack

### Architecture
The project strictly follows **Clean Architecture** principles separated into three core layers per feature:
- `Data Layer`: DTO models, Mappers, Data Sources, Repositories implementations.
- `Domain Layer`: Entities, Repository Contracts, Use Cases.
- `Presentation Layer`: Cubits/BLoCs, States, Events, Screens, Widgets.

```
lib/
├── config/                  # App DI, Firebase, Auth, Base Response/State
├── core/                    # Global Services, Themes, Values, Utilities & Reusable Widgets
└── features/                # Feature-based Clean Architecture Modules
    ├── address/             # Address Management & Resolution
    ├── auth/                # Login, Signup, Reset Password
    ├── home/                # Categories, Best Sellers, Occasions
    ├── profile/             # Profile Settings & Order History
    └── shopping/            # Cart, Checkout, Product Details, Live Tracking
```

### Tech Stack & Package Ecosystem
- **Framework:** Flutter (Dart SDK ^3.12)
- **State Management:** `flutter_bloc` / `Cubit` & `bloc_test`
- **Dependency Injection:** `get_it` & `injectable`
- **Networking:** `dio`, `retrofit`, `dio_cache_interceptor` & `pretty_dio_logger`
- **Local Storage:** `hive`, `flutter_secure_storage` & `shared_preferences`
- **Location & Maps:** `geolocator`, `geocoding`, `flutter_map`, `latlong2`
- **Push Notifications & Firebase:** `firebase_core`, `cloud_firestore`, `firebase_messaging`, `firebase_crashlytics`
- **Localization:** `easy_localization` & `intl`

---

## ⚙️ Software Engineering Standards

All code within the repository adheres to strict software quality principles:
- **DRY (Don't Repeat Yourself):** Reusable utilities, base states, and shared widgets.
- **KISS & YAGNI:** Simple, clean, and uncluttered codebase.
- **SOLID Principles:** Single Responsibility Principle per class, Interface Segregation, Dependency Inversion.
- **Method & Widget Limits:** Methods are kept under 20 lines of code; widget build methods under 50 lines.
- **Zero Comments Policy:** Code is self-documenting through expressive symbol naming.
- **No Hardcoded Values:** UI & domain strings are localized in translation files and `AppStrings`.

---

## 💻 Getting Started

### Prerequisites
- Flutter SDK (version 3.12.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Java Development Kit (JDK 17)

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ahmedmohsen087/flower-app.git
   cd flower-app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Code (Injectable / Retrofit / JSON Serializable):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 🧪 Running Tests

To run automated unit & widget tests across all features:

```bash
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
