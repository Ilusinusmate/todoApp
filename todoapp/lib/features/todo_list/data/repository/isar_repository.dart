import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todoapp/core/service_locator/service_locator.dart';
import 'package:todoapp/features/todo_list/data/models/task_model.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';
import 'package:todoapp/features/todo_list/domain/repository/task_repository.dart';

class IsarTaskRepository implements TaskRepository {
  final Isar _isar = getIt<Isar>();

  IsarTaskRepository();

  Future<TaskModel?> _getTaskModelById(int id) async {
    return await _isar.collection<TaskModel>().get(id);
  }

  @override
  Future<TaskEntity?> getTaskById(int id) async {
    var task = await _getTaskModelById(id);
    return task?.toEntity();
  }

  @override
  Future<List<TaskEntity>> getTasks() {
    return _isar.collection<TaskModel>().where().findAll().then((tasks) {
      return tasks.map((task) => task.toEntity()).toList();
    });
  }

  @override
  Future<TaskEntity?> addTask(TaskEntity task) async {
    try {
      _isar.writeTxn(() async {
        await _isar.collection<TaskModel>().put(TaskModel.fromEntity(task));
      });
      return task;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return null;
    }
  }

  @override
  Future<void> completeTask(int taskId) async {
    _getTaskModelById(taskId).then((task) {
      if (task == null) return;
      task.isCompleted = true;
      _isar.writeTxn(() async {
        await _isar.collection<TaskModel>().put(task);
      });
    });
  }

  @override
  Future<bool> deleteTask(int taskId) async {
    _getTaskModelById(taskId).then((task) {
      if (task == null) return false;
      _isar.writeTxn(() async {
        await _isar.collection<TaskModel>().delete(taskId);
      });
    });
    return true;
  }

  @override
  Future<void> uncompleteTask(int taskId) async {
    _getTaskModelById(taskId).then((task) {
      if (task == null) return;
      task.isCompleted = false;
      _isar.writeTxn(() async {
        await _isar.collection<TaskModel>().put(task);
      });
    });
  }

  @override
  Future<bool> updateTask(int taskId, TaskEntity newTask) async {
    _getTaskModelById(taskId).then((task) async {
      if (newTask.id != taskId) {
        debugPrint('Task ID mismatch');
        return false;
      }
      if (task == null) return false;
      await addTask(newTask);
    });
    return true;
  }
}
