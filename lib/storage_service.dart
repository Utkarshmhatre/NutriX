import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _inventoryKey = 'inventory';
  static const String _routesKey = 'routes';

  Future<void> saveInventory(List<Map<String, dynamic>> inventory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inventoryKey, jsonEncode(inventory));
  }

  Future<List<Map<String, dynamic>>> getInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? inventoryJson = prefs.getString(_inventoryKey);
    if (inventoryJson == null) return [];

    return List<Map<String, dynamic>>.from(
      jsonDecode(inventoryJson) as List,
    );
  }

  Future<void> saveRoutes(List<Map<String, dynamic>> routes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_routesKey, jsonEncode(routes));
  }

  Future<List<Map<String, dynamic>>> getRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? routesJson = prefs.getString(_routesKey);
    if (routesJson == null) return [];

    return List<Map<String, dynamic>>.from(
      jsonDecode(routesJson) as List,
    );
  }
}
