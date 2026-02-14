// models/todo_model.dart
class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  // Method to toggle completion status
  void toggleCompleted() {
    completed = !completed;
  }
}