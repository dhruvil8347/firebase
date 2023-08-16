import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/details_screen.dart';
import 'package:flutter/material.dart';
import 'addproduct_screen.dart';
import 'main.dart';
import 'model/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    Key? key,
    required this.productListModel,
  }) : super(key: key);

  final ProductModel productListModel;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  CollectionReference product =
      FirebaseFirestore.instance.collection("product");


  final CollectionReference company =
  FirebaseFirestore.instance.collection("company");

  CollectionReference category =
      FirebaseFirestore.instance.collection("category");

  String cpyName = '';
  String categoryName = "";

  String id = "";
//  List<ProductModel> productlist = [];
  @override
  void initState() {
    getcompany();
    super.initState();
  }

  getcompany()async{
    List a = await company.get().then((value) => value.docs.where((element) => element.id == widget.productListModel.companyName).toList()) ;
    List b = await category.get().then((value) => value.docs.where((element) => element.id == widget.productListModel.categoryName).toList()) ;
    cpyName = a[0]['company'];
    categoryName = b[1]['category'];
    logger.t(categoryName);
    logger.f(cpyName);

    setState(() {

    });

  }

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
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("product").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                     /* logger.d(document['productName']);*/
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      productListModel: ProductModel(
                                    id: document.id,
                                    productName: document['productName'] ?? "",
                                    price: document['price'] ?? 0,
                                    qty: document['qty'] ?? 0,
                                    description: document['description'] ?? "",
                                    companyName: document['companyName'] ?? '',
                                    categoryName:
                                        document['categoryName'] ?? '',
                                    productImg: document['productImg'] ?? [],
                                  )),
                                ));
                          },
                          child: SizedBox(
                            height: 130,
                            width: 330,
                            child: Card(
                              elevation: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                productListModel: ProductModel(
                                              id: id,
                                              productName:
                                                  document['productName'] ?? '',
                                            )),
                                          ));
                                    },
                                    child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Image.network(
                                            document['productImg'][0] ?? [])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 30),
                                    child: SizedBox(
                                      width: 120,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(document['productName'] ?? "",
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                         Text(categoryName),
                                          Text(
                                              ('Qty: 0${document['qty'] ?? 0}').toString(),
                                              style: const TextStyle(
                                                  fontSize: 12)),
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
                                            var model = ProductModel(
                                                id: document.id,
                                                productName:
                                                    document['productName'] ??
                                                        '',
                                                categoryName:
                                                    document['categoryName'] ??
                                                        '',
                                                companyName:
                                                    document['companyName'] ??
                                                        '',
                                                qty: document['qty'] ?? 0,
                                                price: document['price'] ?? 0,
                                                productImg:
                                                    document['productImg'] ??
                                                        [],
                                                description:
                                                    document['description'] ??
                                                        '');
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddProduct(
                                                            productModel:
                                                                model))

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
                                                        child: const Text(
                                                            "Cancel")),
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
                                                              color:
                                                                  Colors.red),
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
                        ),
                      );
                    }).toList(),
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

/*  Future<void> deleteCompany(String id) {
    return company
        .doc(id)
        .delete()
        .then((value) => logger.i("Delete successfully"))
        .catchError((error) => logger.i("Filed $error"));
  }*/
}

/// all good commit
