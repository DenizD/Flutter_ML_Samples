import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class TextIdentifier {
  VisionText visionText;
  String text;

  FirebaseVisionImage visionImage;
  final TextRecognizer textRecognizer =
      FirebaseVision.instance.textRecognizer();

  Future<void> extractTexts(File imageFile) async {
    visionImage = FirebaseVisionImage.fromFile(imageFile);
    visionText = await textRecognizer.processImage(visionImage);

    text = visionText.text;
    textRecognizer.close();
  }
}
