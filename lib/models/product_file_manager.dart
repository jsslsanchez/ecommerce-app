// lib/models/product_file_manager.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProductFileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/products.json');
  }

  final List<Map<String, dynamic>> defaultProducts = [
    {
      'name': 'Cadena_oro_24k',
      'price': 150.5,
      'quantity': 2,
      'image':
          'https://res.cloudinary.com/dp6uo6fcb/image/upload/v1726450685/jtvegnct84vkszy6aevp.jpg',
    },
    {
      'name': 'Reloj',
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
  ];

  Future<void> writeProducts(List<Map<String, dynamic>> products) async {
    final file = await _localFile;
    String jsonString = jsonEncode(products);
    await file.writeAsString(jsonString);
  }

  Future<List<Map<String, dynamic>>> readProducts() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        List<dynamic> jsonResponse = jsonDecode(jsonString);
        return jsonResponse
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        await writeProducts(defaultProducts);
        return defaultProducts;
      }
    } catch (e) {
      return []; // Retornar una lista vacía si hay un error
    }
  }
}
