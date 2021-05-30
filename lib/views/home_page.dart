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
            header: ListTile(
              tileColor: Theme.of(context).primaryColor,
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
              title: Text(
                e.columnName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            children: (e.tasks != null)
                ? e.tasks!
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
                    .toList()
                : [],
          ),
        )
        .toList();
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
