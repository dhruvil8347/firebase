import 'package:flutter/material.dart';

import 'model/product_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.productListModel}) : super(key: key);

  final ProductModel productListModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            /*CarouselSlider(
              items: widget.productListModel.productImg.map((e) {
                return Builder(
                  builder: (context) {
                    return Image.network(ImageUrl + e.productImgg);
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
              ),
            ),*/
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text("Product: ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, height: 3)),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    "Price: ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, height: 3),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 210),
              child: Text(
                "widget.productListModel.categoryName",
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 230,
                  child: Text(
                    "sdf",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 3, fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text("QTY: ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, height: 3)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 220, top: 25),
              child: Text("Descripation:",
                  style: TextStyle(height: 1, fontSize: 16)),
            ),
            const Text("Lorem Ipsum is simply dummy text sum h theer took "),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addproduct(
                                productListModel: widget.productListModel),
                          )).then((value) {
                        */
                /* getproduct();*/
                /*
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 30)),
                    child: const Text("Edit")),*/
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
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ))
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
}
