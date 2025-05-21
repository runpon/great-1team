import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_typr_adapter_image_app/model/address.dart';
import 'package:image_picker/image_picker.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  Box addressBox = Hive.box('address');

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주소록 입력'),
      ),

      body: Center(
        child: Column(
          children: [
            _buildTextField(nameController, '이름을 입력하세요'),
            _buildTextField(phoneController, '전화번호를 입력하세요'),
            _buildTextField(addressController, '주소를 입력하세요'),
            _buildTextField(relationController, '관계를 입력하세요'),

            ElevatedButton(onPressed: () => getImageFromGallery(ImageSource.gallery), child: Text('Gallry')),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
              child: Center(
                child: imageFile == null
                ? Text('Image is not selected')
                : Image.file(File(imageFile!.path)),
              ),
            ),

            ElevatedButton(onPressed: () {
              _insertAction();
              _showDialig();
            }, child: Text('입력'))
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText){
    return TextField(controller: controller, decoration: InputDecoration(labelText: labelText),
    keyboardType: TextInputType.text,);
  }

  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    setState(() {});
  }

  _insertAction()async{
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    Address address = Address(
      name: nameController.text.trim(), 
      phone: phoneController.text.trim(), 
      address: addressController.text.trim(), 
      relation: relationController.text.trim(), 
      image: getImage
      );

      addressBox.add(address);
  }

  _showDialig(){
    Get.defaultDialog(
      title: '입력결과',
      middleText: '입력이 완료 되었습니다',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: F,
      actions: [
        TextButton(onPressed: () {
          Get.back();
          Get.back();
        }, child: Text('OK')),
      ]
    );
  }
}