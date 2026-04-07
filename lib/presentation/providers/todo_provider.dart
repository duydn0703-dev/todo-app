import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider({required TodoRepository repository})
    : _repository = repository {
    unawaited(loadTodos());
  }

  final TodoRepository _repository;

  List<Todo> _todos = const [];
  List<Todo> get todos => _todos;

  Todo? getById(String id) {
    for (final todo in _todos) {
      if (todo.id == id) {
        return todo;
      }
    }
    return null;
  }

  Future<void> loadTodos() async {
    _todos = await _repository.getTodos();
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    String? description,
    required String priority,
  }) async {
    await _repository.addTodo(
      title: title,
      description: description,
      priority: priority,
    );
    await loadTodos();
  }

  Future<void> toggleTodo(String id) async {
    await _repository.toggleTodo(id);
    await loadTodos();
  }

  Future<void> removeTodo(String id) async {
    await _repository.removeTodo(id);
    await loadTodos();
  }
}
