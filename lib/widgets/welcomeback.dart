import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  String? text;
  double? textsize;
  FontWeight? textweight;
  Color? textcolor;
   LoginText({Key? key,
     this.text,
     this.textcolor,
     this.textsize,
     this.textweight

   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('${text}',style: TextStyle(color: textcolor,fontSize: textsize,fontWeight: textweight
    ),);
  }
}
