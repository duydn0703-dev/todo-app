import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key, required this.todoId});

  final String todoId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final todo = provider.getById(todoId);

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Todo Detail')),
        body: const Center(child: Text('Todo not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('Priority: ${todo.priority}'),
            const SizedBox(height: 12),
            Text(
              'Description: ${todo.description?.isNotEmpty == true ? todo.description : 'No description'}',
            ),
            const SizedBox(height: 12),
            Text(
              'Status: ${todo.isCompleted ? 'Done' : 'Pending'}',
              style: TextStyle(
                color: todo.isCompleted ? Colors.green : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      await context.read<TodoProvider>().toggleTodo(todo.id);
                    },
                    child: Text(
                      todo.isCompleted ? 'Mark as pending' : 'Mark as done',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final todoProvider = context.read<TodoProvider>();
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Delete todo'),
                            content: Text('Delete "${todo.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        await todoProvider.removeTodo(todo.id);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Delete todo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
