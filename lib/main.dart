import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference company =
      FirebaseFirestore.instance.collection('company');

  TextEditingController companyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase"),
      ),
      body: Column(
        children: [
          Form(
            child: TextFormField(
              controller: companyCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  label: const Text("Company")),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                addcompany();
                ClearText();
              },
              style:
                  ElevatedButton.styleFrom(fixedSize: const Size(310, 40)),
              child: const Text("ADD")),
          Container(

            child: ListView(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('company')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                    return ListView(
                        children: snapshot.data!.docs.map((document) {
                      return Container(
                        child: Center(child: Text(document['company'])),
                      );
                    }).toList()

                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addcompany() {
    return company.add({
      "company": companyCtrl.text,
    });
  }

  ClearText() {
    companyCtrl.clear();
  }
}
