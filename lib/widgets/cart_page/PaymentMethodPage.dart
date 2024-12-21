import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/cart_page/pay_pal_page.dart';
import 'package:project_e_commerce/widgets/cart_page/cash_payment_page.dart';
import 'package:project_e_commerce/widgets/cart_page/credit_card_page.dart';

class PaymentMethodPage extends StatelessWidget {
  final ProductManager productManager;

  const PaymentMethodPage({super.key, required this.productManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de Pago'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Métodos de pago
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.credit_card), // Icono para tarjeta de crédito
                  title: const Text('Tarjeta de Crédito'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreditCardPage(productManager: productManager),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment), // Icono para PayPal
                  title: const Text('PayPal'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayPalPage(productManager: productManager),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money_off), // Icono para Efectivo
                  title: const Text('Efectivo'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashPaymentPage(productManager: productManager),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
