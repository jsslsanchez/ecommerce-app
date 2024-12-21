import 'package:flutter/material.dart';
import 'package:project_e_commerce/models/product_manager.dart';
import 'package:project_e_commerce/widgets/home_page/fronsheet_home.dart'; // Asegúrate de importar FrontSheetHome

class CashPaymentPage extends StatelessWidget {
  const CashPaymentPage({super.key, required ProductManager productManager});

  @override
  Widget build(BuildContext context) {
    final paymentCode = "CODIGO-${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago en Efectivo'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Usa este código en el punto de pago: ',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              paymentCode,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirigir directamente a FrontSheetHome
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FrontSheetHome(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Generar Código'),
            ),
          ],
        ),
      ),
    );
  }
}
