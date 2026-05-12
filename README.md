# Tagly

A Flutter app for browsing, searching, and organizing barbershop tags from [barbershoptags.com](https://barbershoptags.com).

## Features

- **Search & Browse** — Full-text search with filters for voicing, part count, sort order, and classics
- **Tag Details** — Arranger, singer, recording info, and learning resources per tag
- **Audio Learning Tracks** — Play tenor, lead, baritone, and bass voice parts
- **Sheet Music** — View PDFs and images inline
- **Favorites** — Bookmark tags for quick access
- **Custom Lists** — Create and manage personal collections of tags
- **Offline Cache** — Tags are synced to a local SQLite database and refreshed every 24 hours

## Tech Stack

- **Flutter** (Dart)
- **State management**: Provider / ChangeNotifier
- **Navigation**: GoRouter
- **Database**: sqflite (SQLite)
- **HTTP**: Dio
- **Analytics**: PostHog
- **Code generation**: Freezed, json_serializable

## Project Structure

```
lib/
├── config/        # Providers, router, theme, analytics
├── domain/        # Core data models (BarbershopTag, TagList, etc.)
├── data/          # Repositories and API client
├── db/            # SQLite schema, queries, and migrations
└── presentation/  # Screens and widgets, organised by feature
```

## Getting Started

```bash
flutter pub get
flutter run
```

To regenerate Freezed/JSON code after model changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Requirements

- Flutter SDK (see `.fvm/fvm_config.json` or `pubspec.yaml` for version constraints)
- iOS 14+ / Android API 21+
