import 'package:app/best_selling_products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.teal,
        actions: [
        IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              // You can navigate to the cart page, for example:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BestRatedProducts(cart: cart,)), // Replace with your cart page widget
              );
            },
          ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(child: Text('Your cart is empty!', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemWidget(item: item, cart: cart);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Order Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            _submitOrder(context, cart);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.teal,
                        ),
                        child: Text('Submit Order', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _submitOrder(BuildContext context, CartModel cart) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to place an order.')));
    return;
  }

  try {
    if (cart.items.isEmpty) {
      throw Exception("Cart is empty!");
    }

    // Mapping cart items to orderProducts
    final orderProducts = cart.items.map((item) {
      return {
        'products': item.id,
        'Name': item.Name,
        'image': item.image,
        'price': item.price,
        'quantity': item.quantity,
      };
    }).toList();

    final orderData = {
      'userId': user.uid,
      'products': orderProducts,
      'totalPrice': cart.totalPrice,
      'orderDate': FieldValue.serverTimestamp(),
    };

    // Add order data to Firestore
    await FirebaseFirestore.instance.collection('orders').add(orderData);

    // Update product quantities in Firestore
    for (var item in cart.items) {
      // Assuming categoryId is part of the product data, you might need to get it from your data model
      final categoryId = item.id; // You need to get the categoryId for each product

      final productRef = FirebaseFirestore.instance
          .collection('categories') // Access the categories collection
          .doc(categoryId) // Get the specific category document
          .collection('products') // Access the 'products' subcollection
          .doc(item.id); // Access the product document

      // Check if the product exists before updating
      final productDoc = await productRef.get();
      if (productDoc.exists) {
        await productRef.update({
          'quantity': FieldValue.increment(-item.quantity),
        });
      } else {
        // Handle the case where the product doesn't exist
        print('Product with ID ${item.id} does not exist in category $categoryId.');
      }
    }

    // Show order confirmation dialog
    _showSubmittedOrderDialog(
      context,
      orderProducts,
      cart.totalPrice,
    );

    // Clear the cart after successful order submission
    cart.clearCart();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit order: $e')));
  }
}
  void _showSubmittedOrderDialog(
      BuildContext context, List<Map<String, dynamic>> products, double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Image.network(
                          product['image'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('${product['Name']} (x${product['quantity']})'),
                        ),
                        Text('\$${(product['price'] * product['quantity']).toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 10),
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class CartModel with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
        0.0,
        (total, item) => total + (item.price * item.quantity),
      );

  void addItem(CartItem item) {
    final index = _items.indexWhere((existingItem) => existingItem.id == item.id);

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    if (newQuantity > 0) {
      final item = _items.firstWhere((item) => item.id == id);
      item.quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String Name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.Name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final CartModel cart;

  CartItemWidget({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(item.Name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${item.price.toStringAsFixed(2)}'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: item.quantity > 1
                      ? () => cart.updateQuantity(item.id, item.quantity - 1)
                      : null,
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () => cart.updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => cart.removeItem(item.id),
        ),
      ),
    );
  }
}
