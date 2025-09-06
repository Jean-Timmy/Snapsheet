
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetectionPage extends StatefulWidget {
  const ProductDetectionPage({super.key});

  @override
  State<ProductDetectionPage> createState() => _ProductDetectionPageState();
}

class _ProductDetectionPageState extends State<ProductDetectionPage> {
  File? _image;
  String _text = '';
  final picker = ImagePicker();
  final _textRecognizer = TextRecognizer();

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _processImage(InputImage inputImage) async {
    // Placeholder for product detection logic
    setState(() {
      _text = 'Detected products will appear here.';
    });
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final inputImage = InputImage.fromFile(file);
      await _processImage(inputImage);
      setState(() {
        _image = file;
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            tooltip: 'Take Photo',
            onPressed: () => getImage(ImageSource.camera),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: 'Select Image',
            onPressed: () => getImage(ImageSource.gallery),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: _image == null
                  ? const Icon(Icons.image, size: 100, color: Colors.grey)
                  : Image.file(
                      _image!,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                _text.isEmpty ? 'Detected products will appear here.' : _text,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
