import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_project/common/apptextfiled.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model/product_model.dart';


class AddProduct extends StatefulWidget {
  const AddProduct({Key? key,  this.productModel}) : super(key: key);
  final ProductModel? productModel;

  @override
  State<AddProduct> createState() => _AddProductState();
}



/*List<String> companyList = [
  "1",
  "2",
  "3",
  "4",
];*/

class _AddProductState extends State<AddProduct> {
  CollectionReference product =
      FirebaseFirestore.instance.collection("product");
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

  @override
  void initState() {
    super.initState();
    if(widget.productModel!.id.isNotEmpty){
      productController.text = widget.productModel!.productName;
      priceController.text = widget.productModel!.price.toString();
      qtyController.text = widget.productModel!.qty.toString();
      driscripationController.text = widget.productModel!.description;
      categoryValue = widget.productModel!.categoryName;
      comapanyValue = widget.productModel!.companyName;
    }

  }


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
                          comapanyValue = value;
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
                          categoryValue = value.toString();
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
                  onTap: pickImage,
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
                const SizedBox(
                  height: 10,
                ),
                /*GridView.builder(
                  itemCount: selectedImage.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                   return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.2,
                              color: Colors.grey,
                              blurStyle: BlurStyle.outer)
                        ],
                      ),
                      child: !selectedImage[index].

                    );;
                  },),*/



                ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if(formkey.currentState!.validate()){

                        if(widget.productModel!.id.isNotEmpty){
                          updateProduct(productModel: ProductModel(
                            productName: productController.text,
                            price: int.parse(priceController.text),
                            qty: int.parse(qtyController.text),
                            companyName: comapanyValue!,
                            categoryName: categoryValue!,
                            description: driscripationController.text,
                          ));

                        }else{
                          addProduct(productModel: ProductModel(
                            productName: productController.text,
                            price: int.parse(priceController.text),
                            companyName: comapanyValue!,
                            categoryName: categoryValue!,
                            description: driscripationController.text,
                            qty: int.parse(qtyController.text),
                          ));
                        }

                      }

                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(330, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("SAVE")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addProduct({required ProductModel productModel}) {
    return product
        .add({productModel.tojson()})
        .then((value) => print("product add sucessfully"))
        .catchError((error) => print("failed"));
  }
  
  Future<void> updateProduct({required ProductModel productModel})async{
    return product
        .doc(widget.productModel!.id)
        .update(productModel.tojson())
        .then((value) => print("updated sucessfully"))
        .catchError((error) => print("$error Filed"));
  }

  
/*
  void pickImage () async{
    final firebasefirestore = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;


    if(Permission.isGranted){
      image = await imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image.path);


    }

    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 10, maxWidth: 10

    );
    List<XFile> xfilepicked = pickedFile;

    if(xfilepicked.isNotEmpty){

      for(var i = 0; i<xfilepicked.length; i++)
      {
        selectedImage.add(xfilepicked[i].path as File);
      }

    setState(() {});
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }
  }*/

  final FirebaseFirestore  firebaseFirestore = FirebaseFirestore.instance;

 Future<String> uploadImage(String FileName, File file )async{
    final reference  = FirebaseStorage.instance.ref().child("images");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadlink = await reference.getDownloadURL();
    return downloadlink;
  }

  void pickImage()async{
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpeg','png','jpg'],
    );
    if(pickedFile != null){
      String fileName = pickedFile.files[10].name;
      /*for(var i = 0 ;i < fileName.length; i++){}*/
      File  file = File(pickedFile.files[10].path!);
      final downloadlink = await uploadImage(fileName,file);
      await firebaseFirestore.collection("product").add({
        "imageName":fileName,
        "url":downloadlink,
      });
      print("null");


      /*List<XFile> xfilepicked = pickedFile as List<XFile>;
      if(xfilepicked.isNotEmpty){
        for(var i = 0; i<xfilepicked.length; i++ )
        {
          selectedImage.add(xfilepicked[i].path as File);
        }
        setState(() {});
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing is selected')));
      }*/

    }


  }




  clearText() {
    productController.clear();
    priceController.clear();
    qtyController.clear();
    driscripationController.clear();
    categoryValue = null;
    comapanyValue = null;
  }
}/// all bad commit
