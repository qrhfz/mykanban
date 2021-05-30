import 'package:mykanban/models/task_model.dart';

class ColumnModel {
  final String columnName;
  final List<TaskModel>? tasks;

  ColumnModel(
    this.columnName,
    this.tasks,
  );
}
