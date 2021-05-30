import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mykanban/models/column_model.dart';

import '../string_const.dart';

class HiveController extends GetxController {
  late final List<ColumnModel>? columns;
  final box = Hive.box(boxName);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var initColumn = box.get('ready', defaultValue: ColumnModel('ready', []));
    columns = [...initColumn];
  }

  @override
  Future onClose() async {
    await box.close();

    super.onClose();
  }
}
