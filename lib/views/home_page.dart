import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';

class HomePage extends StatelessWidget {
  final HiveController controller = Get.put(HiveController());
  final columnNameTxtCtrl = TextEditingController();
  final taskNameCtrl = TextEditingController();

  List<DragAndDropList> setContents(
      BuildContext context, List<ColumnModel>? columns) {
    return columns!
        .map(
          (e) => DragAndDropList(
            header: buildHeader(context, e),
            children: buildItems(e),
          ),
        )
        .toList();
  }

  Widget buildHeader(BuildContext context, ColumnModel e) {
    return Card(
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          e.columnName,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        trailing: IconButton(
          onPressed: () => Get.defaultDialog(
              title: e.columnName,
              content: Column(
                children: [
                  TextField(
                    controller: taskNameCtrl,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        controller.addTask(e.columnName, taskNameCtrl.text);
                        Get.back();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('add'))
                ],
              )),
          icon: const Icon(Icons.add_circle),
          iconSize: 18,
        ),
      ),
    );
  }

  List<DragAndDropItem> buildItems(ColumnModel column) {
    return column.tasks.map((task) {
      final taskName = task.taskName;
      return DragAndDropItem(
          child: GestureDetector(
        onTap: () {
          taskNameCtrl.text = taskName;
          Get.defaultDialog(
            title: 'Edit $taskName',
            content: TextField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Task Name'),
              // hintText: taskName),
              controller: taskNameCtrl,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.updateTask(
                      column.columnName, taskName, taskNameCtrl.text);
                  Get.back();
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteTask(column.columnName, taskName);
                  Get.back();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
        child: Card(child: ListTile(title: Text(task.taskName))),
      ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kanban'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => DragAndDropLists(
            children: setContents(context, controller.columns),
            onItemReorder: controller.onItemReorder,
            onListReorder: controller.onListReorder,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            content: TextField(
              controller: columnNameTxtCtrl,
              decoration: const InputDecoration(labelText: 'Column Name'),
            ),
            confirm: ElevatedButton.icon(
              onPressed: () {
                controller.addColumn(columnNameTxtCtrl.text);
                Get.back();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
