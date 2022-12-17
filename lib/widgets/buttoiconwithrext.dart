import 'package:flutter/material.dart';

class IconTextbutton extends StatelessWidget {
  Icon buttonicon;
  String buttontext;
  double iconbuttonleftmaregin;
  double iconbuttonrightmargin;
  BoxDecoration? decoration;
  double? iconbuttonheightt;
  void Function() buttonicinclick;

  IconTextbutton({
    Key? key,
    required this.buttontext,
    this.decoration,
    required this.buttonicon,
    required this.iconbuttonleftmaregin,
    required this.iconbuttonrightmargin,
    required this.buttonicinclick,
    this.iconbuttonheightt,

}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:buttonicinclick,
      child: Container(
        margin: EdgeInsets.only(
            left: iconbuttonleftmaregin, right: iconbuttonrightmargin),
        width: double.maxFinite,
        height: iconbuttonheightt,
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonicon,
            Text(
              buttontext,
            )
          ],
        ),
      ),
    );
  }
}
