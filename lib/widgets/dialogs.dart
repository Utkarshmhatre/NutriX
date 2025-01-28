import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/warehouse.dart';
import '../models/product.dart';

void showAddWarehouseDialog(BuildContext context, List<Warehouse> warehouses, Function saveWarehouses) {
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
                warehouses.add(
                  Warehouse(
                    name: warehouseNameController.text,
                    products: [],
                  ),
                );
                saveWarehouses();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

void showAddProductDialog(BuildContext context, Function addProductToWarehouse) {
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
                    selectedDate = picked;
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
                addProductToWarehouse(
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