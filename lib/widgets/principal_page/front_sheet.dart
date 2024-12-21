//lib/widgets/principal_page/front_sheet.dart
import 'package:flutter/material.dart';

class FrontSheet extends StatelessWidget {
  const FrontSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cartItems = [
      {
        'name': 'Zapatillas',
        'price': 10.0,
        'quantity': 2,
        'image':
            'https://www.cuestamenos.com/media/catalog/product/cache/53eaf647fffc15cddf06d8d79a33a7de/z/a/zapatilla_fashion_estilo_skate_mujer_1306_multicolor_1_.jpg',
      },
      {
        'name': 'Zapatillas',
        'price': 20.0,
        'quantity': 1,
        'image':
            'https://zshopp.com/wp-content/uploads/2024/05/Tenis-Zapatillas-Nike-SB-Unisex-4.jpg',
      },
      {
        'name': 'Zapatillas',
        'price': 20.0,
        'quantity': 1,
        'image':
            'https://res.cloudinary.com/dfzkl8cpg/images/c_scale,w_448,h_299,dpr_2/f_auto,q_auto/v1705666982/Zapatillas-Cryptide/Zapatillas-Cryptide.jpg?_i=AA',
      },
      {
        'name': 'Zapatillas',
        'price': 20.0,
        'quantity': 1,
        'image':
            'https://res.cloudinary.com/dfzkl8cpg/images/c_scale,w_448,h_299,dpr_2/f_auto,q_auto/v1705666982/Zapatillas-Cryptide/Zapatillas-Cryptide.jpg?_i=AA',
      },
      {
        'name': 'Zapatillas',
        'price': 20.0,
        'quantity': 1,
        'image':
            'https://res.cloudinary.com/dfzkl8cpg/images/c_scale,w_448,h_299,dpr_2/f_auto,q_auto/v1705666982/Zapatillas-Cryptide/Zapatillas-Cryptide.jpg?_i=AA',
      },
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 5,
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Column(children: [
                          // Imagen cuadrada
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
                                  subtitle: Text(
                                    'Cantidad: ${item['quantity']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: Text(
                                    '\$${item['price']}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )))
                        ])));
              },
            ),
          ),
        ],
      ),
    );
  }
}
