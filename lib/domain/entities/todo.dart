class Todo {
  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String? description;
  final String priority;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
