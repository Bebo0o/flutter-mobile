// lib/models/category.dart
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String Name;
  final String image;

  Category({
    required this.id,
    required this.Name,
    required this.image, 
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      Name: data['Name'] ?? 'Unnamed Category',
      image: data['image'] ?? 'assets/default_image.png',
    );
  }
}


Future<void> getAllDocuments() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('Category').get();

  for (var doc in querySnapshot.docs) {
    print('Document ID: ${doc.id}');
    print('Data: ${doc.data()}');
  }
}


Future<List<Map<String, dynamic>>> fetchCategories() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('Category').get();

  return querySnapshot.docs.map((doc) {
    return {
      "id": doc.id, // Firestore document ID
      "image": doc['image'], // Image URL field
    };
  }).toList();
}
