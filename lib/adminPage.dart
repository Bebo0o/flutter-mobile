import 'package:app/admin.dart';
import 'package:app/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllOrdersPage extends StatelessWidget {
  // Function to delete an order
  Future<void> _deleteOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Function to cancel an order by updating the status
  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'Cancelled',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order cancelled successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Function to mark an order as delivered (Dune Order)
  Future<void> _duneOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'Delivered',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order marked as delivered')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Function to clear all orders (delete all orders from Firestore)
  Future<void> _clearAllOrders(BuildContext context) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final ordersSnapshot = await FirebaseFirestore.instance.collection('orders').get();

      for (var doc in ordersSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All orders cleared successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Orders'),backgroundColor: Colors.teal,

      actions: [
        IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // You can navigate to the cart page, for example:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()), // Replace with your cart page widget
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              // You can navigate to the cart page, for example:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportPage()), // Replace with your cart page widget
              );
            },
          ),
          ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final userName = order['userId'];
              final totalPrice = order['totalPrice'];
              final status = order['status'];
              final products = order['products'] as List;
             // final email=order['email'];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text('Order ID: ${orders[index].id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: $userName'),
                     
                      Text('Products:'),
                      for (var product in products)
                        Text(
                          '${product['Name']} (x${product['quantity']}) - \$${(product['price'] * product['quantity']).toStringAsFixed(2)}',
                        ),
                         Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                      Text('Status: $status'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteOrder(context, orders[index].id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.orange),
                        onPressed: () {
                          _cancelOrder(context, orders[index].id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check_box, color: Colors.green),
                        onPressed: () {
                          _duneOrder(context, orders[index].id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _clearAllOrders(context),
        child: Icon(Icons.delete_sweep),
        backgroundColor: Colors.red,
      ),
    );
  }
}
