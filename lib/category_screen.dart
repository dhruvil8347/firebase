import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  CollectionReference category = FirebaseFirestore.instance.collection("category");
  TextEditingController CategoryCtrl = TextEditingController();
  List<String> name = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CategoryScreen"),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: CategoryCtrl,
              decoration: InputDecoration(
                label: Text("Category"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(onPressed: (){

              addCompany();
              CategoryCtrl.clear();
            },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(321,50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: Text("ADD")),

            Padding(
              padding: const EdgeInsets.only(right: 200,top: 10),
              child: Text("List of category"),
            ),

            Expanded(
              child:
              ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            width: 230,
                            child: Text(
                              "hello",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap: () {
                                  },
                                  child: const Icon(Icons.edit,
                                      color: Colors.white)),
                              Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Delete"),
                                            content: const Text(
                                                "Are you sure you want to delete?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(
                                                        context)
                                                        .pop();
                                                  },
                                                  child: const Text(
                                                      "Cancel")),
                                              TextButton(
                                                  onPressed: () {
                                                  },
                                                  child:
                                                  const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                        Icons.delete,
                                        color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  Future<void> addCompany(){
    return category.add({
      "category": CategoryCtrl.text

    });
  }

}
