# 🎬 Movie Universe
A Flutter application for discovering popular, top-rated, and searchable movies powered by The Movie Database (TMDB).

---

# 📖 Overview

Movie Universe is a Flutter application developed as a technical assessment.

The application allows users to browse, search and discover movies using **The Movie Database (TMDB)** API while demonstrating modern software engineering principles, scalable architecture and clean code practices.

The project follows a **Spec-Driven Development** approach using **Openspec**, where architecture, decisions, requirements and implementation tasks are defined as living specifications throughout the development lifecycle.

---

# 🎯 Objective

Develop a production-ready Flutter application that demonstrates:

- Software Engineering principles
- Clean Architecture
- SOLID Principles
- State Management
- Testability
- Scalability
- Documentation
- Code Quality

---

# ✨ Features

## Implemented

- 🎬 Popular Movies
- ⭐ Top Rated Movies
- 🔍 Search Movies by Name
- 📄 Movie Details
- ♾ Infinite Scroll Pagination
- ⚠ Error Handling
- 🔄 Loading States
- 📱 Responsive UI
- 🧪 Unit Tests
- 🧩 Widget Tests (design-system components, navigation flows)
- 🏗 Design System (Atomic Design under `lib/shared/design_system/`)

---

## Planned Improvements

- ❤️ Favorites
- 🌙 Dark Theme
- 🌍 Localization
- 📥 Offline Cache
- 🎞 Similar Movies
- 🎭 Cast Details
- 📺 TV Shows
- 🔔 Push Notifications
- Integration Tests
- Golden Tests

---

# 🏗 Architecture

The application follows **Clean Architecture** using a **Feature First** organization.

```text
Presentation
│
├── UI
├── Widgets
├── Riverpod Providers
│
Domain
│
├── Entities
├── Use Cases
├── Repository Contracts
│
Data
│
├── Remote Data Sources
├── DTOs
├── Repository Implementations
│
Core
│
├── Networking
├── Routing
├── Dependency Injection
├── Shared Utilities
```

This architecture promotes:

- Separation of Concerns
- Testability
- Maintainability
- Scalability
- Reusability

---

# 📂 Project Structure

The planned directory structure follows Clean Architecture with a Feature First organization:

```text
lib/

├── core/
│   ├── constants/
│   ├── network/
│   ├── router/
│   ├── errors/
│   ├── theme/
│   ├── extensions/
│   └── utils/
│
├── features/
│
│   ├── movies/
│   │
│   │── data/
│   │── domain/
│   │── presentation/
│   │
│   ├── search/
│   │
│   └── shared/
│
├── shared/
│
└── main.dart
```

---

# 🧠 Software Engineering Principles

The project applies:

- SOLID Principles
- Clean Code
- Clean Architecture
- Repository Pattern
- Feature First
- Immutable Models
- Dependency Injection
- Single Responsibility Principle
- Spec-Driven Development (Openspec)

---

# 📦 Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Mobile Framework |
| Dart | Programming Language |
| Riverpod | State Management |
| Dio | Networking |
| Freezed | Immutable Models |
| Fluro | Navigation |
| Build Runner | Code Generation |
| Mocktail / Mockito | Testing |

---

# 🌐 API

This application consumes data from:

**The Movie Database (TMDB)**

https://developer.themoviedb.org/

Authentication is performed using a Bearer Token generated from TMDB.

---

# 🔄 State Management

Riverpod is used as the application's state management solution.

Application flow:

```text
UI
↓
Provider / Notifier
↓
Use Case
↓
Repository
↓
Datasource
↓
TMDB API
```

---

# 🌍 Navigation

Navigation is managed using **Fluro**, providing centralized route management and better scalability.

---

# 🌐 Networking

Networking is implemented using **Dio**.

Features include:

- Interceptors
- Logging
- Timeouts
- Error Handling
- Retry Strategy

---

# ⚠ Error Handling

The application gracefully handles:

- No Internet Connection
- API Errors
- Timeout Exceptions
- Empty Responses
- Unexpected Exceptions

---

# 🧪 Testing

The testing strategy focuses on business logic.

Current coverage includes:

- Repository
- Providers
- Use Cases
- Data Mapping
- Search Logic
- Design-system widget tests
- List → detail navigation flow

Future coverage:

- Integration Tests
- Golden Tests

---

# ♿ Accessibility

Accessibility considerations include:

- Semantic widgets
- Dynamic text scaling
- Responsive layouts
- Screen reader compatibility

---

# 🚀 Getting Started

## Requirements

- Flutter 3.35.7+
- Dart 3.35.7+

---

## Installation

Clone the repository

```bash
git clone https://github.com/Esteban37/movie-universe-app.git
```

Navigate to the project

```bash
cd movie-universe-app
```

Install dependencies

```bash
flutter pub get
```

Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application

```bash
flutter run
```

---

# 🔐 Environment Configuration

Create a `.env` file (or your preferred secure configuration strategy) containing your TMDB API credentials.

Example:

```text
TMDB_ACCESS_TOKEN=YOUR_ACCESS_TOKEN
```

> The API token is intentionally excluded from the repository for security reasons.

---

# 📝 Assumptions

- Internet connection is required.
- A valid TMDB API token is required.
- API rate limits are managed by TMDB.
- The project prioritizes scalability over rapid implementation.

---

# 👨‍💻 Author

**Esteban Serrano**

Senior Mobile Software Engineer

---

> **"Software is not only about making things work, but about making them easy to evolve."**

---
