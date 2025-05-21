import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_list_app/model/to_do.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  Box toDobox = Hive.box('to_do');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Lists'),
        centerTitle: F,
        actions: [
          IconButton(
            onPressed: () => addDialog(),
            icon: Icon(Icons.add_outlined),
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: toDobox.listenable(),
        builder:
            (context, Box toDobox, widget) =>
                toDobox.isEmpty
                    ? Center(child: Text('Empty'))
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: toDobox.length,
                        itemBuilder: (context, index) {
                          var toDoData = toDobox.getAt(index);
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: BehindMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: '삭제',
                                  onPressed: (context) => selectDelete(index),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => updateToDo(index),
                              child: SizedBox(
                                height: 70,
                                child: Card(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Icon(Icons.today),
                                      ),
                                      Text(toDoData.contents),
                                      Text(' / '),
                                      Text(toDoData.date),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      ),
    );
  }

  updateToDo(int index) {
    textEditingController.text = toDobox.getAt(index).contents;
    Get.defaultDialog(
      title: '수정',
      middleText: '',
      actions: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: '추가할 내용'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            var value = ToDo(
              contents: textEditingController.text,
              date: DateTime.now().toString().substring(0, 10),
            );
            toDobox.putAt(index, value);
            Get.back();
          },
          child: Text('추가'),
        ),
      ],
    );
  }

  addDialog() {
    textEditingController.text = '';
    Get.defaultDialog(
      title: 'Todo List',
      middleText: '',
      actions: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: '추가할 내용'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            var value = ToDo(
              contents: textEditingController.text,
              date: DateTime.now().toString().substring(0, 10),
            );
            toDobox.add(value);
            Get.back();
          },
          child: Text('추가'),
        ),
      ],
    );
  }

  selectDelete(int index) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: Text('경고'),
            message: Text('선택한 항목을 삭제 하시겠습니까?'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  toDobox.deleteAt(index);
                  Get.back();
                },
                child: Text('삭제'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Get.back(),
              child: Text('취소'),
            ),
          ),
    );
  }
}
