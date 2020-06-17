import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageRecognizer {
  List<ImageLabel> imageLabels = [];
  List<String> textLabels = [];
  String text;
  String entityId;
  double confidence;
  bool isImageLabeled = false;

  FirebaseVisionImage visionImage;
  final ImageLabeler imageLabeler = FirebaseVision.instance
      .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.75));

  Future<void> labelImages(File imageFile) async {
    visionImage = FirebaseVisionImage.fromFile(imageFile);
    imageLabels = await imageLabeler.processImage(visionImage);
    isImageLabeled = imageLabels.length > 0 ? true : false;

    if (isImageLabeled) {
      for (ImageLabel imageLabel in imageLabels) {
        text = imageLabel.text;
        entityId = imageLabel.entityId;
        confidence = imageLabel.confidence;
        if (confidence > 0.75) {
          textLabels.add(text);
        }
      }
      imageLabeler.close();
    }
  }
}
