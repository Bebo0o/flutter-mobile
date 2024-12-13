import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Search extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  Search({
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Function to start voice search
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        widget.onSearchChanged(result.recognizedWords);  // Pass the recognized words to search function
      });
    } else {
      // Handle error or inform user that speech recognition is unavailable
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Speech recognition is not available'),
      ));
    }
  }

  // Function to stop listening
  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 400, // Adjust width to fit the search box
        child: Column(
          children: [
            TextField(
              controller: widget.searchController,
              onChanged: widget.onSearchChanged,  // Call onSearchChanged callback
              decoration: InputDecoration(
                hintText: 'Search Products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8.0),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_off : Icons.mic,
                color: Colors.teal,
              ),
              onPressed: _isListening ? _stopListening : _startListening,
            ),
          ],
        ),
      ),
    );
  }
}
