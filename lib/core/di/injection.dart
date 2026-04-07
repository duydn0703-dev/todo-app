import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/in_memory_todo_repository.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../presentation/providers/theme_provider.dart';
import '../../presentation/providers/todo_provider.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<TodoProvider>() || sl.isRegistered<ThemeProvider>()) {
    await sl.reset();
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<TodoRepository>(
    () => InMemoryTodoRepository(sl<SharedPreferences>()),
  );

  sl.registerFactory(() => TodoProvider(repository: sl()));
  sl.registerFactory(() => ThemeProvider(sl()));
}
