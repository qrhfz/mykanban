import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';
import 'package:mykanban/views/widgets/edit_task_sheet.dart';

import 'widgets/add_task_button.dart';

class HomePage extends StatelessWidget {
  final HiveController controller = Get.put(HiveController());
  final columnNameTxtCtrl = TextEditingController();
  final taskNameCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              children: buildItems(col, context),
              contentsWhenEmpty: Container()),
        )
        .toList();
  }

  Widget buildHeader(BuildContext context, ColumnModel col) {
    return Card(
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: GestureDetector(
          onDoubleTap: () {
            columnNameTxtCtrl.text = col.columnName;
            Get.defaultDialog(
                title: 'Edit',
                content: TextField(
                  controller: columnNameTxtCtrl,
                ),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.updateColumn(
                          col.columnName, columnNameTxtCtrl.text);
                      Get.back();
                    },
                    icon: const Icon(Icons.update),
                    label: const Text('Update'),
                  ),
                  IconButton(
                    // style: ButtonStyle(),
                    onPressed: () async {
                      await Get.defaultDialog(
                        title: 'Delete Task',
                        middleText:
                            'Are you sure to delete column "${col.columnName}"? This can\'t be undone',
                        confirm: ElevatedButton.icon(
                          onPressed: () {
                            controller.deleteColumn(col.columnName);
                            Get.back();
                          },
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('DELETE'),
                          style:
                              TextButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      );
                      // controller.deleteColumn(col.columnName);
                      Get.back();
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ]);
          },
          child: Text(
            col.columnName,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  List<DragAndDropItem> buildItems(ColumnModel column, BuildContext context) {
    return column.tasks.map((task) {
      final taskName = task.taskName;
      final taskDesc = task.description;
      return DragAndDropItem(
          child: GestureDetector(
        onDoubleTap: () {
          taskNameCtrl.text = taskName;
          taskDescCtrl.text = taskDesc ?? '';
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => EditTaskSheet(
                  taskNameCtrl: taskNameCtrl,
                  controller: controller,
                  col: column,
                  taskDescCtrl: taskDescCtrl));
        },
        child: Card(child: ListTile(title: Text(task.taskName))),
      ));
    }).toList();
  }
}
