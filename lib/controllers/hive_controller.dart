import 'dart:convert';
import 'dart:math';
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
    // TODO: implement onInit
    super.onInit();
    await fetchKanban();
  }

  Future fetchKanban() async {
    columns = RxList<ColumnModel>.empty();
    if (box.isEmpty) {
      addColumn('ready');
      addColumn('on progress');
      addColumn('done');
    } else {
      // box.deleteAt(0);
      // box.deleteAt(0);
      // box.deleteAt(0);
      var i = 0;

      while (i < box.length) {
        // print('$i = ${box.getAt(i)!.columnName}');
        columns.add(box.getAt(i)!);
        i++;
      }
    }
  }

  @override
  Future onClose() async {
    await box.close();

    super.onClose();
  }

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    // var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
    // _contents[newListIndex].children.insert(newItemIndex, movedItem);
    final movedItem = columns[oldListIndex].tasks.removeAt(oldItemIndex);
    columns[newListIndex].tasks.insert(newItemIndex, movedItem);
    columns.refresh();
    syncHive();
  }

  Future onListReorder(int oldListIndex, int newListIndex) async {
    final movedList = columns.removeAt(oldListIndex);
    columns.insert(newListIndex, movedList);

    await syncHive();
  }

  Future syncHive() async {
    for (var i = 0; i < columns.length; i++) {
      await box.put(i, columns[i]);
      //print('res : ${box.getAt(i)!.tasks[0].taskName}');
    }
    await fetchKanban();
  }

  Future addColumn(String columnName) async {
    columns.add(ColumnModel(columnName, tasks: RxList.empty()));

    await syncHive();
  }

  Future<void> addTask(String columnName, String taskName) async {
    for (var col in columns) {
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
    for (var col in columns) {
      if (col.columnName == columnName) {
        // print('add task : ${e.columnName}');

        for (var task in col.tasks) {
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
    for (var col in columns) {
      if (col.columnName == columnName) {
        // print('add task : ${e.columnName}');

        col.tasks.removeWhere((task) => task.taskName == taskName);
      }
    }

    columns.refresh();
    await syncHive();
  }
}

String getRandString(int len) {
  final random = Random.secure();
  final values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
