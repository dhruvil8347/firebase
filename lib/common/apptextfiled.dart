import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class AppTextfiled extends StatelessWidget {
  const AppTextfiled(
      {Key? key,
      this.controller,
      this.validation,
      this.title,
      this.maxLine,
      this.keyboardType,
      this.onchanged,
      this.input, })
      : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final Widget? title;
  final int? maxLine;
  final TextInputType? keyboardType;
  final void Function(String)? onchanged;
  final List<TextInputFormatter>? input;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: validation,
        maxLines: maxLine,
        onChanged: onchanged,
        inputFormatters: input,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            label: title,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
