//lib/widgets/home_page/frontsheet_home.dart
import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/cart_page/cart_sheet.dart'; // Importamos la nueva pantalla del carrito
import 'package:project_e_commerce/widgets/alphanumeric_keypad';

class FrontSheetHome extends StatefulWidget {
  const FrontSheetHome({super.key});

  @override
  _FrontSheetHomeState createState() => _FrontSheetHomeState();
}

class _FrontSheetHomeState extends State<FrontSheetHome> {
  final TextEditingController _searchController = TextEditingController();
  final ProductManager productManager = ProductManager();
  bool _showKeypad = false;

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Cargar productos al iniciar el widget
  }

  Future<void> _loadProducts() async {
    await productManager.loadProducts();
    setState(() {}); // Actualizar la UI después de cargar los productos
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleKeyPress(String key) {
    setState(() {
      if (key == 'Del') {
        _searchController.text = _searchController.text.isNotEmpty
            ? _searchController.text
                .substring(0, _searchController.text.length - 1)
            : '';
      } else {
        _searchController.text += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = productManager.getFilteredProducts().isEmpty
        ? productManager.getProducts()
        : productManager.getFilteredProducts();
    // Obtenemos el conteo actualizado del carrito
    final cartCount = productManager.getCart().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navegar a la pantalla del carrito
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartSheet(productManager: productManager),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '$cartCount', // Mostramos el conteo de productos en el carrito
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Buscar...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      final filteredProducts =
                          productManager.getProducts().where((product) {
                        final name = product['name'].toLowerCase();
                        return name.contains(value.toLowerCase());
                      }).toList();
                      setState(() {
                        productManager.setFilteredProducts(filteredProducts);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _showKeypad = !_showKeypad;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty // Verificar si hay productos disponibles
                ? const Center(child: Text('No hay productos disponibles.'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 5,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Precio: \$${item['price']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Cantidad: ${item['quantity']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      if (item.containsKey('category') &&
                                          item['category']
                                              .isNotEmpty) // Verificar si tiene categoría
                                        Text(
                                          'Categoría: ${item['category']}',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      productManager.addToCart(item['id']);
                                      setState(() {});
                                      // Navegar directamente a la interfaz del carrito
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartSheet(
                                              productManager: productManager),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Offstage(
            offstage: !_showKeypad,
            child: AlphanumericKeypad(
                onKeyPressed:
                    _handleKeyPress), // Aquí es donde se muestra el teclado
          ),
        ],
      ),
    );
  }
}
