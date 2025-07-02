import 'package:flutter/material.dart';
import 'package:full_crud_app/providers/products_provider.dart';
import 'package:full_crud_app/screens/add_edit_screen.dart';
import 'package:full_crud_app/screens/products_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product CRUD',
        routes: {
          '/': (_) => ProductsScreen(),
          '/add': (_) => AddEditProductPage(),
        },
      ),
    ),
  );
}