import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Warehouse {
  final String name;
  List<Product> products;

  Warehouse({required this.name, required this.products});

  Map<String, dynamic> toJson() => {
    'name': name,
    'products': products.map((p) => p.toJson()).toList(),
  };

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      name: json['name'],
      products: (json['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList(),
    );
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
    'expiryDate': expiryDate.toIso8601String(),
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      expiryDate: DateTime.parse(json['expiryDate']),
    );
  }
}

class WarehouseAnalytics {
  final Warehouse warehouse;

  WarehouseAnalytics(this.warehouse);

  List<ChartData> getProductDistribution() {
    final Map<String, int> productQuantities = {};
    for (var product in warehouse.products) {
      productQuantities[product.name] = (productQuantities[product.name] ?? 0) + product.quantity;
    }
    
    return productQuantities.entries.map((entry) {
      return ChartData(entry.key, entry.value.toDouble());
    }).toList();
  }

  List<ChartData> getExpiryDistribution() {
    final Map<String, int> expiryGroups = {};
    for (var product in warehouse.products) {
      String month = DateFormat('MMM yyyy').format(product.expiryDate);
      expiryGroups[month] = (expiryGroups[month] ?? 0) + product.quantity;
    }
    
    return expiryGroups.entries.map((entry) {
      return ChartData(entry.key, entry.value.toDouble());
    }).toList();
  }
}

class ChartData {
  final String category;
  final double value;
  ChartData(this.category, this.value);
}