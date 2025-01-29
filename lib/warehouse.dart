class Warehouse {
  int? id;
  String name;
  String location;
  int capacity;
  List<Product> products;

  Warehouse(
      {this.id,
      required this.name,
      required this.location,
      required this.capacity,
      this.products = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'capacity': capacity,
    };
  }

  static Warehouse fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      capacity: map['capacity'] as int? ?? 0,
    );
  }
}

class Product {
  int? id;
  int warehouseId;
  String name;
  String description;
  double price;
  int quantity;
  String status;
  String imageUrl;

  Product({
    this.id,
    required this.warehouseId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.status = 'Pending',
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'warehouse_id': warehouseId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'status': status,
      'image_url': imageUrl,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      warehouseId: map['warehouse_id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] as int? ?? 0,
      status: map['status'] as String? ?? 'Pending',
      imageUrl: map['image_url'] as String? ?? '',
    );
  }
}
