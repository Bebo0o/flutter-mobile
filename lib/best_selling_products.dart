import 'package:app/cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
//import 'cart_model.dart'; // Import CartModel from your existing code

class BestSellingProducts extends StatelessWidget {
  final CartModel cart;

  BestSellingProducts({required this.cart});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('orders') // Fetch best-selling products from Firestore
          .orderBy('products', descending: true) // Assuming you track sales count
          .limit(5) // Display top 5 best-selling products
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data?.docs ?? [];
        if (products.isEmpty) {
          return Center(child: Text('No best-selling products available.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best-Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final productData = product.data() as Map<String, dynamic>?;

                // Check for null safety
                if (productData == null) {
                  return SizedBox.shrink();
                }

                final String Name = productData['Name'] ?? 'Unknown Product';
                final String image = productData['image'] ?? '';
                final double price = productData['price']?.toDouble() ?? 0.0;

                return Card(
                  child: ListTile(
                    leading: image.isNotEmpty
                        ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(Name),
                    subtitle: Text('\$${price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final cartItem = CartItem(
                          id: product.id,
                          Name: Name,
                          image: image,
                          price: price,
                        );
                        cart.addItem(cartItem);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
