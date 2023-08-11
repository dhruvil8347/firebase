import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CompanyScreen> {
  final  CollectionReference  company =
      FirebaseFirestore.instance.collection('company');

  TextEditingController companyCtrl = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String id = "";
  String time = "";
  int? companyValue ;
  /*DateTime createAt = DateTime.now();*/
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CompanyScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "enter the company name";
                  }
                  return null;
                },
                controller: companyCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text("Company")),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onLongPress: (){
                  logger.i('null');
                },
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (formkey.currentState!.validate()) {
                    if(id.isNotEmpty){
                      updatecompany(id);
                    }else{
                      addcompany();
                    }//ffgdd
                    clearText();
                  }
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(310, 40)),
                child: const Text("ADD")),
            const Padding(
              padding: EdgeInsets.only(top: 25, right: 180, bottom: 10),
              child: Text("List of companies"),
            ),



            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('company').orderBy('createAt', descending: true)
                    .snapshots(),

                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        ///docs[index].id
                        children: snapshot.data!.docs.map((document) {
                      return ListTile(
                        title: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 202,
                                  child: Text(
                                    document['company'],overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          id = document.id;
                                          /// store value in text controller
                                          companyCtrl.text = document['company'];
                                        },
                                        child: const Icon(Icons.edit,
                                            color: Colors.white)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  content: const Text(
                                                      "Are you sure if you want delete"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {
                                                          deletecompany(
                                                              document.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.red),
                                                        )
                                                    )
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
                            )),
                      );
                    }).toList());
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addcompany() {
    return company.add({
      "company": companyCtrl.text.trim(),
      "createAt":DateTime.now(),
    });
  }

  Future<void> deletecompany(String id) {
    return company
        .doc(id)
        .delete()
        .then((value) => logger.i("Deleted user"))
        .catchError((error) => logger.i("Failed $error"));
  }

  Future<void> updatecompany(String id) {
    return company
        .doc(id)
        .update({"company": companyCtrl.text})
        .then((value) => logger.i("upadated user"))
        .catchError((error) => logger.i("failed $error"));
  }

  clearText() {
    companyCtrl.clear();
    id = "";
  }
}
