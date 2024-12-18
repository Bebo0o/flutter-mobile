import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_edit_dialog.dart';
import 'firestore_service.dart';
//import 'category_service.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _activeCollection = 'Category';
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.teal,
        actions: [
          DropdownButton<String>(
            value: _activeCollection,
            items: [
              DropdownMenuItem(value: 'Category', child: Text('Category')),
              DropdownMenuItem(value: 'products', child: Text('Products')),
            ],
            onChanged: (value) {
              setState(() {
                _activeCollection = value!;
                if (_activeCollection == 'Category') _selectedCategoryId = null;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getCategories(),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final categories = categorySnapshot.data?.docs ?? [];
          if (_activeCollection == 'Category') {
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(category['Name']),
                    subtitle: Text(category['Description']),
                    trailing: IconButton(
                      icon: Icon(Icons.view_list, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _selectedCategoryId = category.id;
                          _activeCollection = 'products';
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getProducts(_selectedCategoryId!),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final products = productSnapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      leading: Image.network(
                        product['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['Name']),
                      subtitle: Text('Price: \$${product['price']} Quantity: ${product['quantity']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AddEditDialog(
                                id: product.id,
                                name: product['Name'],
                                price: product['price'],
                                quantity: product['quantity'],
                                image: product['image'],
                                description: product['Description'],
                                onSave: (productData) {
                                  FirestoreService().editProduct(_selectedCategoryId!, product.id, productData);
                                },
                                title: 'Edit Product',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => FirestoreService().deleteItem('products', product.id, _selectedCategoryId),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddEditDialog(
            title: _activeCollection == 'Category' ? 'Add Category' : 'Add Product',
            onSave: (data) {
              if (_activeCollection == 'Category') {
                FirestoreService().addCategory(data); // Save category data
              } else if (_selectedCategoryId != null) {
                FirestoreService().addProduct(_selectedCategoryId!, data); // Save product data
              }
            },
          ),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
