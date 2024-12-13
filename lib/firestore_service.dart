import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all categories
  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('Category').snapshots();
  }

  // Get all products for a specific category
  Stream<QuerySnapshot> getProducts(String categoryId) {
    return _firestore.collection('Category').doc(categoryId).collection('products').snapshots();
  }

  // Add a new product to a category
  Future<void> addProduct(String categoryId, Map<String, dynamic> productData) async {
    await _firestore.collection('Category').doc(categoryId).collection('products').add(productData);
  }

  // Edit an existing product
  Future<void> editProduct(String categoryId, String productId, Map<String, dynamic> productData) async {
    await _firestore.collection('Category').doc(categoryId).collection('products').doc(productId).update(productData);
  }

  // Delete a product or category
  Future<void> deleteItem(String collection, String id, [String? categoryId]) async {
    if (collection == 'products') {
      await _firestore.collection('Category').doc(categoryId).collection('products').doc(id).delete();
    } else {
      await _firestore.collection('Category').doc(id).delete();
    }
  }
}
