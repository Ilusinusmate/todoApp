import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/core/service_locator/service_locator.dart';
import 'package:todoapp/features/todo_list/data/models/task_model.dart';


Future<void> initIsar() async {
  // Initialize Isar database
  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([TaskModelSchema], directory: directory.path);
  // Register Isar instance with service locator
  getIt.registerSingleton<Isar>(isar);
}
