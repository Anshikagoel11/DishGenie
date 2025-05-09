import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RecipeBotScreen extends StatefulWidget {
  @override
  _RecipeBotScreenState createState() => _RecipeBotScreenState();
}

class _RecipeBotScreenState extends State<RecipeBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  String _selectedPreference = '';

  final List<String> _preferenceOptions = [
    'Make it healthy',
    'Vegetarian',
    'Spicy',
    'Low-carb',
    'Quick to cook'
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendTextMessage() async {
    final ingredients = _textController.text.trim();
    if (ingredients.isEmpty) return;

    setState(() {
      _messages.add({'text': ingredients, 'isUser': true});
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('http://192.100.68.106:8000/generate_recipe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ingredients': ingredients,
          'preferences': _selectedPreference,
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        _messages.add(
            {'text': data['recipe'] ?? 'No recipe found.', 'isUser': false});
      });
    } catch (e) {
      setState(() {
        _messages
            .add({'text': '❌ Error generating recipe.\n$e', 'isUser': false});
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _messages
          .add({'text': "📷 Image selected. Processing...", 'isUser': true});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      Uint8List imageBytes = await pickedFile.readAsBytes();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.100.68.106:8000/fridge_recipe'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: pickedFile.name,
          contentType: MediaType('image', pickedFile.name.split('.').last),
        ),
      );
      request.fields['preferences'] = _selectedPreference;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      setState(() {
        _messages.add({
          'text': data['recipe'] ?? 'No recipe found from image.',
          'isUser': false
        });
      });
    } catch (e) {
      setState(() {
        _messages
            .add({'text': '❌ Error processing image.\n$e', 'isUser': false});
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('DishGenie'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isUser']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          message['isUser'] ? Colors.orange[100] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message['text'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),

          // Preferences dropdown + input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedPreference.isNotEmpty
                      ? _selectedPreference
                      : null,
                  hint: const Text("Preferences"),
                  onChanged: (value) {
                    setState(() => _selectedPreference = value ?? '');
                  },
                  items: _preferenceOptions.map((pref) {
                    return DropdownMenuItem(
                      value: pref,
                      child: Text(pref),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Input row
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.image, color: Colors.deepOrange),
                onPressed: _sendImageMessage,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter ingredients...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.deepOrange),
                onPressed: _sendTextMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
