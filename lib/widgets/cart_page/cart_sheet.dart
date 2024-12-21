import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/cart_page/shipping_info_page.dart'; // Importa ShippingInfoPage

class CartSheet extends StatelessWidget {
  final ProductManager productManager;

  const CartSheet({super.key, required this.productManager});

  @override
  Widget build(BuildContext context) {
    final cartItems = productManager.getCart();

    // Calcular el total de la compra
    double totalPrice = 0;
    for (var item in cartItems) {
      final price = item['price'];
      final quantity = item['quantity'];

      // Aseguramos que price y quantity sean válidos
      if (price != null && quantity != null) {
        totalPrice += price * quantity;
      } else {
        print("Error: El precio o la cantidad no son válidos para el artículo ${item['name']}");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        backgroundColor: Colors.red,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Tu carrito está vacío'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Cantidad: ${item['quantity']}'),
                          trailing: Text(
                            '\$${item['price'] * item['quantity']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Mostrar el total de la compra
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Botón de confirmación de compra
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Actualizar la cantidad de productos en el inventario
                      for (var item in cartItems) {
                        final productId = item['id'];
                        final cartQuantity = item['quantity'];

                        // Encontramos el producto en el inventario y actualizamos su cantidad
                        final productIndex = productManager.getProducts().indexWhere((prod) => prod['id'] == productId);
                        if (productIndex >= 0) {
                          productManager.getProducts()[productIndex]['quantity'] -= cartQuantity;
                        }
                      }

                      // Limpiar el carrito
                      productManager.clearCart();
                      
                      // Mostrar un mensaje de confirmación
              

                      // Navegar a la pantalla de información de envío
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShippingInfoPage(
                            productManager: productManager, // Pasamos productManager
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Confirmar Compra'),
                  ),
                ),
              ],
            ),
    );
  }
}
