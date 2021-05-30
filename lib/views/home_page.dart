import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:mykanban/models/column_model.dart';
import 'package:mykanban/models/task_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ColumnModel>? columns = [
    ColumnModel('ready', [
      TaskModel(taskName: 'task1'),
      TaskModel(taskName: 'task2'),
      TaskModel(taskName: 'task3'),
    ]),
    ColumnModel('on progress', [
      TaskModel(taskName: 'task4'),
      TaskModel(taskName: 'task5'),
    ]),
  ];

  late List<DragAndDropList> _contents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setContents(BuildContext context) {
    _contents = columns!
        .map(
          (e) => DragAndDropList(
            header: Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Text(
                e.columnName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            children: e.tasks!
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
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    setContents(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kanban'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DragAndDropLists(
          children: _contents,
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
        ),
      ),
    );
  }

  void _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      // var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      // _contents[newListIndex].children.insert(newItemIndex, movedItem);
      var movedItem = columns![oldListIndex].tasks!.removeAt(oldItemIndex);
      columns![newListIndex].tasks!.insert(newItemIndex, movedItem);
      setContents(context);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = columns!.removeAt(oldListIndex);
      columns!.insert(newListIndex, movedList);
      setContents(context);
    });
  }
}
