import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

class InMemoryTodoRepository implements TodoRepository {
  InMemoryTodoRepository(this._prefs);

  static const _todosKey = 'todos';

  final SharedPreferences _prefs;
  final List<Todo> _todos = [];

  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) {
      return;
    }

    final rawList = _prefs.getStringList(_todosKey) ?? const [];
    _todos
      ..clear()
      ..addAll(
        rawList.map((raw) {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          return Todo(
            id: map['id'] as String,
            title: map['title'] as String,
            description: map['description'] as String?,
            priority: (map['priority'] as String?) ?? 'Medium',
            isCompleted: map['isCompleted'] as bool,
          );
        }),
      );

    _isLoaded = true;
  }

  Future<void> _save() async {
    final encoded = _todos
        .map(
          (todo) => jsonEncode({
            'id': todo.id,
            'title': todo.title,
            'description': todo.description,
            'priority': todo.priority,
            'isCompleted': todo.isCompleted,
          }),
        )
        .toList(growable: false);
    await _prefs.setStringList(_todosKey, encoded);
  }

  @override
  Future<void> addTodo({
    required String title,
    String? description,
    required String priority,
  }) async {
    await _ensureLoaded();
    final trimmed = title.trim();
    final descriptionTrimmed = description?.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _todos.add(
      Todo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmed,
        description: (descriptionTrimmed == null || descriptionTrimmed.isEmpty)
            ? null
            : descriptionTrimmed,
        priority: priority,
      ),
    );
    await _save();
  }

  @override
  Future<List<Todo>> getTodos() async {
    await _ensureLoaded();
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> removeTodo(String id) async {
    await _ensureLoaded();
    _todos.removeWhere((todo) => todo.id == id);
    await _save();
  }

  @override
  Future<void> toggleTodo(String id) async {
    await _ensureLoaded();
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    final current = _todos[index];
    _todos[index] = current.copyWith(isCompleted: !current.isCompleted);
    await _save();
  }
}
