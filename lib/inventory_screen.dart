import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'warehouse_analytics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  void _showAddWarehouseDialog() {
    final warehouseNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Warehouse'),
          content: TextField(
            controller: warehouseNameController,
            decoration: const InputDecoration(labelText: 'Warehouse Name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (warehouseNameController.text.isNotEmpty) {
                  setState(() {
                    _warehouses.add(
                      Warehouse(
                        name: warehouseNameController.text,
                        products: [],
                      ),
                    );
                    _saveWarehouses();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
                      lastDate: DateTime(2100),
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
                  _addProductToWarehouse(
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

  void _deleteProduct(int productIndex) {
    setState(() {
      _warehouses[_selectedWarehouseIndex].products.removeAt(productIndex);
      _saveWarehouses();
    });
  }

  Widget _buildCharts() {
    final analytics = WarehouseAnalytics(_warehouses[_selectedWarehouseIndex]);
    
    return Column(
      children: [
        const Text('Product Distribution', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 200,
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: analytics.getProductDistribution(),
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Expiry Distribution',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: analytics.getExpiryDistribution(),
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
      ],
    );
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
              onPressed: _showAddWarehouseDialog,
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
                    ? _buildCharts()
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
        onPressed: _warehouses.isNotEmpty ? _showAddProductDialog : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}