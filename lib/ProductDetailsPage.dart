import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class ProductDetailsPag extends StatefulWidget {
  final String id;

  ProductDetailsPag({required this.id});

  @override
  _ProductDetailsPagState createState() => _ProductDetailsPagState();
}

class _ProductDetailsPagState extends State<ProductDetailsPag> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Category')
          .doc(widget.id)
          .collection('products')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No products found for category ID: ${widget.id}');
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "Name": data['Name'] ?? 'Unnamed',
          "image": data['image'] ?? 'assets/default_image.png',
          "price": (data['price'] as num).toDouble(), // Ensure price is a double
          "quantity": data['quantity'] ?? 0, // Ensure quantity is included
        };
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }

  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('Category')
          .doc(widget.id)
          .collection('products')
          .doc(productId)
          .update({"quantity": newQuantity});
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void addToCart(Map<String, dynamic> product) async {
    final cart = Provider.of<CartModel>(context, listen: false);

    // Add product to cart
    cart.addItem(
      CartItem(
        id: product['id'],
        Name: product['Name'],
        image: product['image'],
        price: product['price'],
      ),
    );

    // Update quantity in Firebase
    final newQuantity = product['quantity'] - 1;
    await updateProductQuantity(product['id'], newQuantity);

    // Update local UI
    setState(() {
      _productsFuture = fetchProducts(); // Refresh product list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['Name']} added to cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      product['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      product['Name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Stock: ${product['quantity']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product['quantity'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: product['quantity'] > 0
                            ? () => addToCart(product)
                            : null, // Disable button if out of stock
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text(
                          product['quantity'] > 0 ? 'Add to Cart' : 'Out of Stock',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
