import 'dart:io';

class Item {
  final File image;
  String text;
  String upc;
  String price;

  Item({required this.image, this.text = '', this.upc = '', this.price = ''});
}
