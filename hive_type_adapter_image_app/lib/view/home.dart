import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_typr_adapter_image_app/view/insert.dart';
import 'package:hive_typr_adapter_image_app/view/update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box addressbox = Hive.box('address');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주소록'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => Insert()),
            icon: Icon(Icons.add_outlined),
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: addressbox.listenable(),
        builder:
            (context, Box addressbox, widget) =>
                addressbox.isEmpty
                    ? Center(child: Text('Empty'))
                    : ListView.builder(
                      itemCount: addressbox.length,
                      itemBuilder: (context, index) {
                        var addressData = addressbox.getAt(index);
                        return GestureDetector(
                          onTap:
                              () => Get.to(
                                () => Update(),
                                arguments: [
                                  index,
                                  addressData.name,
                                  addressData.phone,
                                  addressData.address,
                                  addressData.relation,
                                  addressData.image,
                                ],
                              ),
                          child: Slidable(
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
                            child: Card(
                              child: Row(
                                children: [
                                  Image.memory(addressData.image, width: 100),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('이름 : ${addressData.name}'),
                                      Text('전화번호 : ${addressData.phone}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      ),
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
                  addressbox.deleteAt(index);
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
