import 'package:flutter/material.dart';

class EmailTextfield extends StatelessWidget {
  String? hinttext;
  String? labeltext;
  TextInputType inputType;
  TextEditingController controller;
  Color textfieldcolor;

  EmailTextfield(
      {Key? key,
      this.hinttext,
      this.labeltext,
      required this.inputType,
      required this.controller,
      required this.textfieldcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: TextFormField(
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Enter values";
        //   }
        //   return null;
        // },
        controller: controller,
        obscureText: labeltext == 'Password' ? true : false,
        keyboardType: inputType,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textfieldcolor, width: 2),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textfieldcolor, width: 2),
                borderRadius: BorderRadius.circular(5)),
            hintText: hinttext,
            labelText: labeltext,
            labelStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }
}
