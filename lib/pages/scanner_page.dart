import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class EwasteDetectionPage extends StatefulWidget {
  @override
  _EwasteDetectionPageState createState() => _EwasteDetectionPageState();
}

class _EwasteDetectionPageState extends State<EwasteDetectionPage> {
  File? _image;
  String? _result;
  String? _guideline;
  Interpreter? _interpreter;
  List<String> labels = [];
  final int imageSize = 224;

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/e-waste.tflite');
      print("✅ Model loaded successfully");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  Future<void> loadLabels() async {
    try {
      final String labelString = await rootBundle.loadString('assets/model/labels.txt');
      labels = labelString.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      print("✅ Labels loaded: $labels");
    } catch (e) {
      print("❌ Error loading labels: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      classifyImage(_image!);
    }
  }

  Future<void> classifyImage(File image) async {
    if (_interpreter == null || labels.isEmpty) {
      print("⚠️ Model or labels not yet loaded.");
      return;
    }

    try {
      var imageBytes = image.readAsBytesSync();
      img.Image? imageInput = img.decodeImage(imageBytes);
      imageInput = img.copyResize(imageInput!, width: imageSize, height: imageSize);

      var input = List.generate(1, (i) => List.generate(imageSize, (j) =>
          List.generate(imageSize, (k) => List.generate(3, (c) => 0.0), growable: false), growable: false), growable: false);

      for (int y = 0; y < imageSize; y++) {
        for (int x = 0; x < imageSize; x++) {
          var pixel = imageInput.getPixel(x, y);
          input[0][y][x][0] = ((pixel >> 16) & 0xFF) / 255.0;
          input[0][y][x][1] = ((pixel >> 8) & 0xFF) / 255.0;
          input[0][y][x][2] = (pixel & 0xFF) / 255.0;
        }
      }

      var output = List.generate(1, (index) => List.filled(labels.length, 0.0));
      _interpreter!.run(input, output);

      int maxPos = output[0].indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));
      double confidence = output[0][maxPos] * 100;
      String detectedItem = labels[maxPos];

      setState(() {
        _result = "Detected: $detectedItem\nConfidence: ${confidence.toStringAsFixed(2)}%";
        _guideline = getDisposalGuidelines(detectedItem);
      });
    } catch (e) {
      print("❌ Error in classification: $e");
    }
  }

  String getDisposalGuidelines(String item) {
    Map<String, String> guidelines = {
      "Battery": "Do not dispose of in regular trash. Find a certified e-waste center nearby.",
      "TV": "Recycle at an approved e-waste collection center to prevent lead contamination.",
      "microwave": "Dispose of at an e-waste facility due to electronic and metallic components.",
      "smartwatch": "Recycle at an authorized e-waste collection point due to battery and circuit elements.",
      "Keyboards": "Drop at an e-waste collection facility to recover recyclable materials.",
      "Mobile": "Recycle at a designated facility to recover metals and prevent environmental hazards.",
      "Mouse": "Dispose of responsibly at an e-waste center to avoid plastic and electronic waste.",
      "laptop": "Recycle at an e-waste facility to recover valuable components and materials.",
      "camera": "Return to an e-waste center to prevent environmental contamination.",
      "Washing Machine": "Dispose of at a certified recycling facility to recover metal and plastic parts.",
      "Printer": "Recycle at an authorized e-waste collection point due to ink and electronic waste.",
      "Player": "Dispose of at an e-waste facility due to electrical and plastic components.",
      "PCB": "Recycle at an e-waste facility to safely process hazardous materials."
    };
    return guidelines[item] ?? "Please check local e-waste disposal guidelines.";
  }

  void _searchOnline(String query) async {
    final url = Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent(query)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      print("❌ Could not launch search for $query");
    }
  }

  void showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Take a Photo'),
            onTap: () => pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Choose from Gallery'),
            onTap: () => pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("E-Waste Scanner")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image == null
                ? Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.camera_alt, size: 100, color: Colors.white),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(_image!, height: 250, width: 250, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 20),
          _result == null
              ? Text("Import Your Image", style: TextStyle(fontSize: 16))
              : GestureDetector(
            onTap: () => _searchOnline(_result!.split(':')[1].trim()),
            child: Text(
              _result!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          if (_guideline != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Guideline: $_guideline",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: showImageSourceSelection,
            icon: Icon(Icons.camera, color: Colors.black),
            label: Text("Scan Image", style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}
