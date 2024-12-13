// import 'package:app/Home.dart';
import 'package:app/cart.dart';
import 'package:app/firebase_options.dart';
// import 'package:app/forgit_pass.dart';
import 'package:app/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'sign_up.dart'; 
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CartPage(),
      ),
    );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );;
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'cart.dart'; // Import your CartModel here
// import 'homePage.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => CartModel(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(), // Your home page
//     );
//   }
// }

