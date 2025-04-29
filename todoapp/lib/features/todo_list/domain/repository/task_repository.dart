import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';

abstract class TaskRepository {
  // This is a placeholder for the actual implementation of the TaskRepository.
  // In a real application, this would interact with a database or an API to manage tasks.
  Future<List<TaskEntity>> getTasks();

  Future<TaskEntity?> getTaskById(int taskId);

  Future<TaskEntity?> addTask(TaskEntity task);

  Future<bool> updateTask(int taskId, TaskEntity newTask);

  Future<bool> deleteTask(int taskId);

  Future<void> completeTask(int taskId);

  Future<void> uncompleteTask(int taskId);
}
