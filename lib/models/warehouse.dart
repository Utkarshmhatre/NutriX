import 'product.dart';

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