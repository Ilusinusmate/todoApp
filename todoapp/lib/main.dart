import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:todoapp/common/data/data_source/shared_preferences.dart';
import 'package:todoapp/common/data/notifiers/theme_notifier.dart';
import 'package:todoapp/common/presentation/theme.dart';
import 'package:todoapp/core/database/init.dart';
import 'package:todoapp/features/todo_list/presentation/pages/add_task_page.dart';
import 'package:todoapp/features/todo_list/presentation/pages/splash_page.dart';
import 'package:todoapp/features/todo_list/presentation/pages/todo_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("WIDGETS BINDING INITIALIZED");
  JustAudioMediaKit.ensureInitialized(
    android: true,
    windows: true,
    linux: true,
  );
  debugPrint("JUST AUDIO MEDIA KIT INITIALIZED");
  await ThemePreferences.init();
  debugPrint("THEME PREFERENCES INITIALIZED");
  await initIsar();
  debugPrint("ISAR INITIALIZED");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder:
          (context, theme, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            home: const SplashPage(),


            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: theme,

            routes: {
              '/init': (context) => const SplashPage(),
              '/home': (context) => TodoListPage(),
              '/add-task': (context) => const AddTaskPage(),
            },
          ),
    );
  }
}
