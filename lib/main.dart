//lib/main.dart
import 'package:flutter/material.dart';
import 'package:project_e_commerce/providers/ui_provider.dart';
import 'package:project_e_commerce/providers/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    as riverpod; // Alias para flutter_riverpod
import 'package:project_e_commerce/config/router/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return riverpod.ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UIProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ],
        child: MaterialApp.router(
          title: 'E Commerce Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.red,
            scaffoldBackgroundColor: Colors.grey.shade100,
          ),
          routerConfig: router, // Usa el router definido en app_router.dart
        ),
      ),
    );
  }
}
