import 'package:flutter/material.dart';

import '../../presentation/screens/add_todo_screen.dart';
import '../../presentation/screens/todo_detail_screen.dart';
import '../../presentation/screens/todo_screen.dart';

class AppRoutes {
  static const home = '/';
  static const addTodo = '/add-todo';
  static const todoDetail = '/todo-detail';
}

class TodoDetailArgs {
  const TodoDetailArgs({required this.todoId});

  final String todoId;
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          builder: (_) => const TodoScreen(),
          settings: settings,
        );
      case AppRoutes.addTodo:
        return MaterialPageRoute<void>(
          builder: (_) => const AddTodoScreen(),
          settings: settings,
        );
      case AppRoutes.todoDetail:
        final args = settings.arguments as TodoDetailArgs;
        return MaterialPageRoute<void>(
          builder: (_) => TodoDetailScreen(todoId: args.todoId),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings: settings,
        );
    }
  }
}
