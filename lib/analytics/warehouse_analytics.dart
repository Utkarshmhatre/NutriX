import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/warehouse.dart';
import '../models/product.dart';

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