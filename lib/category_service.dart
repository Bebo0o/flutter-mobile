import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  static Future<void> addCategory(String name, String description, String imageUrl) async {
    final categoryData = {
      'Name': name,
      'Description': description,
      'image': imageUrl,
    };

    await FirebaseFirestore.instance.collection('Category').add(categoryData);
  }

  static Map<String, dynamic> createCategoryData(String name, String description, String imageUrl) {
    return {
      'Name': name,
      'Description': description,
      'image': imageUrl,
    };
  }
}
