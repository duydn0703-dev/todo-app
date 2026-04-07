# todo_app

Simple Flutter todo app using Clean Architecture, `provider`, and `get_it` for DI.

## Features

- Add a new todo
- Mark todo as completed/uncompleted
- Remove todo by swiping left
- Persist todos across app relaunches with `shared_preferences`
- Toggle dark mode (saved for next launch)
- Reactive UI updates with `ChangeNotifier` + `Provider`

## Run the app

```bash
flutter pub get
flutter run
```

## Architecture

```
lib/
  core/di/                 # Dependency injection setup (get_it)
  data/repositories/        # Data implementations
  domain/entities/          # Business entities
  domain/repositories/      # Repository abstractions
  presentation/providers/   # UI state management (provider)
  presentation/screens/     # Widgets/screens
```

## State management and DI

- `TodoProvider` extends `ChangeNotifier`
- `TodoProvider` depends on `TodoRepository` abstraction
- `ChangeNotifierProvider` is wired in `app.dart`
- Dependencies are registered in `core/di/injection.dart` via `get_it`
- Data layer repository stores todos in `shared_preferences`
- UI reads state with `context.watch<TodoProvider>()`
- UI updates state with `context.read<TodoProvider>()`

## References

- [Flutter state management guide](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
- [provider package on pub.dev](https://pub.dev/packages/provider)
- [get_it package on pub.dev](https://pub.dev/packages/get_it)
- [shared_preferences package on pub.dev](https://pub.dev/packages/shared_preferences)
- [Flutter cookbook](https://docs.flutter.dev/cookbook)
