import 'package:flutter/material.dart';
import 'package:full_crud_app/models/products.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Price: \$${product.price}, Stock: ${product.stock}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/add', arguments: product);
            },
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Add delete functionality here
            },
            tooltip: 'Delete Product',
          ),
        ],
      ),
    );
  }
}