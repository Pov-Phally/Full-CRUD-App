class Product {
  final int id;
  String name;
  double price;
  int stock;

  Product({
    this.id = 0,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['PRODUCTID'],
    name: json['PRODUCTNAME'],
    price: (json['PRICE'] as num).toDouble(),
    stock: json['STOCK'],
  );

  Map<String, dynamic> toJson() => {
    'productName': name,
    'price': price,
    'stock': stock,
  };
}