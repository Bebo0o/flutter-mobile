import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static Future<void> addProduct(String categoryId, String name, double price, int quantity, String imageUrl, String description) async {
    final productData = {
      'Name': name,
      'price': price,
      'quantity': quantity,
      'image': imageUrl,
      'Description': description,
    };

    await FirebaseFirestore.instance
        .collection('Category')
        .doc(categoryId)
        .collection('products')
        .add(productData);
  }

  static Map<String, dynamic> createProductData(String name, double price, int quantity, String imageUrl, String description) {
    return {
      'Name': name,
      'price': price,
      'quantity': quantity,
      'image': imageUrl,
      'Description': description,
    };
  }
}
