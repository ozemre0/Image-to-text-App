import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String? _extractedText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Image Picker",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    color: Colors.blue,
                    child: const SizedBox(
                      width: 225,
                      height: 20,
                      child: Center(
                        child: Text(
                          "Pick Image From Gallery",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _takePhoto();
                    },
                    color: Colors.red,
                    child: const SizedBox(
                      width: 225,
                      height: 20,
                      child: Center(
                        child: Text(
                          "Take photo from your camera",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : const Text("Please select an image or take a photo"),
                  const SizedBox(height: 25),
                  _extractedText != null
                      ? Text(_extractedText!) // Display extracted text
                      : Container(), // Empty container if text is not available yet
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final _returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(
      () {
        _selectedImage = File(_returnedImage!.path);
        _extractTextFromImage();
      },
    );
  }

  Future _takePhoto() async {
    final _returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (_returnedImage == null) return;
    setState(
      () {
        _selectedImage = File(_returnedImage.path);
        _extractTextFromImage();
      },
    );
  }

  Future<void> _extractTextFromImage() async {
    if (_selectedImage == null) return;
    final extractedText = await _extractText(_selectedImage!);
    setState(() {
      _extractedText = extractedText;
    });
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    final String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

}
