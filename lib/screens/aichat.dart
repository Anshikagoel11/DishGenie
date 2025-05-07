import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeAIBotScreen extends StatefulWidget {
  const RecipeAIBotScreen({super.key});

  @override
  State<RecipeAIBotScreen> createState() => _RecipeAIBotScreenState();
}

class _RecipeAIBotScreenState extends State<RecipeAIBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      const ChatMessage(
        text:
            "Hello! I'm your Recipe Genie. Tell me what ingredients you have and I'll suggest delicious recipes!",
        isUser: false,
        isWelcome: true,
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(
            'https://ai-recipe-generator-1-ndtb.onrender.com/generate_recipe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ingredients': _extractIngredients(message),
          'preferences': _extractPreferences(message),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipeText = data['recipe'];

        if (recipeText != null && recipeText.toString().trim().isNotEmpty) {
          // Show recipe to user
          setState(() {
            _messages.add(
              ChatMessage(
                text: recipeText,
                isUser: false,
              ),
            );
          });

          // Send recipe to second API with the token
          try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');

            final secondaryResponse = await http.post(
              Uri.parse('https://ai-rasoi.onrender.com/api/recipe'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token', // Add the token here
              },
              body: json.encode({'recipe': recipeText}),
            );

            if (secondaryResponse.statusCode != 200) {
              debugPrint(
                  'Secondary API responded with status: ${secondaryResponse.statusCode}');
            }
          } catch (e) {
            debugPrint('Error sending to secondary API: $e');
          }
        } else {
          setState(() {
            _messages.add(
              const ChatMessage(
                text: 'No valid recipe generated from server.',
                isUser: false,
              ),
            );
          });
        }
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  'Recipe generator error (code ${response.statusCode}). Please try again.',
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          const ChatMessage(
            text: 'Connection error. Please check your internet and try again.',
            isUser: false,
          ),
        );
      });
      debugPrint('Primary API error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _extractIngredients(String message) {
    // Enhanced extraction logic
    final ingredients = message
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    return ingredients.join(', ');
  }

  String _extractPreferences(String message) {
    // Look for preference indicators
    final preferenceWords = [
      'spicy',
      'mild',
      'sweet',
      'savory',
      'healthy',
      'quick'
    ];
    final preferences =
        preferenceWords.where((word) => message.toLowerCase().contains(word));
    return preferences.isNotEmpty ? preferences.join(', ') : 'balanced flavor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Genie'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'E.g. "chicken, potatoes, carrots - spicy"',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange[400],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isWelcome;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.isWelcome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && !isWelcome)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.orange,
              child: Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
          if (!isUser && !isWelcome) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isWelcome
                    ? Colors.orange[50]
                    : isUser
                        ? Colors.orange[400]
                        : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 12),
                ),
                border:
                    isWelcome ? Border.all(color: Colors.orange[100]!) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWelcome)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange[400], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'TIP',
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (isWelcome) const SizedBox(height: 4),
                  Text(
                    text,
                    style: TextStyle(
                      color: isWelcome
                          ? Colors.grey[800]
                          : isUser
                              ? Colors.white
                              : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
