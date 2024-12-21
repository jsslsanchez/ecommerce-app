import 'package:flutter/material.dart';
import 'package:project_e_commerce/widgets/shopping_cart_page/front_sheet.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key, });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: const FrontSheet(),
    );
  }
}
