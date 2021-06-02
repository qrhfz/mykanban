import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({
    Key? key,
    required this.taskNameCtrl,
    required this.controller,
    required this.col,
    required this.taskDescCtrl,
  }) : super(key: key);

  final TextEditingController taskNameCtrl;
  final TextEditingController taskDescCtrl;
  final HiveController controller;
  final ColumnModel col;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        taskNameCtrl.text = '';
        taskDescCtrl.text = '';
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
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
                      child: ElevatedButton.icon(
                          onPressed: () {
                            controller.addTask(col.columnName,
                                taskNameCtrl.text, taskDescCtrl.text);
                            Get.back();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('add')),
                    )
                  ],
                ),
              );
            });
      },
      icon: const Icon(Icons.add_circle),
    );
  }
}
