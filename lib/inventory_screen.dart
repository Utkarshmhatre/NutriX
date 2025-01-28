import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const Icon(Icons.inventory),
            title: Text('Item ${i + 1}'),
            subtitle: Text('Quantity: ${(i + 1) * 10}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO:  add item
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
