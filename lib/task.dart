class Task {
  String description;
  String status; // "To Do", "In Progress", "Done"

  Task({required this.description, required this.status});

  // Convert a Task to a Map for local storage
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'status': status,
    };
  }

  // Convert a Map to a Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'],
      status: map['status'],
    );
  }
}
