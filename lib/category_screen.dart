import 'package:firebase_project/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CollectionReference category =
      FirebaseFirestore.instance.collection("category");
  TextEditingController categoryCtrl = TextEditingController();
  List<String> name = [];
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CategoryScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return "Enter the the category";
                  }
                  return null;
                },
                controller: categoryCtrl,
                decoration: InputDecoration(
                    label: const Text("Category"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onLongPress: (){
                logger.i('null');
              },
                onPressed: () {
                  if(formkey.currentState!.validate()){
                    FocusScope.of(context).unfocus();
                    addCategory();
                    categoryCtrl.clear();
                  }

                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(321, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("ADD")),
            const Padding(
              padding: EdgeInsets.only(right: 200, top: 10),
              child: Text("List of category"),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('category').orderBy("createAt",descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
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
                                      document['category'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {},
                                          child: const Icon(Icons.edit,
                                              color: Colors.white)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Delete"),
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
                                                            deleteCategory(document.id);
                                                            Navigator.of(context).pop();
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
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addCategory() {
    return category.add({
      "category": categoryCtrl.text.trim(),
      "createAt": DateTime.now()});
  }

  Future<void> deleteCategory(String id) {
    return category
        .doc(id)
        .delete()
        .then((value) => logger.i("Deleted user"))
        .catchError((error) => logger.i("filed$error"));
  }
}
