import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mykanban/models/column_model.dart';
import 'package:mykanban/models/task_model.dart';

import '../string_const.dart';

class HiveController extends GetxController {
  RxList<ColumnModel> columns = RxList<ColumnModel>.empty();
  final box = Hive.box<ColumnModel>(boxName);
  @override
  Future onInit() async {
    super.onInit();
    fetchKanban();
  }

  void fetchKanban() {
    columns.removeWhere((element) => true);

    var i = 0;

    while (i < box.length) {
      // print('$i = ${box.getAt(i)!.columnName}');
      columns.add(box.getAt(i)!);
      i++;
    }

    columns.refresh();
  }

  @override
  Future onClose() async {
    await box.close();

    super.onClose();
  }

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    log('oi: $oldItemIndex, ol: $oldListIndex, ni: $newItemIndex, nl: $newListIndex');

    final oldColumn = columns[oldListIndex];
    final newColumn = columns[newListIndex];

    if (oldItemIndex < oldColumn.tasks.length) {
      final movedTask = oldColumn.tasks.removeAt(oldItemIndex);
      newColumn.tasks.insert(newItemIndex, movedTask);
    } else {
      Get.snackbar('Error', 'Sorry');
      fetchKanban();
    }

    columns.refresh();
    syncHive();
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    final movedList = columns.removeAt(oldListIndex);
    columns.insert(newListIndex, movedList);

    syncHive();
    // columns.refresh();
  }

  Future syncHive() async {
    for (var i = 0; i < columns.length; i++) {
      await box.put(i, columns[i]);
      //print('res : ${box.getAt(i)!.tasks[0].taskName}');
    }
    fetchKanban();
  }

  Future addColumn(String columnName) async {
    columns.add(ColumnModel(columnName, tasks: RxList.empty()));

    await syncHive();
  }

  Future<void> addTask(String columnName, String taskName) async {
    for (final col in columns) {
      if (col.columnName == columnName) {
        // print('add task : ${e.columnName}');

        col.tasks.add(TaskModel(taskName: taskName));
      }
    }

    columns.refresh();
    await syncHive();
  }

  Future<void> updateTask(
      String columnName, String oldTaskName, String newTaskName) async {
    for (final col in columns) {
      if (col.columnName == columnName) {
        // print('add task : ${e.columnName}');

        for (final task in col.tasks) {
          if (task.taskName == oldTaskName) {
            task.taskName = newTaskName;
          }
        }
      }
    }

    columns.refresh();
    await syncHive();
  }

  Future<void> deleteTask(String columnName, String taskName) async {
    for (final col in columns) {
      if (col.columnName == columnName) {
        // print('add task : ${e.columnName}');

        col.tasks.removeWhere((task) => task.taskName == taskName);
      }
    }

    columns.refresh();
    await syncHive();
  }
}

// String getRandString(int len) {
//   final random = Random.secure();
//   final values = List<int>.generate(len, (i) => random.nextInt(255));
//   return base64UrlEncode(values);
// }
