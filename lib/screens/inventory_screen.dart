import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/warehouse.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../analytics/warehouse_analytics.dart';
import '../widgets/charts.dart';
import '../widgets/dialogs.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Warehouse> _warehouses = [];
  int _selectedWarehouseIndex = 0;
  bool showCharts = false;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  void _loadWarehouses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWarehouses = prefs.getStringList('warehouses') ?? [];
    setState(() {
      _warehouses = savedWarehouses.map((whJson) {
        return Warehouse.fromJson(json.decode(whJson));
      }).toList();
    });
  }

  void _saveWarehouses() async {
    final prefs = await SharedPreferences.getInstance();
    final whJsons = _warehouses.map((wh) => json.encode(wh.toJson())).toList();
    await prefs.setStringList('warehouses', whJsons);
  }

  void _addProductToWarehouse(
      String name, int quantity, double price, DateTime expiryDate) {
    setState(() {
      _warehouses[_selectedWarehouseIndex].products.add(Product(
        name: name,
        quantity: quantity,
        price: price,
        expiryDate: expiryDate,
      ));
      _saveWarehouses();
    });
  }

  void _deleteProduct(int productIndex) {
    setState(() {
      _warehouses[_selectedWarehouseIndex].products.removeAt(productIndex);
      _saveWarehouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          if (_warehouses.isNotEmpty)
            IconButton(
              icon: Icon(showCharts ? Icons.list : Icons.pie_chart),
              onPressed: () => setState(() => showCharts = !showCharts),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => showAddWarehouseDialog(context, _warehouses, _saveWarehouses),
              child: const Text('Add Warehouse'),
            ),
            const SizedBox(height: 10),
            if (_warehouses.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: DropdownButton<int>(
                    value: _selectedWarehouseIndex,
                    isExpanded: true,
                    items: List.generate(_warehouses.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(_warehouses[index].name),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedWarehouseIndex = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (_warehouses.isNotEmpty)
              Expanded(
                child: showCharts
                    ? buildCharts(_warehouses[_selectedWarehouseIndex])
                    : ListView.builder(
                        itemCount: _warehouses[_selectedWarehouseIndex].products.length,
                        itemBuilder: (context, index) {
                          final product =
                              _warehouses[_selectedWarehouseIndex].products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Qty: ${product.quantity}\nPrice: \$${product.price.toStringAsFixed(2)}\nExp: ${DateFormat('yyyy-MM-dd').format(product.expiryDate)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteProduct(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _warehouses.isNotEmpty ? () => showAddProductDialog(context, _addProductToWarehouse) : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}