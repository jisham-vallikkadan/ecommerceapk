import 'dart:convert';

import 'package:ecommerceapk/Registrationpage.dart';
import 'package:ecommerceapk/drivermap.dart';
import 'package:ecommerceapk/providerclass.dart';
import 'package:ecommerceapk/userpage.dart';
import 'package:ecommerceapk/widgets/emailtextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/buttoiconwithrext.dart';
import 'widgets/button.dart';
import 'widgets/circulalaravathar.dart';
import 'widgets/welcomeback.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController Emailcontorler = TextEditingController();
  TextEditingController Passwordcontroler = TextEditingController();
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xffB4D1E7FF),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CirclerAvatar(
                      circularimage: 'images/3672341.jpg',
                      radius: 80,
                      circlecolor: Colors.white),
                  LoginText(
                      text: 'Welcome back',
                      textcolor: Colors.black,
                      textsize: 30,
                      textweight: FontWeight.bold),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        RegExp regex = RegExp(pattern);
                        if (value == null ||
                            value.isEmpty ||
                            !regex.hasMatch(value))
                          return 'Enter a valid email address';
                        else {
                          return null;
                        }
                      },
                      controller: Emailcontorler,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black38)),
                    ),
                  ),
                  EmailTextfield(
                    textfieldcolor: Colors.white,
                    controller: Passwordcontroler,
                    labeltext: 'Enter Password',
                    hinttext: '',
                    inputType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: LoginText(
                      text: 'Forget password',
                      textcolor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button(
                    boxDecoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    buttontext: 'Sign in',
                    buttonTextcolor: Colors.white,
                    buttonmarginleft: 25,
                    buttonmarginright: 25,
                    buttonhight: 50,
                    buttonclik: () async {
                      if (_formKey.currentState!.validate()) {
                        SharedPreferences p=await SharedPreferences.getInstance();
                        var type=(p.getInt('usertype'));
                        if(type==2){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Drivermap(),));
                        }else if(type==1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Userpage(),));
                        }
                      } else {}

                      Provider.of<Eprovider>(context, listen: false).userLogin({
                        "useremail": Emailcontorler.text,
                        "userpwd": Passwordcontroler.text,
                      });

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Drivermap(),));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginText(
                        text: 'Not a member ? ',
                        textcolor: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registationpage(),
                              ));
                        },
                        child: LoginText(
                          text: 'Signup',
                          textcolor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future userLogin() async{
  //   print('login funtion');
  //   var logindata={
  //     "useremail": Emailcontorler.text,
  //     "userpwd":Passwordcontroler.text,
  //   };
  //   var url="http://192.168.43.84:5000/users/login";
  //   var responser=await http.post(Uri.parse(url),body: logindata);
  //   var body=jsonDecode(responser.body);
  //   print(body);
  // }
}
