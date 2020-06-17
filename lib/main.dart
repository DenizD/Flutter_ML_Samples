import 'package:flutter/material.dart';
import 'package:mlsamples/screens/camera_screen.dart';

void main() {
  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(),
    );
  }
}
