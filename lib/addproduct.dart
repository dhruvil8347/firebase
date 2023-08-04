import 'dart:io';
import 'dart:math';
import 'package:firebase_project/common/apptextfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

final TextEditingController productController = TextEditingController();
final TextEditingController driscripationController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController qtyController = TextEditingController();
int? comapanValue;
List<String> companyList = [
  "1",
  "2",
  "3",
  "4",
];


class _AddProductState extends State<AddProduct> {
  CollectionReference product =
      FirebaseFirestore.instance.collection("product");
  /*CollectionReference*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              AppTextfiled(
                controller: productController,
                title: const Text("Product Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                value: comapanValue,
                items: companyList.map((e) {
                  return DropdownMenuItem(value: e, child: Text("Company"));
                }).toList(),
                onChanged: (value) {
                  print(e);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                value: comapanValue,
                items: companyList.map((e) {
                  return DropdownMenuItem(value: e, child: Text("Category"));
                }).toList(),
                onChanged: (value) {
                  print(e);
                },
              ),
              SizedBox(
                height: 10,
              ),
              AppTextfiled(
                maxLine: 5,
                controller: driscripationController,
                title: const Text("Descripation"),
              ),
              AppTextfiled(
                controller: priceController,
                title: const Text("Price"),
              ),
              AppTextfiled(
                controller: qtyController,
                title: const Text("qty"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, right: 220, bottom: 10),
                child: Text("upload Image :"),
              ),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1.2,
                              offset: Offset(0.0, 0.0),
                              color: Colors.grey,
                              blurStyle: BlurStyle.outer)
                        ]),
                    child: Icon(Icons.add)),
              ),

              ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    addproduct();
                    clearText();
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(330, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Add")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addproduct() {
    return product
        .add({
          "product": productController.text,
          "price": priceController.text,
          "Qty": qtyController.text,
          "descripation": driscripationController.text,

        })
        .then((value) => print("product add sucessfully"))
        .catchError((error) => print("failed"));
  }

/*  FirebaseStorage _storage = FirebaseStorage.instance;*/

/*  Future<Uri> uploadPic() async {
    File image = (await ImagePicker.pickImage(source: ImageSource.gallery)) as File;
    StorageReference reference = _storage.ref().child("images/");
    StorageUploadTask uploadTask = reference.putFile(file);
    Uri location = (await uploadTask.future).downloadUrl;
    return location;
  }*/






  clearText() {
    productController.clear();
    priceController.clear();
    qtyController.clear();
    driscripationController.clear();
  }
}
