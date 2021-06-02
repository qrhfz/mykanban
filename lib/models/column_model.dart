import 'package:hive/hive.dart';
import 'package:mykanban/models/task_model.dart';

part 'column_model.g.dart';

@HiveType(typeId: 1)
class ColumnModel {
  @HiveField(0)
  String columnName;
  @HiveField(1)
  List<TaskModel> tasks;

  ColumnModel(
    this.columnName, {
    required this.tasks,
  });
}
