import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get categories
  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('Category').snapshots();
  }

  // Method to get products by category ID
  Stream<QuerySnapshot> getProducts(String categoryId) {
    return _firestore
        .collection('Category')
        .doc(categoryId)
        .collection('products')
        .snapshots();
  }

  // Method to add a new category
  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    try {
      await _firestore.collection('Category').add(categoryData);
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  // Method to add a new product
  Future<void> addProduct(String categoryId, Map<String, dynamic> productData) async {
    try {
      await _firestore.collection('Category').doc(categoryId).collection('products').add(productData);
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Method to edit a product
  Future<void> editProduct(String categoryId, String productId, Map<String, dynamic> updatedProductData) async {
    try {
      await _firestore.collection('Category').doc(categoryId).collection('products').doc(productId).update(updatedProductData);
    } catch (e) {
      print('Error editing product: $e');
    }
  }

  // Method to delete an item (category or product)
  Future<void> deleteItem(String collection, String itemId, [String? categoryId]) async {
    try {
      if (collection == 'products' && categoryId != null) {
        await _firestore.collection('Category').doc(categoryId).collection('products').doc(itemId).delete();
      } else {
        await _firestore.collection(collection).doc(itemId).delete();
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}
