import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart.dart';

class BestRatedProducts extends StatelessWidget {
  final CartModel cart;

  BestRatedProducts({required this.cart});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Best Rated Products'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
    body:FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('feedback') // Fetch products from Firestore
          .orderBy('rating', descending: true) // Sort by rating in descending order
          .limit(5) // Display top 5 best-rated products
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
          return Center(child: Text('No best-rated products available.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Text(
            //   'Best-Rated Products',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final productData = product.data() as Map<String, dynamic>?;

                if (productData == null) {
                  return SizedBox.shrink(); // Skip invalid data
                }

                final String name = productData['productName'] ?? 'Unknown Product';
                final String image = productData['image'] ?? '';
                final double price = productData['price']?.toDouble() ?? 0.0;
                final double rating = productData['rating']?.toDouble() ?? 0.0;

                return Card(
                  child: ListTile(
                    leading: image.isNotEmpty
                        ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\$${price.toStringAsFixed(2)}'),
                        SizedBox(height: 5),
                        Text('Rating: ${rating.toStringAsFixed(1)} ⭐'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final cartItem = CartItem(
                          id: product.id,
                          Name: name,
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
    )
    );
  }
}
