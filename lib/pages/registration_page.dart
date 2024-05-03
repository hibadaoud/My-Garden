
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart'as http;
import 'config.dart';

import 'login_page.dart';

class RegistrationPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  bool _isPasswordVisible = false;

  void signupuser () async {
    if(_firstnameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty){
      var regBody = {
        "firstName":_firstnameController.text,
        "lastName":_lastnameController.text,
        "email":_emailController.text,
        "mobileNumber":_mobileController.text,
        "password":_passwordController.text,
      };
       var responce = await http.post(Uri.parse(signup),
       headers: {"content-type":"application/json"},
       body: jsonEncode(regBody));
       var jsonResponse = jsonDecode(responce.body);
       print(jsonResponse);
      if (jsonResponse['status'] == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
      }

    }else{
      setState(() {
        checkedValue=true;

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  //color:Color(0xFF5B8E55),
                  child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                      border: Border.all(
                                          width: 5, color: Colors.white),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      //color: Colors.grey.shade300,
                                      color:  Color(0xFF5B8E55),
                                      size: 80.0,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(80, 120, 0, 0),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.grey.shade700,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                color: Colors.grey[200], // Grey background color
                              ),
                              child: TextField(
                                controller: _firstnameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle_outlined,  color: Color(0xFF5B8E55)), // Icon inside TextField
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Remove default border
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                color: Colors.grey[200], // Grey background color
                              ),
                              child: TextField(
                                controller: _lastnameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle_outlined,  color: Color(0xFF5B8E55)), // Icon inside TextField
                                  hintText: 'Last Name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Remove default border
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                color: Colors.grey[200], // Grey background color
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email,  color: Color(0xFF5B8E55)), // Icon inside TextField
                                  hintText: 'E-mail',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Remove default border
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                color: Colors.grey[200], // Grey background color
                              ),
                              child: TextFormField(
                                controller: _mobileController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android,  color: Color(0xFF5B8E55)), // Icon inside TextField
                                  hintText: 'Phone number',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Remove default border
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                color: Colors.grey[200], // Grey background color
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key,  color: Color(0xFF5B8E55)), // Icon inside TextField
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Remove default border
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible; // Toggle the password visibility
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        color:  Color(0xFF5B8E55),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter your password";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0), // Border radius set to 8
                                color:  Color(0xFF5B8E55), // Fallback color for container (if not applied through button)
                              ),
                              child: SizedBox(
                                width: 287,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary:  Color(0xFF5B8E55), // Text color
                                    padding: EdgeInsets.zero, // Set padding to zero to adjust the width
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0), // Border radius set to 8
                                    ),
                                  ),
                                  onPressed: () {
                                    signupuser ();
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0), // Border radius set to 8
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        'Register'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /*Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Register".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  signupuser ();
                                },
                              ),
                            ),*/
                            SizedBox(height: 30.0),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}