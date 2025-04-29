import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';
import 'package:todoapp/features/todo_list/domain/repository/task_repository.dart';

class TaskCubit extends Cubit<List<TaskEntity>> {
  final TaskRepository _repo;

  TaskCubit(this._repo) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    final tasks = await _repo.getTasks();
    _emit(tasks);
  }

  void _emit(List<TaskEntity> tasks) {
    final sortedList = List<TaskEntity>.from(tasks)..sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      if (a.isCompleted && b.isCompleted) {
        return b.dueDate.compareTo(a.dueDate);
      }

      return b.priority.compareTo(a.priority);
    });

    debugPrint('Sorted List: $sortedList');
    emit(sortedList);
  }

  Future<void> loadTasks() async {
    final tasks = await _repo.getTasks();
    _emit(tasks);
  }

  Future<void> addTask(TaskEntity task) async {
    final newTask = await _repo.addTask(task);
    if (newTask != null) {
      final updatedTasks = [...state, newTask];
      _emit(updatedTasks);
    } else {
      await loadTasks(); // Fallback em caso de falha
    }
  }

  Future<void> deleteTask(int index) async {
    final id = state[index].id!;
    final success = await _repo.deleteTask(id);

    if (success) {
      final updatedTasks = [...state];
      updatedTasks.removeAt(index);
      _emit(updatedTasks);
    } else {
      await loadTasks(); // Fallback em caso de falha
    }
  }

  Future<void> updateTaskInState(int index, TaskEntity updatedTask) async {
    final id = state[index].id!;
    final success = await _repo.updateTask(id, updatedTask);

    if (success) {
      final updatedTasks = [...state];
      updatedTasks[index] = updatedTask;
      _emit(updatedTasks);
    } else {
      await loadTasks(); // Fallback em caso de falha
    }
  }

  Future<void> increasePriority(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(priority: task.priority + 1);
    await updateTaskInState(index, updatedTask);
  }

  Future<void> increasePriorityById(int id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      await increasePriority(taskIndex);
    } else {
      // Apenas se a tarefa não estiver no estado atual
      final task = await _repo.getTaskById(id);
      if (task == null) return;

      await _repo.updateTask(
        task.id!,
        task.copyWith(priority: task.priority + 1),
      );
      await loadTasks();
    }
  }

  Future<void> decreasePriorityById(int id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      await decreasePriority(taskIndex);
    } else {
      // Apenas se a tarefa não estiver no estado atual
      final task = await _repo.getTaskById(id);
      if (task == null) return;

      await _repo.updateTask(
        task.id!,
        task.copyWith(priority: task.priority - 1),
      );
      await loadTasks();
    }
  }

  Future<void> decreasePriority(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(priority: task.priority - 1);
    await updateTaskInState(index, updatedTask);
  }

  Future<int> reverseCompleted(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      progress: task.isCompleted ? 0 : 100,
    );
    await updateTaskInState(index, updatedTask);
    return updatedTask.progress;
  }

  Future<void> setAsCompleted(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(isCompleted: true, progress: 100);
    await updateTaskInState(index, updatedTask);
  }

  Future<void> setAsUncompleted(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(isCompleted: false, progress: 0);
    await updateTaskInState(index, updatedTask);
  }

  Future<int> cicleProgress(int index) async {
    final task = state[index];
    final newProgress = (task.progress + 20) % 120;
    final updatedTask = task.copyWith(
      progress: newProgress > 100 ? 0 : newProgress,
      isCompleted: newProgress == 100,
    );
    await updateTaskInState(index, updatedTask);
    return newProgress;
  }

  void disposeTask(int index) {
    final newState = List<TaskEntity>.from(state)..removeAt(index);
    _emit(newState);
  }

  @override
  void onChange(Change<List<TaskEntity>> change) {
    super.onChange(change);
    debugPrint(
      "-------------------------------------------------------------------",
    );
    debugPrint("onChange - Current state: ${change.currentState}");
    debugPrint("onChange - Next state: ${change.nextState}");
    debugPrint("MUDANÇA DE ESTADO: ${change.currentState != change.nextState}");
  }
}
