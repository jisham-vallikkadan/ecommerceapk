import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Color? buttonTextcolor;
  String? buttontext;
  double buttonmarginleft;
  double buttonmarginright;
  double? buttonhight;
  double? buttontextsize;
  void Function() buttonclik;
  BoxDecoration? boxDecoration;
  Button(
      {Key? key,
      required this.buttonclik,
      this.boxDecoration,
      this.buttonhight,
      this.buttontext,
      required this.buttonmarginleft,
      required this.buttonmarginright,
      this.buttonTextcolor,
      this.buttontextsize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(left: buttonmarginleft, right: buttonmarginright),
      width: double.maxFinite,
      height: buttonhight,
      decoration: boxDecoration,
      child: TextButton(
        child: Text(
          "${buttontext}",
          style: TextStyle(color: buttonTextcolor, fontSize: buttontextsize),
        ),
        onPressed: buttonclik,
      ),
    );
  }
}
