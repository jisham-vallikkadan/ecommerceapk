import 'dart:convert';

import 'package:ecommerceapk/drivermap.dart';
import 'package:ecommerceapk/providerclass.dart';
import 'package:ecommerceapk/userpage.dart';
import 'package:ecommerceapk/widgets/circulalaravathar.dart';
import 'package:ecommerceapk/widgets/emailtextfield.dart';
import 'package:ecommerceapk/widgets/welcomeback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loginpage.dart';
import 'widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Registationpage extends StatelessWidget {
  Registationpage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstnamecontroler = TextEditingController();

  TextEditingController lastnamecontroler = TextEditingController();

  TextEditingController emailcontroler = TextEditingController();

  TextEditingController passwordcontroler = TextEditingController();

  TextEditingController mobilenumbercontroelr = TextEditingController();

  TextEditingController usertypecontroler = TextEditingController();

  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  int? Usertype;
  String mobilesuffix = '+91';

  @override
  Widget build(BuildContext context) {
    Usertype = context.watch<Eprovider>().usertype;
    var userReg = Provider.of<Eprovider>(context, listen: false);
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CirclerAvatar(
                    circularimage: 'images/3672341.jpg',
                    radius: 65,
                    circlecolor: Colors.white,
                  ),
                  LoginText(
                    text: 'Sign up',
                    textsize: 35,
                    textcolor: Colors.black,
                    textweight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LoginText(
                    text: "Create an account, it's free",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  EmailTextfield(
                    inputType: TextInputType.text,
                    controller: firstnamecontroler,
                    textfieldcolor: Colors.white,
                    labeltext: ' Firstname',
                  ),
                  EmailTextfield(
                    inputType: TextInputType.text,
                    controller: lastnamecontroler,
                    textfieldcolor: Colors.white,
                    labeltext: ' Lastname',
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
                      controller: emailcontroler,
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
                  // EmailTextfield(
                  //   inputType: TextInputType.number,
                  //   controller: mobilenumbercontroelr,
                  //   textfieldcolor: Colors.white,
                  //   labeltext: 'Phonenumber',
                  // ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value?.length != 10) {
                          return 'Mobile Number must be of 10 digit';
                        } else {
                          return '';
                        }
                      },
                      controller: mobilenumbercontroelr,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefix: Text(mobilesuffix),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Phonenumber",
                          labelStyle: TextStyle(color: Colors.black38)),
                    ),
                  ),
                  EmailTextfield(
                    inputType: TextInputType.text,
                    controller: passwordcontroler,
                    textfieldcolor: Colors.white,
                    labeltext: 'Password',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: 1,
                          groupValue: userReg.usertype,
                          onChanged: (val) {
                            userReg.regtype(1);
                          }),
                      Text('user'),
                      SizedBox(
                        width: 60,
                      ),
                      Radio(
                          value: 2,
                          groupValue: userReg.usertype,
                          onChanged: (val) {
                            userReg.regtype(2);
                          }),
                      Text('Driver'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Button(
                    buttonclik: () async {
                      userReg.registration({
                        'userfname': firstnamecontroler.text,
                        "userlname": lastnamecontroler.text,
                        'useremail': mobilesuffix + emailcontroler.text,
                        "usermobile": mobilenumbercontroelr.text,
                        "userpwd": passwordcontroler.text,
                        "usertype": userReg.usertype.toString(),
                      });
                      if (_formKey.currentState!.validate()) {
                        SharedPreferences prfs =
                            await SharedPreferences.getInstance();
                        var typeofuser = (prfs.getInt('Usertype' ?? ''));
                        print('type is ' + typeofuser.toString());
                        if (typeofuser == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Userpage(),
                              ));
                        } else if (typeofuser == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Drivermap(),
                              ));
                        }
                      }
                    },
                    buttontextsize: 20,
                    buttonmarginleft: 20,
                    buttonmarginright: 20,
                    buttonTextcolor: Colors.white,
                    buttontext: 'Sign up',
                    boxDecoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginText(
                        text: 'Alraday have an account ?',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Drivermap(),
                                ));
                          },
                          child: LoginText(
                            text: 'Login',
                            textsize: 20,
                            textweight: FontWeight.bold,
                            textcolor: Colors.blue,
                          ),
                        ),
                      )
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
}
