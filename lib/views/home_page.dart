import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';

import 'widgets/add_task_button.dart';

class HomePage extends StatelessWidget {
  final HiveController controller = Get.put(HiveController());
  final columnNameTxtCtrl = TextEditingController();
  final taskNameCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();

  List<DragAndDropList> setContents(
      BuildContext context, List<ColumnModel>? columns) {
    return columns!
        .map(
          (col) => DragAndDropList(
              header: buildHeader(context, col),
              footer: Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: AddTaskButton(
                      col: col,
                      taskNameCtrl: taskNameCtrl,
                      taskDescCtrl: taskDescCtrl,
                      controller: controller),
                ),
              ),
              children: buildItems(col),
              contentsWhenEmpty: Container()),
        )
        .toList();
  }

  Widget buildHeader(BuildContext context, ColumnModel e) {
    return Card(
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: GestureDetector(
          onDoubleTap: () => Get.defaultDialog(),
          child: Text(
            e.columnName,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  List<DragAndDropItem> buildItems(ColumnModel column) {
    return column.tasks.map((task) {
      final taskName = task.taskName;
      return DragAndDropItem(
          child: GestureDetector(
        onDoubleTap: () {
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
      // resizeToAvoidBottomInset: false,ta
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
            listDragHandle: DragHandle(
              verticalAlignment: DragHandleVerticalAlignment.top,
              child: Container(
                  margin: const EdgeInsets.only(right: 16.0, top: 20),
                  child: const Icon(Icons.drag_handle)),
            ),
            itemDragHandle: DragHandle(
              // verticalAlignment: DragHandleVerticalAlignment.center,
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: const Icon(Icons.drag_handle),
              ),
            ),
            contentsWhenEmpty:
                const Text('Column is empty, click + to add column'),
            // lastItemTargetHeight: 5,
            itemGhost: const Card(
                child: ListTile(
              title: Text('Drag here'),
            )),
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
