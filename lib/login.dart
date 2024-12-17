import 'package:app/CategoriesPage.dart';
import 'package:app/CustomerFeedbackScreen.dart';
import 'package:app/Home.dart';
import 'package:app/admin.dart';
import 'package:app/adminPage.dart';
import 'package:app/sign_up.dart';
import 'package:app/transaction.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/forgit_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';
String emaill ='beboo@gmail.com';
String passoord='123456';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.shopping_bag),
           
          title: Center(child: Text('Enter Your Credentials'), ),
          actions: [ IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Another function
                print('Search icon tapped!');
              },
            ),
          ],
        ),
       
        body: MyTextInputWidget(),
        
      ),
    );
  }
}

class MyTextInputWidget extends StatefulWidget {
  @override
  _MyTextInputWidgetState createState() => _MyTextInputWidgetState();
  //bool obscureText =true;
  
}

class _MyTextInputWidgetState extends State<MyTextInputWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final auth=FirebaseAuth.instance;
  bool _rememberMe = false;

  var LoginKay =GlobalKey<ScaffoldState>();
  
  late String email;
  late String pass;
  bool showw = false;
      // get obscureText => true;
  bool _show(){
   
    showw =!showw;
     print(showw);
     return showw;
     }
  

  void _showText() {
    // Display entered email and password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Entered Credentials'),
        content: Text('Email: ${_emailController.text}\nPassword: ${_passwordController.text}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return Padding(

      key: LoginKay,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: <Widget>[
          //Text("data"),
          SizedBox(height: 40),
          Image.asset("assets/image/images.png"),
          SizedBox(height: 100),
          TextField(
            controller: _emailController,
            onChanged: (value) {
              email=value;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              icon: Icon(Icons.email_outlined)
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20),
          TextField (
            
            // onSaved: OnClick,
            obscureText:showw == true ? false: true ,
            controller: _passwordController,
            onChanged: (value) {
             pass=value;
            },
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye_sharp),
              
              onPressed: _show, // Clears the text when tapped

              ),
              icon: Icon(Icons.password_outlined)

             
            ),


          
            
          ),
          
          Row(
              
              children: [
                SizedBox(width: 35),
                Checkbox(
                  
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text("Remember Me"),
              
                // ElevatedButton(
                //   onPressed: () {
                    
                //   },
                //   child: Text(
                //     'Forgot Password?',
                //     style: TextStyle(
                //       color: Colors.blue, // Customize text color
                //       fontSize: 16,       // Customize font size
                //       decoration: TextDecoration.underline, // Optional: underline effect
                //     ),
                //   ),
                // ),
                SizedBox(width: 220),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    // Your action here
                    print('Forgot Password tapped!');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.purple, // Customize color
                      fontSize: 10,       // Customize font size
                    ),
                  ),
                )

              ],
              
            ),
            SizedBox(height: 20),
         
          Row(
            children: [
             

            SizedBox(width: 150),
          ElevatedButton(
            onPressed:() async{
              try{
                  var user =await auth.signInWithEmailAndPassword(email: email, password: pass);
                    
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    if (_rememberMe) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('email', _emailController.text);
                        await prefs.setString('password', _passwordController.text);
                      }
                      print("yes");
                   if (_emailController==emaill&&_passwordController==passoord)  {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllOrdersPage()),
                    );
                   } 
                    
              }on FirebaseAuthException catch(e)
              {
                if (e.code =='user-not-found'){
                  Text("user-not-found");
                  print('user-not-found');
                 // LoginKay.currentState.showSnackBar(SnackBar(content: Text("user-not-found")));
                  final snackBar = SnackBar(
                      content: const Text('user-not-found'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);


                }
                else if (e.code == 'wrong-password'){
                Text("wrong-password");
                print('wrong-password');
                final snackBar = SnackBar(
                      content: const Text('Wrong password'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }
                else{
                   print('welse');
                   final snackBar = SnackBar(
                      content: const Text('Wrong email or password'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);


                }

              }
           
          },
            child: Text(' Login '),
          ),
          SizedBox(width: 20),
          ElevatedButton(
          onPressed: () {
            // Navigate to the Second Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Text('Sign up'),
          ),
          SizedBox(width: 20),
          // ElevatedButton(
          // onPressed: () {
          //   // Navigate to the Second Page
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => AllOrdersPage() ),
          //   );
          // },
          // child: Text('cwic login'),
          // ),
          // SizedBox(width: 20),
          // ElevatedButton(
          // onPressed: () {
          //   // Navigate to the Second Page
          //   // Navigator.push(
          //   //   context,
          //   //   //MaterialPageRoute(builder: (context) => CustomerFeedbackScreen() ),
          //   // );
          // },
          // child: Text('cwic login'),
          // )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 

  
  
}
// void _logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('email');
//   await prefs.remove('password');
//   MaterialPageRoute(builder: (context) => MyApp());
//   // Navigator.pushReplacementNamed(context, '/login');
// }

 