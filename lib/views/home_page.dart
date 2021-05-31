import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mykanban/controllers/hive_controller.dart';
import 'package:mykanban/models/column_model.dart';

class HomePage extends StatelessWidget {
  final HiveController controller = Get.put(HiveController());
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

  List<DragAndDropItem> buildItems(ColumnModel e) {
    return e.tasks
        .map(
          (e) => DragAndDropItem(
              child: Card(
            shape: const RoundedRectangleBorder(),
            margin: const EdgeInsets.only(
              bottom: 0.5,
            ),
            child: ListTile(title: Text(e.taskName)),
          )),
        )
        .toList();
  }

  final taskNameCtrl = TextEditingController();

  Container buildHeader(BuildContext context, ColumnModel column) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            column.columnName,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () => Get.defaultDialog(
                title: column.columnName,
                content: Column(
                  children: [
                    TextField(
                      controller: taskNameCtrl,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          controller.addTask(
                              column.columnName, taskNameCtrl.text);
                          Get.back();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('add'))
                  ],
                )),
            icon: const Icon(Icons.add_circle),
            iconSize: 18,
          )
        ],
      ),
    );
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
    );
  }
}
