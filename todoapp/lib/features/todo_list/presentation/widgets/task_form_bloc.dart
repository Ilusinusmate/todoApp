import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:todoapp/features/todo_list/data/repository/isar_repository.dart';
import 'package:todoapp/features/todo_list/domain/entities/task_entity.dart';
import 'package:todoapp/features/todo_list/presentation/bloc/task_cubit.dart';

class TaskFormBloc extends FormBloc<String, String> {
  final title = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final description = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final priority = SelectFieldBloc<int, dynamic>(
    items: List.generate(10, (index) => index + 1),
    validators: [FieldBlocValidators.required],
  );

  TaskFormBloc() {
    addFieldBlocs(fieldBlocs: [title, description, priority]);
  }

  final _repo = IsarTaskRepository();

  @override
  Future<void> onSubmitting() async {
    // Simulate some delay
    await Future.delayed(Duration(milliseconds: 500));
    await TaskCubit(_repo).addTask(
      TaskEntity(
        id: null,
        title: title.value,
        description: description.value,
        dueDate: DateTime.now(),
        priority: priority.value ?? 1,
        progress: 0,
        category: "default",
        isCompleted: false,
      ),
    );
    // Emit success with the result (you can emit task or anything else)
    emitSuccess(
      canSubmitAgain: false,
      successResponse:
          'Task "${title.value}" with priority ${priority.value} created.',
    );
  }
}
