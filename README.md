# Lapse 🎓

> **A Modern, Offline-First School Tracking Application built with Flutter.**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-Local_DB-orange?style=for-the-badge)

## 📖 Overview

**Lapse** is a comprehensive tool designed for students to manage their academic life efficiently. It allows users to track their weekly schedules, exams, and course details in a unified interface. 

Built with an **Offline-First** architecture, Lapse ensuring that your data is always accessible, regardless of your internet connection. It seamlessly synchronizes with the cloud when you're back online, providing the reliability of a local app with the power of the cloud.

## ✨ Key Features

- **🛠️ Advanced Schedule Builder:** Define school hours, break durations, and lunch intervals once to automatically generate your weekly schedule skeleton.
- **📚 Course & Subject Management:** detailed management of courses including teacher names, classrooms, ECTS credits, and custom color coding.
- **📅 Dynamic Weekly Timetable:** intuitive slot-based system to organize your daily lessons.
- **📝 Exam Tracking:** specialized module to track upcoming exams, linked directly to your courses.
- **📶 Offline-First Architecture:** full read/write functionality without an internet connection. Automatic synchronization with Firebase upon reconnection.
- **📱 PWA Support:** fully installable on mobile devices with a native-like experience.
- **🎨 Premium UI/UX:** built with the **Moon Design System**, featuring a polished, modern, and responsive interface.

## �️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Web, Android, iOS)
- **Language:** [Dart](https://dart.dev/)
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **Backend:** [Firebase](https://firebase.google.com/) (Auth, Firestore)
- **Local Database:** [Hive](https://docs.hivedb.dev/) (NoSQL)
- **Design System:** [Moon Design](https://moon.io/)

## 🏗️ Architecture

Lapse follows a **Feature-First** architecture pattern, heavily inspired by Clean Architecture principles. The core philosophy is **Offline-First**, ensuring a seamless user experience.

### Architectural Layers

1.  **Presentation Layer (UI):**  
    Contains Screens, Widgets, and Riverpod Providers. It observes the state and renders the UI using Moon Design components.
2.  **Domain Layer (Business Logic):**  
    Contains pure Dart Entities and Repository Interfaces. This layer is independent of any external libraries.
3.  **Data Layer (Data Access):**  
    Handles data retrieval and storage. It implements the "Cache-First" strategy using:
    *   **Hive:** For immediate, offline-ready local data access.
    *   **Firestore:** For remote synchronization and backup.

### Data Flow (Offline-First)

```mermaid
graph TD
    A[User Action] --> B[Notifier]
    B --> C{Update UI}
    B --> D[Repository]
    D --> E[Hive (Local Cache)]
    D --> F[Firestore (Remote)]
    
    subgraph "Read Operation"
    G[App Start] --> H[Load from Hive]
    H --> I[Show UI Immediately]
    end
```

## 📂 Project Structure

```bash
lib/
├── core/                   # Shared resources
│   ├── components/         # Reusable UI components (AppButton, AppCard, etc.)
│   ├── theme/              # AppTheme, Colors, and Design Tokens
│   └── constants/          # Global constants
├── features/               # Feature-based modules
│   ├── auth/               # Authentication logic & screens
│   ├── calendar/           # Schedule & Lesson management
│   ├── exams/              # Exam tracking
│   ├── home/               # Dashboard
│   └── layout/             # Main app scaffold and navigation
├── firebase_options.dart   # Firebase configuration
└── main.dart               # App entry point
```

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.4 or higher)
- [Git](https://git-scm.com/)
- A Firebase project configured for this app.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/emir-candan/lapse_program_takip.git
    cd lapse_program_takip
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

> **Note:** This project uses Firebase. You will need to provide your own `firebase_options.dart` file or configure your Firebase project if you are forking this repo.

## 🤝 Contributing

Contributions are welcome! Please examine the `SYSTEM_GUIDE.md` and `OFFLINE_FIRST_GUIDE.md` in the root directory to understand the coding standards and architectural rules before submitting a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Developed by <a href="https://github.com/emir-candan">Emir Candan</a>
</p>
