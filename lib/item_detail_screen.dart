import 'package:flutter/material.dart';

import 'item.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late TextEditingController _textController;
  late TextEditingController _upcController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.text);
    _upcController = TextEditingController(text: widget.item.upc);
    _priceController = TextEditingController(text: widget.item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.item.text = _textController.text;
              widget.item.upc = _upcController.text;
              widget.item.price = _priceController.text;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.file(widget.item.image),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _upcController,
                decoration: const InputDecoration(labelText: 'UPC'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
