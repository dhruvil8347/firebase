import 'package:firebase_project/category_screen.dart';
import 'package:firebase_project/comapny_screen.dart';
import 'package:flutter/material.dart';
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
  State<MyHomePage> createState() => _ListappState();
}

class _ListappState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("FirebaseApp")),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 200,
              color: Colors.blue,
              child: const Center(
                  child: Text(
                    "Product",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(),));
              },
              child: Container(
                height: 200,
                color: Colors.blue,
                child: const Center(
                    child: Text(
                      "Category",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
            const SizedBox(height: 30),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyScreen(),));
              },
              child: Container(
                height: 200,
                color: Colors.blue,
                child: const Center(
                    child: Text(
                      "Company",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

