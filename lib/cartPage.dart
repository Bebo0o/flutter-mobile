import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// import 'package:provider/provider.dart';
// import 'cart.dart';

class ProductPage extends StatelessWidget {
  final String email;
  final String Name;
  final String image;
  final double price;

  ProductPage({
    required this.email,
    required this.Name,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Name),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(image, height: 200, width: 200, fit: BoxFit.cover),
          SizedBox(height: 16),
          Text(
            Name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Provider.of<CartModel>(context, listen: false).addItem(
              //   CartItem(id: id, name: name, image: image, price: double.parse(product['price']),),
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$Name added to cart!')),
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
