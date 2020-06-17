import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceContourPainter extends CustomPainter {
  List<FaceContour> faceContours;
  var imageFile;

  List<Color> contourColors = [
    Colors.blue,
    Colors.green,
    Colors.green,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.deepPurple,
    Colors.red,
    Colors.pink,
    Colors.red,
    Colors.pink,
    Colors.orangeAccent,
    Colors.orangeAccent,
  ];

  FaceContourPainter({@required this.faceContours, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (var ii = 0; ii < faceContours.length; ii++) {
      List<Offset> points = faceContours[ii].positionsList;
      Color color = contourColors[ii];
      canvas.drawPoints(
        PointMode.polygon,
        points,
        Paint()
          ..color = color
          ..strokeWidth = 5,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
