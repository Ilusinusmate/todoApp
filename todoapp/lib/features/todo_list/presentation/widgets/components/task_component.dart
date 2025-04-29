import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:todoapp/common/presentation/sounds.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';
import 'package:todoapp/features/todo_list/presentation/bloc/task_cubit.dart';
import 'package:todoapp/features/todo_list/presentation/widgets/confirm_delete_dialog.dart';

class TaskComponent extends StatelessWidget {
  final TaskEntity task;
  final int index;
  final ConfettiController confettiController;

  const TaskComponent({
    super.key,
    required this.task,
    required this.index,
    required this.confettiController,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return GestureDetector(
      onDoubleTap: () => _onDoubleTap(context, index, confettiController),
      child: Dismissible(
        key: ValueKey(task.id),
        onDismissed:
            (direction) => _onDismissed(context, direction, task, index),
        background: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.arrow_upward, color: Colors.green),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.arrow_downward, color: Colors.indigo),
              ),
            ),
          ],
        ),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  isCompleted ? Colors.green : Theme.of(context).primaryColor,
              child:
                  !isCompleted
                      ? Text(
                        "${task.priority}",
                        style: const TextStyle(color: Colors.white),
                      )
                      : const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: SizedBox(
              height: 10,
              width: 50,
              child: LinearProgressIndicator(
                value: task.progress / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : Colors.blue,
                ),
              ),
            ),
            onTap: () => _onTap(context, index, confettiController),
            onLongPress: () async => await _onLongPress(context, index),
          ),
        ),
      ),
    );
  }
}

void rewardUser(int progress, ConfettiController confettiController) async {
  if (progress == 100) {
    confettiController.play();
  }
  if (progress > 0) {
    Sounds.successSound();
  }
}

Future<void> _onLongPress(BuildContext context, int index) async {
  final taskCubit = context.read<TaskCubit>();
  final confirmed = await showDialog(
    context: context,
    builder: (context) => ConfirmDeleteDialog(),
  );
  if (confirmed == true) {
    taskCubit.deleteTask(index);
  }
}

void _onTap(
  BuildContext context,
  int index,
  ConfettiController confettiController,
) async {
  final taskCubit = context.read<TaskCubit>();
  final newProgress = await taskCubit.cicleProgress(index);
  rewardUser(newProgress, confettiController);
}

void _onDoubleTap(
  BuildContext context,
  int index,
  ConfettiController confettiController,
) async {
  final taskCubit = context.read<TaskCubit>();
  final newProgres = await taskCubit.reverseCompleted(index);
  rewardUser(newProgres, confettiController);
}

void _onDismissed(
  BuildContext context,
  DismissDirection direction,
  TaskEntity task,
  int index,
) async {
  final taskCubit = context.read<TaskCubit>();
  final removedTask = task;
  taskCubit.disposeTask(index);

  await Future.delayed(Duration(milliseconds: 50));

  if (direction == DismissDirection.startToEnd) {
    taskCubit.increasePriorityById(removedTask.id!);
  } else if (direction == DismissDirection.endToStart) {
    taskCubit.decreasePriorityById(removedTask.id!);
  }
}
