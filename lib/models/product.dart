// lib/models/product.dart
class Product {
  final int? id; // Cambiado a nullable
  final String name;
  final String category;
  final String image;
  final String description;
  final double price;
  int quantity;

  Product({
    this.id, // Acepta id como nullable
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
    required this.quantity,
  }) {
    // Validaciones
    if (price < 0) throw ArgumentError('El precio no puede ser negativo');
    if (quantity < 0) throw ArgumentError('La cantidad no puede ser negativa');
  }

  // Método para convertir a un mapa (para base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'image': image,
      'quantity': quantity,
    };
  }

  // Método para crear un producto desde un mapa
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      description: map['description'],
      image: map['image'],
      quantity: map['quantity'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, price: $price, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}
