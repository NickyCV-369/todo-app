class Todo {
  final int id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? dueDate;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"] ?? "",
        isCompleted: json["isCompleted"] ?? false,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        dueDate: json["dueDate"] != null && json["dueDate"] != "" ? DateTime.parse(json["dueDate"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "isCompleted": isCompleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "dueDate": dueDate?.toIso8601String(),
      };
}
