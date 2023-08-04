import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct() ,));

          }, icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
