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

  // Color palette
  final Color _primaryColor = Color(0xFFFF6D00);
  final Color _secondaryColor = Color(0xFFFF9E40);
  final Color _accentColor = Color(0xFFFF3D00);
  final Color _backgroundColor = Color(0xFFFFF3E0);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF333333);

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
        _messages.add({
          'text': '❌ Error generating recipe.\nPlease try again.',
          'isUser': false
        });
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
        _messages.add({
          'text': '❌ Error processing image.\nPlease try again.',
          'isUser': false
        });
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Recipe AI Chef',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _backgroundColor.withOpacity(0.8),
                    _backgroundColor.withOpacity(0.4),
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: message['isUser']
                            ? _secondaryColor.withOpacity(0.2)
                            : _cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: message['isUser']
                              ? Radius.circular(16)
                              : Radius.circular(4),
                          bottomRight: message['isUser']
                              ? Radius.circular(4)
                              : Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: _textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  strokeWidth: 3,
                ),
              ),
            ),

          // Preferences dropdown
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value:
                  _selectedPreference.isNotEmpty ? _selectedPreference : null,
              hint: Text(
                "Select preference...",
                style: TextStyle(color: _textColor.withOpacity(0.6)),
              ),
              icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
              underline: SizedBox(),
              onChanged: (value) {
                setState(() => _selectedPreference = value ?? '');
              },
              items: _preferenceOptions.map((pref) {
                return DropdownMenuItem(
                  value: pref,
                  child: Text(
                    pref,
                    style: TextStyle(color: _textColor),
                  ),
                );
              }).toList(),
            ),
          ),

          // Input row
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: _primaryColor),
                  onPressed: _sendImageMessage,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter ingredients...',
                      hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: TextStyle(color: _textColor),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_primaryColor, _accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendTextMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
