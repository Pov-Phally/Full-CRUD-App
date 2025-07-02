import 'package:flutter/material.dart';
import 'package:full_crud_app/models/products.dart';
import 'package:full_crud_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({super.key});
  @override
  AddEditProductPageState createState() => AddEditProductPageState();
}

class AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late Product _product;
  bool isEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is Product) {
      _product = arg;
      isEdit = true;
    } else {
      _product = Product(name: '', price: 0, stock: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _product.name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _product.name = v!,
              ),
              TextFormField(
                initialValue:
                    _product.price > 0 ? _product.price.toString() : '',
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator:
                    (v) => double.tryParse(v!) == null ? 'Invalid' : null,
                onSaved: (v) => _product.price = double.parse(v!),
              ),
              TextFormField(
                initialValue:
                    _product.stock > 0 ? _product.stock.toString() : '',
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v!) == null ? 'Invalid' : null,
                onSaved: (v) => _product.stock = int.parse(v!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  if (isEdit) {
                    await prov.updateProduct(_product);
                  } else {
                    await prov.addProduct(_product);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}