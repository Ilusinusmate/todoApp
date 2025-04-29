import 'package:flutter/material.dart';

class AddTaskBtn extends StatelessWidget {
  const AddTaskBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/add-task');
      },
      backgroundColor: Theme.of(context).primaryColor,
      shape: CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
