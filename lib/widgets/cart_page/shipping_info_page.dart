import 'package:flutter/material.dart';
import 'package:project_e_commerce/widgets/cart_page/PaymentMethodPage.dart';
import 'package:project_e_commerce/models/product_manager.dart';

class ShippingInfoPage extends StatefulWidget {
  final ProductManager productManager; // Aceptamos el productManager como parámetro

  const ShippingInfoPage({super.key, required this.productManager});

  @override
  _ShippingInfoPageState createState() => _ShippingInfoPageState();
}

class _ShippingInfoPageState extends State<ShippingInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Envío'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Dirección
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu dirección';
                  }
                  return null; // Dirección válida
                },
              ),
              // Campo de Teléfono
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu número de teléfono';
                  }
                  // Verifica que el teléfono contenga solo números y tenga 10 dígitos
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'El número de teléfono debe ser solo numérico';
                  }
                  if (value.length != 10) {
                    return 'El número de teléfono debe tener 10 dígitos';
                  }
                  return null; // Teléfono válido
                },
              ),
              // Campo de Correo Electrónico
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
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
              // Campo de Descripción (Opcional)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                // Este campo no necesita validación porque es opcional
              ),
              const SizedBox(height: 20),
              // Botón "Siguiente"
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Si el formulario es válido, navega a la siguiente página
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(
                          productManager: widget.productManager, // Pasamos el productManager
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
