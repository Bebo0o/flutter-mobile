// lib/second_page.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up Page'),
        centerTitle: true, 
      ),
      body: MyTextInputWidget(),
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
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _PhonNamber = TextEditingController();
  final TextEditingController _secondName = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  //DateTime? _selectedDate;
  //final List<String> _items = []; // List to store inputs

  //late final String data; // Declare the data variable
  final auth=FirebaseAuth.instance;

  late String email;
  late String pass;



  // Define the constructor to accept the data variable
 //_MyTextInputWidgetState({required this.data}); 

 
  // Text(
  //         'Received: $data', // Display the received data
  //         style: TextStyle(fontSize: 24),
  //       ),
 
  // void _compareInput() {
  //   String userInput = _emailController.text.trim().toLowerCase(); // Get user input and normalize it
  //   if (_items.contains(userInput)) {
  //     setState(() {
  //       data = 'Match found: $userInput is in the list!';
  //     });
  //   } else {
  //     setState(() {
  //       data = 'No match found for: $userInput';
  //     });
  //   }
  //  _emailController.clear(); // Clear the input after comparison
  
  //   String usecrInput =  _passwordController.text.trim().toLowerCase(); // Get user input and normalize it
  //   if (_items.contains(usecrInput)) {
  //     setState(() {
  //       data = 'Match found: $usecrInput is in the list!';
  //     });
  //   } else {
  //     setState(() {
  //       data = 'No match found for: $usecrInput';
  //     });
  //   }
  //  _passwordController.clear(); // Clear the input after comparison
  // }

  // void _addItem() {
  //   if (_emailController.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_emailController.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   if (_passwordController.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_passwordController.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   if (_firstName.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_firstName.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   if (_PhonNamber.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_PhonNamber.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   if (_secondName.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_secondName.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   if (_dateController.text.isNotEmpty) {
  //     setState(() {
  //       _items.add(_dateController.text); // Add input to the list
  //       //_emailController.clear();          // Clear the TextField after adding
  //       //print(_items);
  //     });
  //   }
  //   print(_items);
   
  // }



  bool showw = true;
      // get obscureText => true;
  Future<bool> _show() async{
       
       showw = !showw;
       
      print(showw);
      return showw;
  }

  void _showText() {
    // Display entered email and password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Entered Credentials'),
        content: Text('Email: ${_emailController.text}\nPassword: ${_passwordController.text}\nfirstname:${_firstName.text}\nPhoneNamber:${_PhonNamber.text}\nSacandName${_secondName}\ncelinder${_dateController}'),
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
      
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: <Widget>[
          //Text("data"),
          SizedBox(height: 15),
          Image.asset("assets/image/images.png"),
          SizedBox(height: 40),
          TextField(
            controller: _firstName,
            decoration: InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
              icon: Icon(Icons.person)
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _secondName,
            decoration: InputDecoration(
              labelText: 'Second Name',
              border: OutlineInputBorder(),
              icon: Icon(Icons.person_3_sharp)
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 5),
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
          SizedBox(height: 5),
          TextField(
            controller: _PhonNamber,
            decoration: InputDecoration(
              labelText: 'PhoneNamber',
              border: OutlineInputBorder(),
              icon: Icon(Icons.phone)
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 5),
          TextField (
            controller: _passwordController,
            onChanged: (value) {
              pass=value;
            },
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
              //icon: Icon(Icons.remove_red_eye_sharp,onPressed:),
              icon:IconButton(onPressed: _show, icon: Icon(Icons.remove_red_eye_sharp)), onPressed: () {  },
              
              // onPressed: _show, // Clears the text when tapped
               ),
              icon: Icon(Icons.password_outlined)
             
            ),
            
          obscureText:true,
            
          ),
          SizedBox(height: 5),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
              icon: Icon(Icons.calendar_month),
              
              onPressed:() => _selectDate(context), // Clears the text when tapped
              ),
              icon: Icon(Icons.calendar_month_outlined)
             
            ),
            
          
          ),
         
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async{ 
              try{
                 await auth.createUserWithEmailAndPassword(email: email, password: pass);
                print(email);
                print(pass);
              }catch (e){
                print("e");
              }
              
            },
            child: Text('Submit'),
          ),
          // SizedBox(height: 20),
          // ElevatedButton(
          // onPressed: () {
          //   // Navigate to the Second Page
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => SecondPage()),
          //   );
          // },
          // child: Text('Go to Second Page'),
          // )
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
  
    
      Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),  // Default to today's date
      firstDate: DateTime(1900),    // Start date range
      lastDate: DateTime(2100),     // End date range
    );

    if (pickedDate != null) {
      setState(() {
        // Format the DateTime to a string and set it to the controller
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }
}
 
