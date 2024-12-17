import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Feedback'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ProductFeedbackList(),
    );
  }
}

class ProductFeedbackList extends StatelessWidget {
  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products'); // New reference for products

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: feedbackCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final feedbackDocs = snapshot.data?.docs ?? [];
        if (feedbackDocs.isEmpty) {
          return Center(child: Text('No feedback available.'));
        }

        // Group feedback by productId
        Map<String, List<Map<String, dynamic>>> productFeedback = {};

        for (var doc in feedbackDocs) {
          final data = doc.data() as Map<String, dynamic>;
          String productId = data['productId'] ?? 'unknown';
          if (!productFeedback.containsKey(productId)) {
            productFeedback[productId] = [];
          }
          productFeedback[productId]!.add(data);
        }

        // Build UI for each product
        return ListView(
          children: productFeedback.entries.map((entry) {
            final productId = entry.key;
            final feedbackList = entry.value;

            // Calculate average rating
            double totalRating = 0;
            int count = 0;

            for (var feedback in feedbackList) {
              if (feedback['rating'] != null) {
                totalRating += (feedback['rating'] as num).toDouble();
                count++;
              }
            }

            double averageRating = count > 0 ? totalRating / count : 0.0;

            // Update the product document with the new average rating
            updateAverageRating(productId, averageRating);

            String productName = feedbackList.first['productName'] ?? 'Unknown Product';
            String productImage = feedbackList.first['productImage'] ?? '';  // Add image field here

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ExpansionTile(
                leading: productImage.isNotEmpty
                    ? Image.network(productImage, width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.shopping_bag, color: Colors.teal,),
                title: Text(productName),
                subtitle: Text(
                  'Average Rating: ${averageRating.toStringAsFixed(1)} ⭐',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: feedbackList.map((feedback) {
                  return ListTile(
                    leading: feedback['image'] != null
                        ? Image.network(feedback['image'], width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(feedback['feedback'] ?? 'No message'),
                    trailing: Text('${feedback['rating']?.toString() ?? '0'} ⭐'),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Function to update the average rating in the Firestore product document
  void updateAverageRating(String productId, double averageRating) {
    final productDoc = productCollection.doc(productId);

    productDoc.update({
      'averageRating': averageRating,
    }).catchError((error) {
      print('Error updating average rating: $error');
    });
  }
}
