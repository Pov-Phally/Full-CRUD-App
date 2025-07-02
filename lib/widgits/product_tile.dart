import 'package:flutter/material.dart';
import 'package:full_crud_app/models/products.dart';
import 'package:full_crud_app/providers/products_provider.dart';
import 'package:provider/provider.dart'; // Import provider packag

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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Product'),
                    content: Text('Are you sure you want to delete ${product.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Assuming you have a method in your provider to delete the product
                          context.read<ProductProvider>().deleteProduct(product.id);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Delete Product',
          ),
        ],
      ),
    );
  }
}