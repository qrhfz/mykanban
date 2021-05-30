import 'package:hive/hive.dart';
import 'package:mykanban/models/task_model.dart';

part 'column_model.g.dart';

@HiveType(typeId: 1)
class ColumnModel {
  @HiveField(0)
  final String columnName;
  @HiveField(1)
  final List<TaskModel>? tasks;

  ColumnModel(
    this.columnName, {
    this.tasks,
  });
}
