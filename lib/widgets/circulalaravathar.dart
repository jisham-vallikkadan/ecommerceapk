import 'package:flutter/material.dart';
 class CirclerAvatar extends StatelessWidget {
   double? radius;
   Color? circlecolor;
   String circularimage;
    CirclerAvatar({Key? key,
   this.radius,
      this.circlecolor,
    required  this.circularimage,
   }) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return   CircleAvatar(
       radius: radius,backgroundColor: circlecolor,
       backgroundImage: AssetImage(circularimage),
     );
   }
 }

