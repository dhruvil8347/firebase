import 'dart:io';
import 'package:firebase_project/common/apptextfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

final TextEditingController productController = TextEditingController();
final TextEditingController driscripationController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController qtyController = TextEditingController();
final GlobalKey<FormState> formkey = GlobalKey<FormState>();

final int priceLength = 5;
String text = "";
final int qtyLength = 2;
String? comapanyValue;
String? categoryValue;
List<File> selectedImage = [];
final picker = ImagePicker();

/*List<String> companyList = [
  "1",
  "2",
  "3",
  "4",
];*/

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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                AppTextfiled(
                  validation: (value) {
                    if(value == null || value.trim().isEmpty)
                    {
                      return "Required";
                    }
                    return null;
                  },
                  controller: productController,
                  title: const Text("Product Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('company')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: "Company",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      value: comapanyValue,
                      items: snapshot.data?.docs.map((e) {
                        return DropdownMenuItem(
                            value: e.id, child: Text(e.get("company")));
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          comapanyValue = value as String?;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('category')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return DropdownButtonFormField(
                      decoration: InputDecoration(
                          hintText: "category",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      value: categoryValue,
                      items: snapshot.data?.docs.map((e) {
                        return DropdownMenuItem(
                            value: e.id, child: Text(e.get("category")));
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          categoryValue = value as String?;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextfiled(
                  validation: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Required";
                    }
                    return null;
                  },
                  maxLine: 5,
                  controller: driscripationController,
                  title: const Text("Descripation"),
                ),
                AppTextfiled(
                  validation: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Requried";
                    }
                    return null;
                  },

                  onchanged: (value) {
                    if (value.length <= priceLength) {
                      text = value;
                    } else {
                      priceController.text = text;
                    }
                  },
                  input: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  title: const Text("Price"),
                ),
                AppTextfiled(
                  validation: (value) {
                    if(value == null || value.trim().isEmpty){
                      return "Requried";
                    }
                      return null ;

                  },
                  onchanged: (value) {
                    if (value.length <= qtyLength) {
                      text = value;
                    } else {
                      qtyController.text = text;
                    }
                  },
                  input: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
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
                  onTap: () {
                    pickImage();
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
                      child: const Icon(Icons.add)),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if(formkey.currentState!.validate()){
                        addproduct();
                      }

                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(330, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("SaVE")),
              ],
            ),
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
          "Comapany" : comapanyValue,
          "Category" : categoryValue,
          "image" : selectedImage,
        })
        .then((value) => print("product add sucessfully"))
        .catchError((error) => print("failed"));
  }

  void pickImage () async{
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 10, maxWidth: 10
    );
    List<XFile> xfilepicked = pickedFile;

    if(xfilepicked.isNotEmpty){
      for(var i = 0; i<xfilepicked.length; i++){
        selectedImage.add(xfilepicked[i].path as File);
      }
      setState(() {

      });

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }

    /*if (xfilepicked.isNotEmpty) {
      for (var i = 0; i < xfilepicked.length; i++) {
        selectedImage.add(File(xfilepicked[i].path));
      }
      setState(() {
      });

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }*/

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
