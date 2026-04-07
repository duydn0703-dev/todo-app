import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo({
    required String title,
    String? description,
    required String priority,
  });
  Future<void> toggleTodo(String id);
  Future<void> removeTodo(String id);
}
