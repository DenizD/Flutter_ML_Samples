import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceAnalyzer {
  List<Face> faces = [];
  List<Rect> rect = [];
  List<FaceContour> faceContours = [];

  List<FaceContourType> contourTypes = [
    FaceContourType.face,
    FaceContourType.leftEye,
    FaceContourType.rightEye,
    FaceContourType.leftEyebrowBottom,
    FaceContourType.rightEyebrowBottom,
    FaceContourType.leftEyebrowTop,
    FaceContourType.rightEyebrowTop,
    FaceContourType.upperLipBottom,
    FaceContourType.lowerLipBottom,
    FaceContourType.upperLipTop,
    FaceContourType.lowerLipTop,
    FaceContourType.noseBottom,
    FaceContourType.noseBridge,
  ];

  bool isFaceDetected = false;

  FirebaseVisionImage visionImage;
  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(mode: FaceDetectorMode.accurate, enableContours: true),
  );

  Future<void> detectFaces(File imageFile) async {
    visionImage = FirebaseVisionImage.fromFile(imageFile);
    faces = await faceDetector.processImage(visionImage);
    isFaceDetected = faces.length > 0 ? true : false;

    if (isFaceDetected) {
      for (Face face in faces) {
        if (face.getContour(FaceContourType.allPoints).positionsList.isEmpty)
          continue;
        rect.add(face.boundingBox);
        detectFaceContours(face);
        faceDetector.close();
      }
    }
  }

  void detectFaceContours(Face face) {
    for (FaceContourType contourType in contourTypes) {
      final FaceContour faceContour = face.getContour(contourType);
      if (faceContour == null) continue;
      faceContours.add(faceContour);
    }
  }
}
