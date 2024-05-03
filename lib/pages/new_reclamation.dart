import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_ui/pages/camera.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'ComplaintList.dart';
import 'globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config.dart';


class NewReclamationForm extends StatefulWidget {
  final List<String> complaintTypes;
  final String type;
  const NewReclamationForm({
    Key? key,
    required this.type,
    required this.complaintTypes,
  }) : super(key: key);

String get token => globals.authToken;

  @override
  _NewReclamationFormState createState() => _NewReclamationFormState();
}

class _NewReclamationFormState extends State<NewReclamationForm> {
  TextEditingController _titreController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FilePickerResult?Result;
  String? filename;
  PlatformFile?pickedfile;
  bool isloading= false;
  File? filetoshow ;
  /*String lat ='Null, Press Button';
  String long ='Null, Press Button';
  String Address = '';*/
  String path='' ;

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
// Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    path =image!.path;
  }

  //String? _location;
  String _complaintType = '';
  String _description = '';

  List<String> _complaintTypes = [];
  late String? userID;
  late String _type;

  @override
  void initState() {
    super.initState();
    _complaintTypes = widget.complaintTypes;
    _complaintType = widget.type; // Set the initial selected type to the passed type
    _type = widget.type;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userID = jwtDecodedToken['_id'];
  }



  void _updateComplaintTypes(int index, String newType) {
    setState(() {
      _complaintTypes[index] = newType;
    });
  }

  void addcomp() async {
    if (_titreController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _textEditingController.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });

      var request = http.MultipartRequest("POST", Uri.parse(create));
      request.fields['title'] = _titreController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['submitter'] = userID!;
      request.fields['type'] = jsonEncode({
        'type': _type,
        'soustype': _complaintType,
      }); // Convert type to a JSON string

      if (path != '') {
        var file = await http.MultipartFile.fromPath(
          'file',
          path,
          contentType: MediaType('image', 'jpeg'),
        ); // Adjust the content type as per your image file type

        request.files.add(file);
      }
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          response.stream.transform(utf8.decoder).listen((value) {
            print("Response body: $value"); // Log the response body
          });
        } else {
          print("Upload failed with status code: ${response.statusCode}");
          response.stream.transform(utf8.decoder).listen((value) {
            print("Error response body: $value"); // Log the error body
          });
        }
      } catch (error, stacktrace) {
        print("Exception occurred: $error with stacktrace: $stacktrace");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF5B8E55),
        elevation: 4,
        title: Text(
          " $_type ",
          style: TextStyle(
            color: Colors.white, // Change text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white

      ),
      body: SingleChildScrollView(
        child: Container(color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title of the complaint',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 18.0, // Adjust the font size as needed
                    ),

                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Give a title of the complaint',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins' ,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), // Adjust left padding

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2), // Border color and width
                      ),
                      enabledBorder: OutlineInputBorder( // Border when the field is not focused
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder( // Border when the field is focused
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2),
                      ),

                    ),
                    controller: _titreController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please donner un titre';
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Select type of complaint:',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 18.0, // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: widget.complaintTypes.map((type) => ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _complaintType = type;
                        });
                      },
                        style: ElevatedButton.styleFrom(
                          primary:
                          _complaintType == type ?  Color(0xFF5B8E55) : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontFamily: 'Poppins' ,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: GoogleFonts.anekTelugu(
                          fontSize: 18.0, // Adjust the font size as needed
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Give a Description',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins' ,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), // Adjust left padding
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2), // Border color and width
                          ),
                          enabledBorder: OutlineInputBorder( // Border when the field is not focused
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder( // Border when the field is focused
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Color(0xFF5B8E55), width: 1.2),
                          ),

                        ),
                        controller:  _descriptionController ,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(

                      width: 160,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Camera()),
                          );                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
                          children: [
                            Icon(
                              CupertinoIcons.camera_viewfinder,
                              size:28,
                              color: Color(0xFF5B8E55),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Take a photo',
                              style: TextStyle(
                                fontFamily: 'Poppins' ,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(0xFF5B8E55),
                              ),
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(50.0, 50.0)), // Change the width and height as needed
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF5B8E55)),
                            ),
                          ),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0)),
                          textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        addcomp ();
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage(token: widget.token),)
                        );
                      },
                      child: Text(
                        'ADD',

                        style: TextStyle(fontFamily: 'Poppins' ,
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF5B8E55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 60.0),
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
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


