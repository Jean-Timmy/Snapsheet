import 'package:flutter/material.dart';
import 'item.dart';
import 'item_detail_screen.dart';

class ItemListCatalogPage extends StatelessWidget {
  final List<Item> items;

  const ItemListCatalogPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catalog'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Items'),
              Tab(text: 'Recent'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // "All Items" Tab
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Image.file(item.image),
                  title: Text(item.text),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            ),
            // "Recent" Tab - shows items in reverse order
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[items.length - 1 - index];
                return ListTile(
                  leading: Image.file(item.image),
                  title: Text(item.text),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
