import 'dart:io';
import 'package:firebase_project/common/apptextfiled.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'model/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, this.productModel}) : super(key: key);
  final ProductModel? productModel;

  @override
  State<AddProduct> createState() => _AddProductState();
}

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
  String? companyValue;
  String? categoryValue;
  List<String> selectedImage = [];
  List<String> templist = [];
  final picker = ImagePicker();
  String imageURL = '';
  List<int> removeImg = [];
  ProductModel productmodel = ProductModel();

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      productController.text = widget.productModel!.productName;
      driscripationController.text = widget.productModel!.description;
      priceController.text = widget.productModel!.price.toString();
      qtyController.text = widget.productModel!.qty.toString();
      categoryValue = widget.productModel!.categoryName.toString();
      companyValue = widget.productModel!.companyName.toString();
      selectedImage = widget.productModel!.productImg.cast<String>();
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
                    if (value == null || value.trim().isEmpty) {
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
                      value: companyValue,
                      items: snapshot.data?.docs.map((e) {
                        return DropdownMenuItem(
                            value: e.id, child: Text(e.get("company")));
                      }).toList(),
                      onChanged: (value) {
                        logger.i(value);
                        setState(() {
                          companyValue = value;
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
                        logger.i(value);
                        setState(() {
                          categoryValue = value;
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
                    if (value == null || value.trim().isEmpty) {
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
                    if (value == null || value.trim().isEmpty) {
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
                    if (value == null || value.trim().isEmpty) {
                      return "Requried";
                    }
                    return null;
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
                  onTap: () async {
                    await getImages();
                    /*uploadImage(selectedImage.last);*/
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 145,
                        height: 120,
                        child: selectedImage.isEmpty
                            ? const Center(
                                child: Text(
                                "Image not found",
                                style: TextStyle(color: Colors.red),
                              ))
                            : GridView.builder(
                                itemCount: selectedImage.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int index) {
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
                                    child: !selectedImage[index]
                                            .contains("data/user")
                                        ? Stack(
                                            children: [
                                              Center(
                                                child: Image.network(
                                                  selectedImage[index],
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    if (!selectedImage[index]
                                                        .contains("https://")) {
                                                      removeImg.add(productmodel
                                                          .productImg[index] as int);
                                                    }
                                                    selectedImage
                                                        .removeAt(index);
                                                    setState(() {});
                                                    logger.d(
                                                        "REMOVE IMG => $removeImg");
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              Center(
                                                child: Image.file(
                                                  File(selectedImage[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    selectedImage
                                                        .removeAt(index);
                                                    setState(() {});
                                                    logger.t(
                                                        "REMOVE IMG => $removeImg");
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )),
                                            ],
                                          ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: imageURL.isEmpty
                      ? const Text('No image is uploaded.')
                      : Image.network(imageURL),
                ),
                ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (formkey.currentState!.validate()) {
                        if (widget.productModel != null) {
                          List<String> tempListImgUrl = [];
                          for (int a = 0; a < selectedImage.length; a++) {
                            String url = await uploadImage(selectedImage[a]);
                            tempListImgUrl.add(url);
                          }
                          updateproduct(
                            productModel: ProductModel(
                              productName: productController.text,
                              description: driscripationController.text,
                              price: int.parse(priceController.text),
                              qty: int.parse(qtyController.text),
                              companyName: companyValue!,
                              categoryName: categoryValue!,
                              productImg: tempListImgUrl,
                            ),
                          );
                        } else {
                          List<String> tempListImgUrl = [];
                          for (int a = 0; a < selectedImage.length; a++) {
                            String url = await uploadImage(selectedImage[a]);
                            tempListImgUrl.add(url);
                          }
                          addproduct(
                            productModel: ProductModel(
                              productName: productController.text,
                              description: driscripationController.text,
                              price: int.parse(priceController.text),
                              qty: int.parse(qtyController.text),
                              companyName: companyValue!,
                              categoryName: categoryValue!,
                              productImg: tempListImgUrl,
                            ),
                          );
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

  Future<void> updateproduct({required ProductModel productModel}) async {
    return product
        .doc(widget.productModel!.id)
        .update(productModel.tojson())
        .then((value) => logger.e("product add sucessfully"))
        .catchError((error) => logger.e("Filed"));
  }

  Future<String> uploadImage(String file) async {
    String name = DateTime.now().toString();
    final ref = FirebaseStorage.instance.ref('images/$name.jpg');
    final task = await ref.putFile(File(file));
    final fileURL = (await task.ref.getDownloadURL());
    setState(() {});
    return fileURL;
  }

  Future<void> addproduct({required ProductModel productModel}) async {

    /*FirebaseStorage.instance.ref('product').putFile(File(selectedImage.single));*/
    /*  FirebaseStorage.instance
        .ref('product')
        .putFile(File(selectedImage.length as String));*/
    /*Map<String,dynamic> body ={};
    body.addAll({productModel.productImg.});*/

    return product
        .add(productModel.tojson())
        .then((value) => logger.d("product add sucessfully"))
        .catchError((error) => logger.e("FIREBASE FAILED"));
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            logger.i(xfilePick[i].path);
            selectedImage.add(xfilePick[i].path.toString());
          }
          logger.i(selectedImage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Nothing is selected!',
            style: TextStyle(
              color: Colors.red,
            ),
          )));
        }
      },
    );
  }

  clearText() {
    productController.clear();
    priceController.clear();
    qtyController.clear();
    driscripationController.clear();
    companyValue = null;
    categoryValue = null;
    selectedImage.isEmpty;
  }
}
