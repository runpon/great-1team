import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _items = [];
  final _shoppingBox = Hive.box('shopping_box');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  _refreshItems() async {
    final data =
        _shoppingBox.keys.map((key) {
          final value = _shoppingBox.get(key);
          return {
            'key': key,
            'name': value['name'],
            'quantity': value['quantity'],
          };
        }).toList();
    _items = data.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive CRUD')),

      body:
          _items.isEmpty
              ? Center(child: Text('NO Data'))
              : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final currentItem = _items[index];
                  return Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      title: Text(currentItem['name']),
                      subtitle: Text(currentItem['quantity'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                () => _showForm(context, currentItem['key']),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _deleteItem(currentItem['key']),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  _showForm(BuildContext ctx, int? itemKey) async {
    _nameController.text = '';
    _quantityController.text = '';
    if (itemKey != null) {
      final existingItem = _items.firstWhere(
        (element) => element['key'] == itemKey,
      );
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: T,
      builder:
          (context) => Container(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: MediaQuery.of(context).viewInsets.top,
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(hintText: 'Quantity'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (itemKey == null) {
                        _createItem({
                          'name': _nameController.text.trim(),
                          'quantity': _quantityController.text.trim(),
                        });
                      }
                      if (itemKey != null) {
                        _updateItem(itemKey, {
                          'name': _nameController.text.trim(),
                          'quantity': _quantityController.text.trim(),
                        });
                      }

                      Get.back();
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems();
    _snackbar();
  }

  _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems();
  }

  _updateItem(int itemkey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemkey, item);
    _refreshItems();
  }

  _snackbar() {
    Get.snackbar(
      'Message',
      '삭제되었습니다',
      duration: Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}
