import 'package:flutter/material.dart';

class AppTextfiled extends StatelessWidget {
  const AppTextfiled({Key? key, this.controller, this.validation, this.title, this.maxLine}) : super(key: key);



 final TextEditingController? controller;
 final String? Function(String?)? validation;
 final Widget? title;
 final int? maxLine;
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: validation,
        maxLines: maxLine,
        decoration: InputDecoration(
          label: title,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),

      ),
    );
  }
}
