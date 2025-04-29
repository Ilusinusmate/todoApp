import 'package:isar/isar.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';

part 'task_model.g.dart';


@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late DateTime dueDate;
  late int priority;
  late int progress;
  String? category;
  bool isCompleted = false;


  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.progress,
    this.category,
    this.isCompleted = false,
  });

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      progress: progress,
      category: category,
      isCompleted: isCompleted,
    );
  }

  TaskModel.fromEntity(TaskEntity task)
    : id = task.id ?? Isar.autoIncrement,
      title = task.title,
      description = task.description,
      dueDate = task.dueDate,
      priority = task.priority,
      progress = task.progress,
      category = task.category,
      isCompleted = task.isCompleted;

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, progress: $progress, category: $category, isCompleted: $isCompleted)';
  }
}
