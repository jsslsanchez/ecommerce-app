// lib/models/product_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e_commerce/models/category_model.dart';

class ProductManager {
  List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _cart =
      []; // Lista para los productos en el carrito
  final List<CategoryModel> _categories =
      []; // Lista de categorías de productos
  List<Map<String, dynamic>> _filteredProducts = [];

  List<Map<String, dynamic>> getFilteredProducts() {
    return _filteredProducts.isEmpty ? _products : _filteredProducts;
  }

  void setFilteredProducts(List<Map<String, dynamic>> products) {
    _filteredProducts = products;
  }

  // Getter para obtener los productos en el carrito
  List<Map<String, dynamic>> getCart() {
    print("aqui esta cart: $_cart");
    return _cart;
  }

  // Obtener la cantidad total de artículos en el carrito
  int getCartItemCount() {
    return _cart
        .fold(0, (sum, item) => sum + (item['quantity'] as int))
        .toInt();
  }

  // Cargar productos desde SharedPreferences
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJson = prefs.getString('products');

    if (productsJson != null) {
      final List<dynamic> decodedProducts = json.decode(productsJson);
      _products = List<Map<String, dynamic>>.from(decodedProducts);
    } else {
      // Si no hay productos guardados, agregamos algunos productos por defecto
      _products = [
        {
          'id': 1, // ID único para el producto
          'name': 'Cadena de oro 24k',
          'price': 150.5,
          'quantity': 2,
          'image':
              'https://res.cloudinary.com/dp6uo6fcb/image/upload/v1726450685/jtvegnct84vkszy6aevp.jpg',
          'categoryIndex': 0, // Categoría
        },
        {
          'id': 2,
          'name': 'Reloj de pulsera',
          'price': 80.0,
          'quantity': 3,
          'image': 'https://example.com/clock_image.jpg',
          'categoryIndex': 1,
        },
      ];
    }
  }

  // Cargar categorías desde SharedPreferences
  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesJson = prefs.getString('categories');

    if (categoriesJson != null) {
      final List<dynamic> decodedCategories = json.decode(categoriesJson);
      _categories
          .clear(); // Limpiar la lista antes de agregar nuevas categorías
      _categories.addAll(decodedCategories
          .map((data) => CategoryModel(
                name: data['name'],
                icon: data['icon'],
              ))
          .toList());
    }
  }

  // Agregar un producto al carrito con validación para la cantidad
  void addToCart(int productId) {
    final product = _products.firstWhere(
      (item) => item['id'] == productId,
      orElse: () => {},
    );

    if (product.isNotEmpty) {
      final cartItemIndex = _cart.indexWhere((item) => item['id'] == productId);

      if (cartItemIndex >= 0) {
        // Verificar si hay suficiente cantidad en el inventario
        int availableQuantity = product['quantity'];
        int cartQuantity = _cart[cartItemIndex]['quantity'];

        if (availableQuantity > cartQuantity) {
          // Si hay suficiente cantidad en el inventario, incrementar la cantidad en el carrito
          _cart[cartItemIndex]['quantity'] += 1;
        } else {
          // Si no hay suficiente cantidad, mostrar un mensaje de error
          print(
              'No hay suficiente cantidad de ${product['name']} en inventario');
          return; // No agregar más producto al carrito
        }
      } else {
        // Si no está en el carrito, lo agregamos con una cantidad inicial de 1
        _cart.add({
          ...product,
          'quantity': 1, // Inicializamos con cantidad 1
        });
      }

      saveCart(); // Guardamos los cambios en el carrito en SharedPreferences
    }
  }

  // Eliminar un producto del carrito
  void removeFromCart(int productId) {
    _cart.removeWhere((item) => item['id'] == productId);
    saveCart(); // Guardamos los cambios después de eliminar un producto
  }

  // Guardar productos en SharedPreferences
  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String productsJson = json.encode(_products);
    await prefs.setString('products', productsJson);
  }

  // Guardar categorías en SharedPreferences
  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String categoriesJson = json.encode(_categories
        .map((category) => {
              'name': category.name,
              'icon': category.icon,
            })
        .toList());
    await prefs.setString('categories', categoriesJson);
  }

  // Getter para obtener los productos
  List<Map<String, dynamic>> getProducts() {
    return _products;
  }

  // Guardar carrito en SharedPreferences
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartJson = json.encode(_cart);
    await prefs.setString('cart', cartJson);
  }

  // Método para agregar una categoría
  void addCategory(String name, String icon) {
    _categories.add(CategoryModel(name: name, icon: icon));
    saveCategories();
  }

  // Método para eliminar una categoría
  void deleteCategory(int index) {
    if (index >= 0 && index < _categories.length) {
      _categories.removeAt(index);
      saveCategories();
    }
  }

  // Método para actualizar una categoría
  void updateCategory(int index, String name, String icon) {
    if (index >= 0 && index < _categories.length) {
      _categories[index] = CategoryModel(name: name, icon: icon);
      saveCategories();
    }
  }

  // Obtener una categoría por índice
  CategoryModel? getCategory(int index) {
    if (index >= 0 && index < _categories.length) {
      return _categories[index];
    }
    return null;
  }

  // Método para agregar un nuevo producto
  Future<void> addProduct(String name, double price, int quantity, String image,
      int categoryIndex) async {
    final category =
        getCategoryName(categoryIndex); // Obtener el nombre de la categoría
    final newProduct = {
      'id': _products.length + 1, // Generar un ID único
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'category': category, // Guardar el nombre de la categoría
    };
    _products.add(newProduct);
    await saveProducts(); // Guardar los productos después de agregar uno nuevo
  }

  // Actualizar un producto en la lista de productos
  void updateProduct(int index, String name, double price, int quantity,
      String image, int categoryIndex) {
    if (index < _products.length) {
      _products[index] = {
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
        'categoryIndex': categoryIndex,
      };
      saveProducts();
    }
  }

  // Eliminar un producto
  void deleteProduct(int index) {
    if (index < _products.length) {
      _products.removeAt(index);
      saveProducts();
    }
  }

  // Obtener lista de categorías
  List<CategoryModel> getCategories() {
    return _categories;
  }

  // Limpiar el carrito (por ejemplo, al finalizar la compra)
  void clearCart() {
    _cart.clear();
    saveCart();
  }

  String? getCategoryName(int? index) {
    if (index != null && index >= 0 && index < _categories.length) {
      return _categories[index].name;
    }
    return null; // Devuelve null si no hay categoría válida
  }
}
