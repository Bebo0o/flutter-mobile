import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductInfoPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductInfoPage({required this.product});

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  final TextEditingController _feedbackController = TextEditingController();
    double _rating = 0;

  Future<void> submitFeedback() async {
    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'image':widget.product['image'],
        'price':widget.product['price'],
        'productId': widget.product['id'],
        'productName': widget.product['Name'],
        'feedback': _feedbackController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );

      _feedbackController.clear();
      setState(() => _rating = 0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    }
  }

  void openFeedbackDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Submit Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(hintText: 'Enter your feedback'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
             Row (
              mainAxisSize: MainAxisSize.min,  // Align stars horizontally in the center
               children: List.generate(5, (index) {
                return IconButton (
                   icon: Icon(
                    Icons.star,
                     color: index < _rating ? Colors.orange : Colors.grey,  // Update color based on rating
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;  // Update rating when a star is clicked
                    });
                  },
                  padding: EdgeInsets.zero,  // Remove any extra padding from IconButton
                  constraints: BoxConstraints(),  // Avoid any constraints that affect layout
                );
              }),
            ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                submitFeedback();
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['Name']),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.product['image'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.product['Name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${widget.product['price']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Available Stock: ${widget.product['quantity']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Description: ${widget.product['Description']}',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: openFeedbackDialog,
                icon: Icon(Icons.feedback),
                label: Text('Give Feedback'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
