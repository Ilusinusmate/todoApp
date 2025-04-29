import 'package:flutter/material.dart';
import 'package:todoapp/common/data/data_source/shared_preferences.dart';
import 'package:todoapp/common/data/notifiers/theme_notifier.dart';

class TaskListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Todo List'),
      centerTitle: true,
      actions: [
        ValueListenableBuilder(
          valueListenable: themeNotifier,
          builder:
              (context, value, child) => IconButton(
                icon:
                    value == ThemeMode.light
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode),

                onPressed:
                    value == ThemeMode.light
                        ? () {
                          ThemePreferences.setThemeMode(ThemeMode.dark);
                        }
                        : () {
                          ThemePreferences.setThemeMode(ThemeMode.light);
                        },
              ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 50);
}
