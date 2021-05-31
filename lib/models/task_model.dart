import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
class TaskModel {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  String? description;

  TaskModel({required this.taskName, this.description});
}
