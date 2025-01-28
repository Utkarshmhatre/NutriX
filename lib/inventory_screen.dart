import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('products') ?? [];
    setState(() {
      _products = productsJson.map((productJson) {
        final Map<String, dynamic> productMap = json.decode(productJson);
        return Product(
          name: productMap['name'],
          quantity: productMap['quantity'],
          price: productMap['price'],
          expiryDate: DateTime.parse(productMap['expiryDate']),
        );
      }).toList();
    });
  }

  void _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = _products
        .map((product) => json.encode({
              'name': product.name,
              'quantity': product.quantity,
              'price': product.price,
              'expiryDate': product.expiryDate.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList('products', productsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            child: ListTile(
              title: Text(product.name),
              subtitle: Text(
                  'Quantity: ${product.quantity}, Expiry: ${DateFormat('yyyy-MM-dd').format(product.expiryDate)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteProduct(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  title: const Text('Expiry Date'),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  _addProduct(
                    nameController.text,
                    int.parse(quantityController.text),
                    double.parse(priceController.text),
                    selectedDate,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addProduct(
      String name, int quantity, double price, DateTime expiryDate) {
    setState(() {
      _products.add(Product(
        name: name,
        quantity: quantity,
        price: price,
        expiryDate: expiryDate,
      ));
      _saveProducts();
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
      _saveProducts();
    });
  }
}

class Product {
  final String name;
  final int quantity;
  final double price;
  final DateTime expiryDate;

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.expiryDate,
  });
}