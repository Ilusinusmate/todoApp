import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:todoapp/features/todo_list/presentation/widgets/task_form_bloc.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<TaskFormBloc>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Task'),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
            ),

            body: FormBlocListener<TaskFormBloc, String, String>(
              onSuccess: (context, state) {
                floatingSnackBar(
                  message: state.successResponse!,
                  context: context,
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.green,
                );
                Navigator.pushReplacementNamed(context, "/home");
              },
              onFailure: (context, state) {
                floatingSnackBar(
                  message: state.failureResponse ?? 'Failure',
                  context: context,
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.red,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.title,
                          decoration: InputDecoration(labelText: 'Task Name'),
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.description,
                          decoration: InputDecoration(
                            labelText: 'Task description',
                          ),
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        DropdownFieldBlocBuilder<int>(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          selectFieldBloc: formBloc.priority,
                          decoration: InputDecoration(
                            labelText: 'Priority (1-10)',
                          ),
                          itemBuilder:
                              (context, value) =>
                                  FieldItem(child: Text(value.toString())),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: formBloc.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32,
                            ),
                          ),
                          child: Text(
                            'Create Task',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
