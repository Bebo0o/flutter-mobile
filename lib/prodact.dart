import 'package:cloud_firestore/cloud_firestore.dart';

class products {
  final String id;
  final String Name;
  final String image;

  products({
    required this.id,
    required this.Name,
    required this.image,
  });

  factory products.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return products(
      id: doc.id,
      Name: data['Name'] ?? 'Unnamed products',
      image: data['image'] ?? 'assets/default_image.png',
    );
  }
}


Future<void> getAllDocuments() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('products').get();

  for (var doc in querySnapshot.docs) {
    print('Document ID: ${doc.id}');
    print('Data: ${doc.data()}');
  }
}


Future<List<Map<String, dynamic>>> fetchCategories() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('products').get();

  return querySnapshot.docs.map((doc) {
    return {
      "id": doc.id, // Firestore document ID
      "image": doc['image'], // Image URL field
    };
  }).toList();
}
