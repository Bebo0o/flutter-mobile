// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductInfoPage extends StatelessWidget {
//   final String id;
//   final String products;
//    final String description;


//   ProductInfoPage({ required this.id,required this.products,required this.description});

//   Future<Map<String, dynamic>> fetchProductDetails() async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('Category') // Main collection
//           .doc(id) // Category document
//           .collection('products') // Subcollection
//           .doc(products)
//           .collection('description') // Product document
//           .doc(description)
//           .get();

//       if (!doc.exists) {
//         throw Exception('Product not found');
//       }

//       return doc.data()!;
//     } catch (e) {
//       throw Exception('Error fetching product details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Info'),
//         backgroundColor: Colors.teal,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: fetchProductDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No product details available.'));
//           }

//           // Product data
//           final product = snapshot.data!;
//           final name = product['Name'] ?? 'Unnamed Product';
//           final image = product['image'] ?? 'assets/default_image.png';
//           final price = product['price'] ?? 'Not available';
//           final description = product['description'] ?? 'No description provided.';

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Image
//                 Center(
//                   child: Image.network(
//                     image,
//                     height: 250,
//                     width: 250,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // Product Name
//                 Text(
//                   name,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 // Product Price
//                 Text(
//                   'Price: \$${price.toString()}',
//                   style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 16),
//                 // Product Description
//                 Text(
//                   'Description',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 ),
//                 Spacer(),
//                 // Add to Cart Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Add "Add to Cart" functionality here
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('$name added to cart!')),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                     ),
//                     child: Text(
//                       'Add to Cart',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
