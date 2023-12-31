
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/addproduct_screen.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'model/product_model.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key, required this.productListModel}) : super(key: key);

  final ProductModel productListModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CollectionReference product =
      FirebaseFirestore.instance.collection("product");

  List<ProductModel> productlist = [];

  final CollectionReference company =
  FirebaseFirestore.instance.collection("company");
  String cpyName  = "";

  final CollectionReference category =
  FirebaseFirestore.instance.collection("category");
  String categoryName =  "";

  @override
  void initState() {
    getcompany();
    super.initState();
  }

  getcompany()async{
    List a = await company.get().then((value) => value.docs.where((element) => element.id == widget.productListModel.companyName).toList()) ;
    List b = await category.get().then((value) => value.docs.where((element) => element.id == widget.productListModel.categoryName).toList()) ;
    cpyName = a[0]['company'];
    categoryName = b[0]['category'];
    logger.t(categoryName);
    logger.f(cpyName);

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CarouselSlider(
              items: widget.productListModel.productImg.map((e) {
                return Builder(
                  builder: (context) {
                    return Image.network(
                      e,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text("Product:${widget.productListModel.productName}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, height: 3)),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    "Price: ${widget.productListModel.price}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, height: 3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 210),
              child: Text(
                "Category : ${categoryName}",
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text(
                    "Company : ${cpyName}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 3, fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text("QTY: ${widget.productListModel.qty}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, height: 3)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 220, top: 25),
              child: Text("Descripation:",
                  style: TextStyle(height: 1, fontSize: 16)),
            ),
            Text(
                "Lorem Ipsum is simply dummy text sum h theer took ${widget.productListModel.description}"),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProduct(
                              productModel: widget.productListModel
                            ),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 30)),
                    child: const Text("Edit")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 35)),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete",
                                style: TextStyle(color: Colors.red)),
                            content:
                                const Text("Are you sure you want to delete?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                              /*TextButton(
                                  onPressed: () {
                                    deleteProduct(widget.productListModel.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  )
                               )*/

                              TextButton(
                                  onPressed: () async {
                                    await deleteProduct(widget.productListModel.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Delete")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteProduct(String id) {
    return product
        .doc(id)
        .delete()
        .then((value) => logger.i("Delete successfully"))
        .catchError((error) => logger.i("Filed $error"));
  }




}
