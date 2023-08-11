import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/details_screen.dart';
import 'package:flutter/material.dart';
import 'addproduct_screen.dart';
import 'main.dart';
import 'model/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  CollectionReference product =
  FirebaseFirestore.instance.collection("product");
  String id = "";
  List<ProductModel> productlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProduct(),
                    )
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("product").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    onTap: (){
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => DetailScreen(
                         productListModel: ProductModel()),));
                    },

                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 130,
                            width: 330,
                            child: Card(
                              elevation: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.blue,
                                 /*   child: Image.network(),*/
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10, top: 30),
                                    child: SizedBox(
                                      width: 120,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(document['productName'] ?? "",
                                              style:
                                              const TextStyle(fontSize: 18)),
                                          Text((document['price'] ?? 0).toString(),
                                              style:
                                              const TextStyle(fontSize: 11)),
                                          Text((document['qty'] ?? 0).toString(),
                                              style:
                                              const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            // print(document['productName']);
                                            // print(document['categoryName'] );
                                            // print(document['companyName'] );
                                            // print(document['qty']);
                                            // print(document['price']);
                                            // print(document['description']);
                                            var model = ProductModel(
                                                id: document.id,
                                                productName: document['productName']   ??'',
                                                categoryName: document['categoryName'] ?? '',
                                                 companyName:document['companyName']    ?? '',
                                                qty: document['qty'] ?? 0,
                                                price: document['price'] ?? 0,
                                                description:document['description'] ??'');
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProduct(productModel:model))

                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(productModel: productModel,))
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(80, 30)),
                                          child: const Text("Edit")),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  content: const Text(
                                                      "Are you Sure if you want to Delete?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {},
                                                        child:
                                                        const Text("Cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          deleteProduct(
                                                              document.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors.red),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                            /* deleteProduct(document.id);*/
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(80, 30)),
                                          child: const Text("Delete")),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
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

/// all good commit
