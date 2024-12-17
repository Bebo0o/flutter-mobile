import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'ProductDetailsPage.dart';
import 'dart:async';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final querySnapshot = await FirebaseFirestore.instance.collection("Category").get();

    return querySnapshot.docs.map((doc) {
      return {
        "id": doc.id, // Firestore document ID
        "Name": doc['Name'] ?? 'Unnamed',
        "image": doc['image'] ?? 'assets/default_image.png',
      };
    }).toList();
  }

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isLoading = true;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchQuery = "";
  Timer? _listeningTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    fetchCategories().then((categories) {
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    });
  }

  void _filterCategories(String query) {
    final filtered = _categories.where((category) {
      final nameLower = category['Name'].toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredCategories = filtered;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _searchQuery = val.recognizedWords;
          _filterCategories(_searchQuery);
        });
      });

      // Stop listening after 5 seconds
      _listeningTimer?.cancel();
      _listeningTimer = Timer(Duration(seconds: 5), _stopListening);
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    _listeningTimer?.cancel();
  }

  @override
  void dispose() {
    _listeningTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Categories'),
      //   backgroundColor: Colors.teal,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Categories',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterCategories,
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredCategories.isEmpty
                    ? Center(child: Text('No categories found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPag(
                                    id: category['id'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      category['image'],
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    category['Name'],
                                    style: TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}