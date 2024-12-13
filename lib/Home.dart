// import 'package:app/sign_up.dart';
import 'package:flutter/material.dart';
import 'CategoriesPage.dart';
import 'cart.dart'; // Ensure you have a CartPage implemented

class HomePage extends StatelessWidget {
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Settings Page (if implemented)
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Help Page (if implemented)
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Login Page (or replace stack)
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            //child: Text('Go to Cart'),

          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showOptions(context),
          ),
        ],
      ),
      body: CategoriesPage(), // Correct placement for categories
    );
  }
}
