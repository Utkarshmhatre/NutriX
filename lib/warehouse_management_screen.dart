import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'warehouse.dart';
import 'database_helper.dart';

class WarehouseManagementScreen extends StatefulWidget {
  const WarehouseManagementScreen({Key? key}) : super(key: key);

  @override
  _WarehouseManagementScreenState createState() =>
      _WarehouseManagementScreenState();
}

class _WarehouseManagementScreenState extends State<WarehouseManagementScreen> {
  List<Warehouse> _warehouses = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
    _startStatusSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadWarehouses() async {
    final warehouses = await DatabaseHelper.instance.getWarehouses();
    for (var warehouse in warehouses) {
      if (warehouse.id != null) {
        warehouse.products = await DatabaseHelper.instance
            .getProductsForWarehouse(warehouse.id!);
      } else {
        warehouse.products = [];
      }
    }
    setState(() {
      _warehouses = warehouses;
    });
  }

  void _startStatusSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _simulateStatusChanges();
    });
  }

  void _simulateStatusChanges() async {
    for (var warehouse in _warehouses) {
      for (var product in warehouse.products) {
        if (product.id != null) {
          final statuses = ['Pending', 'In Transit', 'Delivered'];
          final currentIndex = statuses.indexOf(product.status);
          final newStatus = statuses[(currentIndex + 1) % statuses.length];
          await DatabaseHelper.instance
              .updateProductStatus(product.id!, newStatus);
        }
      }
    }
    _loadWarehouses(); // Reload to reflect changes
  }

  void _addWarehouse() async {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final capacityController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Warehouse'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Warehouse Name'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, {
              'name': nameController.text,
              'location': locationController.text,
              'capacity': int.tryParse(capacityController.text) ?? 0,
            }),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      final warehouse = Warehouse(
        name: result['name'],
        location: result['location'],
        capacity: result['capacity'],
      );
      final id = await DatabaseHelper.instance.insertWarehouse(warehouse);
      warehouse.id = id;
      _loadWarehouses();
    }
  }

  void _addProduct(Warehouse warehouse) async {
    if (warehouse.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot add product to unsaved warehouse')),
      );
      return;
    }

    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    String? imagePath;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        imagePath = image.path;
                      });
                    }
                  },
                  child: const Text('Select Image'),
                ),
                if (imagePath != null)
                  Image.file(File(imagePath!), height: 100, width: 100),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, {
                'name': nameController.text,
                'description': descriptionController.text,
                'price': double.tryParse(priceController.text) ?? 0.0,
                'quantity': int.tryParse(quantityController.text) ?? 0,
                'imagePath': imagePath,
              }),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      final product = Product(
        warehouseId: warehouse.id!,
        name: result['name'],
        description: result['description'],
        price: result['price'],
        quantity: result['quantity'],
        imageUrl: result['imagePath'] ?? '',
      );
      final id = await DatabaseHelper.instance.insertProduct(product);
      product.id = id;
      _loadWarehouses();
    }
  }

  void _deleteWarehouse(Warehouse warehouse) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Warehouse'),
        content: Text('Are you sure you want to delete ${warehouse.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && warehouse.id != null) {
      await DatabaseHelper.instance.deleteWarehouse(warehouse.id!);
      _loadWarehouses();
    }
  }

  void _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && product.id != null) {
      await DatabaseHelper.instance.deleteProduct(product.id!);
      _loadWarehouses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Management'),
      ),
      body: ListView.builder(
        itemCount: _warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = _warehouses[index];
          return ExpansionTile(
            title: Text(warehouse.name),
            subtitle: Text(
                'Location: ${warehouse.location}, Capacity: ${warehouse.capacity}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteWarehouse(warehouse),
            ),
            children: [
              ...warehouse.products.map((product) => ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? Image.file(File(product.imageUrl),
                            width: 50, height: 50)
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.name),
                    subtitle: Text(
                        'Status: ${product.status}\nPrice: \$${product.price.toStringAsFixed(2)}\nQuantity: ${product.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product),
                    ),
                  )),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Product'),
                onTap: () => _addProduct(warehouse),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWarehouse,
        child: const Icon(Icons.add),
      ),
    );
  }
}
