import 'dart:convert';

class TaskEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int priority;
  final int progress;
  final String? category;
  final bool isCompleted;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.progress,
    required this.category,
    required this.isCompleted,
  });

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, progress: $progress, category: $category, isCompleted: $isCompleted)';
  }

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    int? progress,
    String? category,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'priority': priority,
      'progress': progress,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      priority: map['priority'] as int,
      progress: map['progress'] as int,
      category: map['category'] != null ? map['category'] as String : null,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskEntity.fromJson(String source) => TaskEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant TaskEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.dueDate == dueDate &&
      other.priority == priority &&
      other.progress == progress &&
      other.category == category &&
      other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      progress.hashCode ^
      category.hashCode ^
      isCompleted.hashCode;
  }
}
