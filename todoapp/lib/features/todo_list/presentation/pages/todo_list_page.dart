import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/features/todo_list/data/repository/isar_repository.dart';
import 'package:todoapp/features/todo_list/domain/repository/task_repository.dart';
import 'package:todoapp/features/todo_list/presentation/bloc/task_cubit.dart';
import 'package:todoapp/features/todo_list/presentation/pages/todo_list_view.dart';
import 'package:todoapp/features/todo_list/presentation/widgets/add_task_btn.dart';
import 'package:todoapp/features/todo_list/presentation/widgets/task_list_app_bar.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});

  final TaskRepository repo = IsarTaskRepository();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: AddTaskBtn(),

      appBar: TaskListAppBar(),

      body: BlocProvider(
        create: (_) => TaskCubit(repo),
        child: TodoListView(),
      ),
    );
  }
}
