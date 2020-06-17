import 'dart:io';
import 'package:mlsamples/components/custom_list_tile_button.dart';
import 'package:mlsamples/models/text_identifier.dart';
import 'package:mlsamples/models/face_analyzer.dart';
import 'package:mlsamples/models/image_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:mlsamples/components/custom_round_button.dart';
import 'package:mlsamples/components/face_contour_painter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum Algorithms { Face, ImageLabel, OCR }

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool showSpinner = false;
  bool showAlgorithmButtons = false;
  String algorithmText;

  File _image;
  var _imageFile;

  FaceAnalyzer faceAnalyzer = FaceAnalyzer();
  ImageRecognizer imageRecognizer = ImageRecognizer();
  TextIdentifier textIdentifier = TextIdentifier();

  Future getImage(ImgSource source) async {
    faceAnalyzer = FaceAnalyzer();
    imageRecognizer = ImageRecognizer();
    textIdentifier = TextIdentifier();

    var image = await ImagePickerGC.pickImage(
      maxWidth: 960,
      maxHeight: 1280,
      context: context,
      source: source,
    );

    _imageFile = await image.readAsBytes();
    _imageFile = await decodeImageFromList(_imageFile);

    setState(() {
      _imageFile = _imageFile;
      _image = image;
      showAlgorithmButtons = true;
      algorithmText = null;
    });
  }

  void runAlgorithm(Algorithms algorithm) async {
    setState(() {
      showSpinner = true;
      showAlgorithmButtons = false;
    });

    if (algorithm == Algorithms.Face) {
      await faceAnalyzer.detectFaces(_image);
    } else if (algorithm == Algorithms.ImageLabel) {
      await imageRecognizer.labelImages(_image);
      algorithmText = imageRecognizer.textLabels[0];
    } else if (algorithm == Algorithms.OCR) {
      await textIdentifier.extractTexts(_image);
      algorithmText = textIdentifier.text;
      print(algorithmText);
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Firebase ML Samples',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
        ),
        backgroundColor: Color(0xff01A0C7),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            algorithmText != null
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '$algorithmText',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  )
                : Container(),
            _image != null
                ? Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightBlueAccent, width: 10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FittedBox(
                          child: SizedBox(
                            width: _imageFile.width.toDouble(),
                            height: _imageFile.height.toDouble(),
                            child: CustomPaint(
                              painter: FaceContourPainter(
                                  faceContours: faceAnalyzer.faceContours,
                                  imageFile: _imageFile),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightBlueAccent, width: 10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomRoundButton(
                    isVisible: true,
                    iconData: Icons.image,
                    color: Colors.green,
                    onPressed: () => getImage(ImgSource.Gallery),
                  ),
                  CustomRoundButton(
                    isVisible: true,
                    iconData: Icons.camera,
                    color: Colors.blue,
                    onPressed: () => getImage(ImgSource.Camera),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  CustomListTileButton(
                    isVisible: showAlgorithmButtons,
                    iconData: Icons.face,
                    text: 'Face Contours',
                    color: Colors.red,
                    onPressed: () => runAlgorithm(Algorithms.Face),
                  ),
                  CustomListTileButton(
                    isVisible: showAlgorithmButtons,
                    iconData: Icons.category,
                    text: 'Image Labeling',
                    color: Colors.red,
                    onPressed: () => runAlgorithm(Algorithms.ImageLabel),
                  ),
                  CustomListTileButton(
                    isVisible: showAlgorithmButtons,
                    iconData: Icons.text_fields,
                    text: 'Text Recognition',
                    color: Colors.red,
                    onPressed: () => runAlgorithm(Algorithms.OCR),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
