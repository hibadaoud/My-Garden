import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart'; // Add this line for image picking

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';



class Camera extends StatefulWidget {

  const Camera({Key? key}) : super(key: key); // Updated this line to support older Dart versions

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? _camcontroller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIdx = 0;
  String path='' ;


  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _camcontroller = CameraController(
        _cameras![_selectedCameraIdx],
        ResolutionPreset.ultraHigh,
      );
      await _camcontroller!.initialize().then((_) {
        if (!mounted) return;

        // Set flash mode to off after initialization
        _camcontroller!.setFlashMode(FlashMode.off);
        setState(() {});
      }).catchError((e) {
        print('Error initializing camera: $e');
      });
    } else {
      print('No camera found');
    }
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
// Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    path =image!.path;
  }

  Future<void> _takePicture(BuildContext context) async {
    // Check if the camera is initialized
    if (_camcontroller == null || !_camcontroller!.value.isInitialized) {
      print("Error: Camera is not initialized.");
      return;
    }
    // Check if a picture capture is pending
    if (_camcontroller!.value.isTakingPicture) {
      print("Error: Capture is pending.");
      return;
    }

    try {
      // Take a picture and get an XFile object representing the image
      final XFile picture = await _camcontroller!.takePicture();
      path = picture!.path;

    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

// @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _camcontroller == null || !_camcontroller!.value.isInitialized
                ? Center(child: CircularProgressIndicator())
                : CameraPreview(_camcontroller!),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 110.0), // Adjust the left padding here
                    child: IconButton(
                      onPressed: () => _takePicture(context),
                      icon: Icon(Icons.circle_outlined, size: 75),
                      color: Colors.white, // Set the color of the camera icon
                    ),
                  ),
                  Spacer(), // Spacer to create space between the buttons
                  IconButton(
                    onPressed: () => getImage(),
                    icon: Icon(Icons.photo_library, size: 35),
                    color: Colors.white, // Set the color of the library icon
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
