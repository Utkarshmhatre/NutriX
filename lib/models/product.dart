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