import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'warehouse.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static SharedPreferences? _prefs;

  DatabaseHelper._init();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<int> insertWarehouse(Warehouse warehouse) async {
    final pref = await prefs;
    List<String> warehouses = pref.getStringList('warehouses') ?? [];
    int id = warehouses.length;
    warehouse.id = id;
    warehouses.add(json.encode(warehouse.toMap()));
    await pref.setStringList('warehouses', warehouses);
    return id;
  }

  Future<int> insertProduct(Product product) async {
    final pref = await prefs;
    List<String> products = pref.getStringList('products') ?? [];
    int id = products.length;
    product.id = id;
    products.add(json.encode(product.toMap()));
    await pref.setStringList('products', products);
    return id;
  }

  Future<List<Warehouse>> getWarehouses() async {
    final pref = await prefs;
    List<String> warehousesJson = pref.getStringList('warehouses') ?? [];
    return warehousesJson
        .map((w) => Warehouse.fromMap(json.decode(w) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> getProductsForWarehouse(int warehouseId) async {
    final pref = await prefs;
    List<String> productsJson = pref.getStringList('products') ?? [];
    return productsJson
        .map((p) => Product.fromMap(json.decode(p) as Map<String, dynamic>))
        .where((product) => product.warehouseId == warehouseId)
        .toList();
  }

  Future<int> updateProductStatus(int productId, String newStatus) async {
    final pref = await prefs;
    List<String> productsJson = pref.getStringList('products') ?? [];
    int index = productsJson.indexWhere((p) {
      Map<String, dynamic> product = json.decode(p) as Map<String, dynamic>;
      return product['id'] == productId;
    });
    if (index != -1) {
      Map<String, dynamic> product =
          json.decode(productsJson[index]) as Map<String, dynamic>;
      product['status'] = newStatus;
      productsJson[index] = json.encode(product);
      await pref.setStringList('products', productsJson);
    }
    return index;
  }

  Future<void> deleteWarehouse(int warehouseId) async {
    final pref = await prefs;
    List<String> warehouses = pref.getStringList('warehouses') ?? [];
    warehouses.removeWhere(
        (w) => (json.decode(w) as Map<String, dynamic>)['id'] == warehouseId);
    await pref.setStringList('warehouses', warehouses);

    // Delete associated products
    List<String> products = pref.getStringList('products') ?? [];
    products.removeWhere((p) =>
        (json.decode(p) as Map<String, dynamic>)['warehouse_id'] ==
        warehouseId);
    await pref.setStringList('products', products);
  }

  Future<void> deleteProduct(int productId) async {
    final pref = await prefs;
    List<String> products = pref.getStringList('products') ?? [];
    products.removeWhere(
        (p) => (json.decode(p) as Map<String, dynamic>)['id'] == productId);
    await pref.setStringList('products', products);
  }
}
