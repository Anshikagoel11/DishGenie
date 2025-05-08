import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostRecipeScreen extends StatefulWidget {
  final String email;

  const PostRecipeScreen({super.key, required this.email});

  @override
  State<PostRecipeScreen> createState() => _PostRecipeScreenState();
}

class _PostRecipeScreenState extends State<PostRecipeScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  bool _isPosting = false;
  List<Map<String, String>> _posts = [];

  // **Light Orange Color Theme**
  final Color _primaryOrange = Color(0xFFFFA500); // Classic Orange
  final Color _lightOrange = Color(0xFFFFD699); // Soft Peach
  final Color _background = Color(0xFFFFF8F0); // Warm Off-White
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF333333); // Dark Gray for Readability
  final Color _accentColor = Color(0xFF4CAF50); // Green for Success

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _postRecipe() async {
    final name = _recipeNameController.text.trim();
    final description = _descriptionController.text.trim();
    final username = widget.email.split('@')[0];

    if (name.isEmpty || description.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields and add an image!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final uri = Uri.parse("https://ai-rasoi.onrender.com/api/post/create");
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['text'] = "$name\n\n$description"
        ..files
            .add(await http.MultipartFile.fromPath('image', _imageFile!.path));

      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (resBody.statusCode == 200 || resBody.statusCode == 201) {
        setState(() {
          _posts.insert(0, {
            "username": username,
            "text": "$name\n\n$description",
            "image": _imageFile!.path
          });
          _recipeNameController.clear();
          _descriptionController.clear();
          _imageFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Recipe posted successfully! 🎉"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to post: ${resBody.body}"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "Share Your Recipe",
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 222, 174), // Light orange
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Recipe Name Input**
            Text(
              "Recipe Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _textColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _recipeNameController,
                style: TextStyle(color: _textColor),
                decoration: InputDecoration(
                  hintText: "e.g., Creamy Garlic Pasta",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // **Recipe Description**
            Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _textColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                style: TextStyle(color: _textColor),
                decoration: InputDecoration(
                  hintText: "Describe your recipe...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // **Image Picker Section**
            Text(
              "Add a Photo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _textColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color:
                      _imageFile == null ? _lightOrange.withOpacity(0.2) : null,
                  borderRadius: BorderRadius.circular(12),
                  border: _imageFile == null
                      ? Border.all(
                          color: _primaryOrange.withOpacity(0.3),
                          width: 1.5,
                          style: BorderStyle.solid,
                        )
                      : null,
                  image: _imageFile != null
                      ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: _imageFile == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: _primaryOrange,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap to upload an image",
                              style: TextStyle(
                                color: _primaryOrange.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 30),

            // **Post Button**
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPosting ? null : _postRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isPosting
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Text(
                        "POST RECIPE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30),

            // **Posted Recipes Section**
            if (_posts.isNotEmpty) ...[
              Text(
                "Your Recipes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 16),
              ..._posts.map(
                (post) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.file(
                          File(post["image"]!),
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post["username"]!,
                              style: TextStyle(
                                color: _primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              post["text"]!,
                              style: TextStyle(
                                color: _textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
