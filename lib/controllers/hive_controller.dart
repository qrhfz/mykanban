import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mykanban/models/column_model.dart';

import '../string_const.dart';

class HiveController extends GetxController {
  RxList<ColumnModel> columns = RxList<ColumnModel>();
  final box = Hive.box<ColumnModel>(boxName);
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchKanban();
  }

  Future fetchKanban() async {
    columns = RxList<ColumnModel>();
    if (box.isEmpty) {
      await addColumn('ready');
      await addColumn('on progress');
      await addColumn('done');
      await fetchKanban();
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
    final movedItem = columns[oldListIndex].tasks!.removeAt(oldItemIndex);
    columns[newListIndex].tasks!.insert(newItemIndex, movedItem);
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    final movedList = columns.removeAt(oldListIndex);
    columns.insert(newListIndex, movedList);

    for (var i = 0; i < box.length; i++) {
      // print('$i <- ${columns[i].columnName}');
      box.putAt(i, columns[i]);
      // print('res : ${box.getAt(i)!.columnName}');
    }
  }

  Future addColumn(String columnName) async {
    await box.add(ColumnModel(columnName));
  }
}

String getRandString(int len) {
  final random = Random.secure();
  final values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
