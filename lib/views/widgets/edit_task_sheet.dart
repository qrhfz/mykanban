import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';

class EditTaskSheet extends StatelessWidget {
  const EditTaskSheet({
    Key? key,
    required this.taskNameCtrl,
    required this.controller,
    required this.col,
    required this.taskDescCtrl,
    required this.index,
  }) : super(key: key);

  final TextEditingController taskNameCtrl;
  final TextEditingController taskDescCtrl;
  final HiveController controller;
  final ColumnModel col;
  final int index;

  @override
  Widget build(BuildContext context) {
    final oldName = taskNameCtrl.text;
    log(oldName);
    return Padding(
      padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: taskNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: taskDescCtrl,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      await controller.updateTask(
                          oldTaskName: oldName,
                          newTaskName: taskNameCtrl.text,
                          columnName: col.columnName,
                          newDesc: taskDescCtrl.text);
                      Get.back();
                    },
                    icon: const Icon(Icons.update),
                    label: const Text('Update')),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      controller.deleteTask(col.columnName, index);
                      Get.back();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
