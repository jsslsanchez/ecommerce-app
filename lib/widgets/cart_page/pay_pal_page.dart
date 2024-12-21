import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/home_page/fronsheet_home.dart'; // Asegúrate de importar FrontSheetHome

class PayPalPage extends StatefulWidget {
  final ProductManager productManager;

  const PayPalPage({super.key, required this.productManager});

  @override
  _PayPalPageState createState() => _PayPalPageState();
}

class _PayPalPageState extends State<PayPalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago con PayPal'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Nombre Completo
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre completo';
                  }
                  return null; // Nombre válido
                },
              ),
              // Campo de Correo Electrónico de PayPal
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico de PayPal',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null; // Correo válido
                },
              ),
              const SizedBox(height: 20),
              // Botón "Realizar Pago"
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Mostrar mensaje de pago completado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pago con PayPal completado'),
                      ),
                    );

                    // Vaciar el carrito después del pago
                    widget.productManager.clearCart();

                    // Regresar a FrontSheetHome después del pago
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FrontSheetHome(),
                      ),
                      (route) => false, // Remueve todas las rutas previas
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
}
