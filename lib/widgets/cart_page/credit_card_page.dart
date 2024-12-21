import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/home_page/fronsheet_home.dart'; // Asegúrate de importar FrontSheetHome

class CreditCardPage extends StatefulWidget {
  final ProductManager productManager;

  const CreditCardPage({super.key, required this.productManager});

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago con Tarjeta de Crédito'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Número de tarjeta
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número de tarjeta';
                  }
                  if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                    return 'Por favor ingresa un número de tarjeta válido';
                  }
                  return null;
                },
              ),
              // Nombre en la tarjeta
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre en la tarjeta',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre en la tarjeta';
                  }
                  return null;
                },
              ),
              // Fecha de vencimiento
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de vencimiento (MM/AA)',
                  prefixIcon: Icon(Icons.date_range),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha de vencimiento';
                  }
                  if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                    return 'Por favor ingresa una fecha válida en formato MM/AA';
                  }
                  return null;
                },
              ),
              // CVV
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: Icon(Icons.security),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el CVV';
                  }
                  if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
                    return 'Por favor ingresa un CVV válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Botón "Realizar Pago"
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Realizar el pago
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pago con tarjeta completado'),
                      ),
                    );

                    // Vaciar el carrito después del pago y descontar productos
                    widget.productManager.clearCart(); // Limpiar el carrito
                    await _updateProductInventory();

                    // Regresar a FrontSheetHome después del pago
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FrontSheetHome(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Realizar Pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para actualizar el inventario después de realizar el pago
  Future<void> _updateProductInventory() async {
    final cartItems = widget.productManager.getCart();

    for (var item in cartItems) {
      final productId = item['id'];
      final cartQuantity = item['quantity'];

      final productIndex = widget.productManager.getProducts()
          .indexWhere((prod) => prod['id'] == productId);
      if (productIndex >= 0) {
        widget.productManager.getProducts()[productIndex]['quantity'] -= cartQuantity;
      }
    }

    await widget.productManager.saveProducts();
  }
}
