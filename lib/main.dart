import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mykanban/models/column_model.dart';
import 'package:mykanban/models/task_model.dart';

import 'views/home_page.dart';

// ignore: avoid_void_async
void main() async {
  await Hive.initFlutter();
  await Hive.openBox('test');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Kanban',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
