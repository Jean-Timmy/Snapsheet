import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'item.dart';
import 'item_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String _text = '';
  final picker = ImagePicker();
  final _textRecognizer = TextRecognizer();
  final List<Item> _items = [];
  int _selectedIndex = 0;

  void _saveItem() {
    if (_image != null) {
      setState(() {
        _items.add(Item(image: _image!, text: _text));
        _image = null;
        _text = '';
      });
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    final recognizedText = await _textRecognizer.processImage(inputImage);
    setState(() {
      _text = recognizedText.text;
    });
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final inputImage = InputImage.fromFile(file);
      _processImage(inputImage);
      setState(() {
        _image = file;
      });
    } else {
      print('No image selected.');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        getImage(ImageSource.camera);
        break;
      case 1:
        // TODO: Implement QR code scanner
        print('QR Scan tapped');
        break;
      case 2:
        getImage(ImageSource.gallery);
        break;
      case 3:
        getImage(ImageSource.gallery);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemListScreen(items: _items),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          child: Center(
            child: _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.camera),
                        child: const Text('Take Photo'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        child: const Text('Upload Image'),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.file(_image!),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_text),
                        ),
                        ElevatedButton(
                          onPressed: _saveItem,
                          child: const Text('Save Item'),
                        ),
                      ],
                    ),
                  ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'OCR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ItemListScreen extends StatefulWidget {
  final List<Item> items;

  const ItemListScreen({super.key, required this.items});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cataloged Items'),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return ListTile(
            leading: Image.file(item.image),
            title: Text(item.text),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(item: item),
                ),
              );
              setState(() {});
            },
          );
        },
      ),
    );
  }
}