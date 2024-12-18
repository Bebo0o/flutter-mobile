// import 'package:app/feedback_page.dart';
import 'package:app/prodact_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
//import 'product_info_page.dart';  // Make sure to import the ProductInfoPage

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
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Category')
        .doc(widget.id)
        .collection('products')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "Name": data['Name'] ?? 'Unnamed',
        "image": data['image'] ?? '',
        "price": (data['price'] as num).toDouble(),
        "quantity": data['quantity'] ?? 0,
        "Description":data['Description']??'',
      };
    }).toList();
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

  void addToCart(Map<String, dynamic> product)  async{
    final cart = Provider.of<CartModel>(context, listen: false);

    if (product['quantity'] > 0) {
      cart.addItem(
        CartItem(
          id: product['id'],
          Name: product['Name'],
          image: product['image'],
          price: product['price'],
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['Name']} added to cart!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['Name']} is out of stock!'),
        ),
      );
    }
    final newQuantity = product['quantity'] - 1;
    await updateProductQuantity(product['id'], newQuantity);

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
              childAspectRatio: 0.9, 
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductInfoPage(product: product,),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
    
                child: Column(
                   children: [
                    SizedBox(height: 15),
                    ClipRRect(
                      
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        product['image'],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
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
                    Row(children: [
                      SizedBox(width: 15),
                      Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: Colors.teal),
                      ),
                      SizedBox(width: 110),
                    Text(
                      product['quantity'] > 0
                          ? 'Stock: ${product['quantity']}'
                          : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 12,
                        color: product['quantity'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    ]
                    ),
                    // ProductRatingWidget(productId: 'product',),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: product['quantity'] > 0
                          ? () => addToCart(product)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        product['quantity'] > 0 ? 'Add to Cart' : 'Out of Stock',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // SizedBox(height: 8),
                    // // Navigate to product info page
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ProductInfoPage(product: product,),
                    //       ),
                    //     );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     'View Details',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                  ],
                                
                 ),
              ),
              );
                
              
            },
          );
        },
      ),
    );
  }
}

