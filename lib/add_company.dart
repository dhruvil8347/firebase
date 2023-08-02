import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Addcompany extends StatefulWidget {
  const Addcompany({Key? key}) : super(key: key);

  @override
  State<Addcompany> createState() => _AddcompanyState();
}

class _AddcompanyState extends State<Addcompany> {

   final formkey = GlobalKey<FormState>();

   TextEditingController companyctrl = TextEditingController();
   @override
  void dispose() {
    companyctrl.dispose();
    super.dispose();
  }
   var companyName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Company"),
      ),
      
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child:
        Column(
           children: [
             Form(
               key: formkey,
               child: TextFormField(
                 validator: (value){
                   if(value == null || value.isEmpty ){
                     return "Please enter name";
                   }
                   return null;
                 },
                 decoration: InputDecoration(
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                     label: const Text("Comapany")),
               ),
             ),
             const SizedBox(
               height: 15,
             ),
             ElevatedButton(onPressed: (){
               if(formkey.currentState!.validate()){
                 setState(() {
                   companyName = companyctrl.text;
                   addCompany();
                   clearText();
                 });

               }

             },
                 style: ElevatedButton.styleFrom(
               fixedSize: const Size(330, 40)
             ), child: const Text("Add company")),
           ],
        ),
      ),
    );
  }

  void clearText(){
    companyctrl.clear();
  }

  void addCompany(){
    if (kDebugMode) {
      print("user added");
    }
  }
}
