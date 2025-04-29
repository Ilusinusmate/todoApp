import 'package:confetti/confetti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';
import 'package:todoapp/features/todo_list/presentation/bloc/task_cubit.dart';
import 'package:todoapp/features/todo_list/presentation/widgets/components/task_component.dart';


class TodoListView extends StatelessWidget {
  TodoListView({super.key});

  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, List<TaskEntity>>(
      builder: (context, tasksList) {
        // debugPrint('Tasks List: $tasksList');

        if (tasksList.isEmpty) {
          return const Center(
            child: Text(
              'Create your first task',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return Stack(
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              colors: [Theme.of(context).primaryColor, Colors.green],
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              gravity: 0.3,
              shouldLoop: false,
            ),
            ListView.builder(
              key: ValueKey(tasksList), // Force rebuild when tasksList changes
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                return TaskComponent(
                  task: tasksList[index],
                  index: index,
                  confettiController: _confettiController,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
