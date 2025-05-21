import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_typr_adapter_image_app/model/address.dart';
import 'package:image_picker/image_picker.dart';
class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController nameController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  TextEditingController addressController =TextEditingController();
  TextEditingController relationController =TextEditingController();

  Box addressBox = Hive.box("address");
  int firstDisp = 0;
  var value = Get.arguments ?? "__";
  late int index;


  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    index = value[0];
    nameController.text = value[1];
    phoneController.text = value[2];
    addressController.text = value[3];
    relationController.text = value[4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("주소록 수정"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(nameController, "이름을 수정하세요"),
            _buildTextField(phoneController, "번호를 수정하세요"),
            _buildTextField(addressController, "주소를 수정하세요"),
            _buildTextField(relationController, "관계를 수정하세요"),

            ElevatedButton(
              onPressed: () => getImageFromGallery(ImageSource.gallery ), 
              child: Text("Gallery")
            ),
            firstDisp == 0
            ? Container(
                height: 200,
                color: Colors.grey,
                child: Center(
                  child: Image.memory(value[5]),
              ),
            )
            :Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
              child:  Center(
                child: imageFile == null
                ? Text("Image is not seleted!")
                :Image.file(File(imageFile!.path)),
              ),
            ),


            ElevatedButton(
              onPressed: () {
                _updateAction();
                _showDialog();
              }, 
              child: Text("수정")
            ),
          ],
        ),
      ),
    );
  }//build

  // --- Widget---
  Widget _buildTextField(TextEditingController controller, String labelText){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        keyboardType: TextInputType.text,
      ),
    );
  }



  getImageFromGallery(ImageSource imageSource)async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    firstDisp += 1;
    setState(() {});
  }


  _updateAction()async{
    Address address;

    if(firstDisp == 0){
      address = Address(
        name: nameController.text.trim(), 
        phone: phoneController.text.trim(), 
        address: addressController.text.trim(), 
        relation: relationController.text.trim(), 
        image: value[5]
      );
    }


    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    address =Address(
      name: nameController.text.trim(), 
      phone: phoneController.text.trim(), 
      address: addressController.text.trim(), 
      relation: relationController.text.trim(), 
      image: getImage
      );

      addressBox.put(index, address);
  }

  _showDialog(){
    Get.defaultDialog(
      title: "수정 결과",
      middleText: "수정 완료",
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: Text("확인"))
      ]
    );
  }
}//class