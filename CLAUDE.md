# CLAUDE.md

## Project

Tagly is a Flutter app for browsing, searching, and organizing barbershop tags. It syncs from the barbershoptags.com API into a local SQLite database and lets users search, favorite, and build custom collections.

## Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Regenerate Freezed/JSON code after model changes
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

Clean-ish layered architecture:

- **`lib/domain/`** — Pure Dart models. Freezed for immutability. No dependencies on Flutter or external packages.
- **`lib/data/`** — Repositories (`ChangeNotifier`) own all business logic and state. One repository per domain concept (`TagsRepository`, `ListsRepository`, `SettingsRepository`).
- **`lib/db/`** — SQLite via sqflite. Schema in `schema.dart`, raw SQL queries in `queries/`.
- **`lib/config/`** — Wires everything together: `providers.dart` for DI, `router.dart` for GoRouter routes, `theme.dart` for Material theming.
- **`lib/presentation/`** — One folder per screen/feature. Each screen has a view model (`*_view_model.dart`) that wraps repository state and screen-specific logic.

## Key Conventions

- Models use `freezed` — run build_runner after editing `.dart` files that have `.freezed.dart` counterparts.
- Repositories extend `ChangeNotifier` and are provided via `Provider` in `providers.dart`.
- Navigation is declarative via `GoRouter`. Add new routes in `lib/config/router.dart`.
- Analytics calls go through `AnalyticsService` (wraps PostHog). Do not call PostHog directly.
- Linting is enforced by `very_good_analysis`. Fix any new lint warnings before committing.
- No comments unless the reason is non-obvious. Code should be self-documenting via naming.

## Testing

Tests live in `test/`, mirroring the `lib/` structure. Use `mocktail` for mocks and `charlatan` for fake data. Widget tests use `flutter_test`. Run with `flutter test`.

## State Management

Provider is used for DI and observable state. The pattern is:

1. Repository (ChangeNotifier) holds and mutates data
2. View model reads from one or more repositories
3. `router.dart` resolves dependencies from the Provider tree and injects them into screens and view models as constructor parameters

`context.watch` / `context.read` are used only in `lib/config/router.dart` and `lib/config/providers.dart`. Presentation code (screens, widgets, view models) receives dependencies via constructor injection and has no direct knowledge of Provider. This keeps the bulk of the app decoupled from the DI framework.

Avoid putting business logic in widgets or view models — keep it in the repository layer.
