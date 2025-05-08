import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:ui' as ui; // Add this import for TextDirection

class RecipeFeedScreen extends StatefulWidget {
  const RecipeFeedScreen({super.key});

  @override
  State<RecipeFeedScreen> createState() => _RecipeFeedScreenState();
}

class _RecipeFeedScreenState extends State<RecipeFeedScreen> {
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String? _error;
  Map<int, bool> _expandedStates = {};

  // Light Orange & White Theme
  final Color _primaryOrange = Color(0xFFFFA500);
  final Color _lightOrange = Color(0xFFFFF3E0);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF333333);
  final Color _secondaryText = Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('https://ai-rasoi.onrender.com/api/post/all'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
          _expandedStates = Map.fromIterable(
            List.generate(_posts.length, (index) => index),
            key: (item) => item,
            value: (item) => false,
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load posts';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection error';
        _isLoading = false;
      });
    }
  }

  String _getUsername(String email) => email.split('@')[0];

  Widget _buildPostCard(dynamic post, int index) {
    final textParts = post['text']?.split('\n\n') ?? ['', ''];
    final title = textParts.isNotEmpty ? textParts[0] : 'Untitled Recipe';
    final description = textParts.length > 1 ? textParts[1] : '';
    final isExpanded = _expandedStates[index] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with subtle title
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: post['imageUrl'] ?? '',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: _lightOrange,
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: _primaryOrange,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: _lightOrange,
                      height: 150,
                      child:
                          Icon(Icons.fastfood, color: _primaryOrange, size: 30),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),

            // Content Area
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: _lightOrange,
                        child: Text(
                          _getUsername(post['user']['email'])[0].toUpperCase(),
                          style: TextStyle(
                            color: _primaryOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _getUsername(post['user']['email']),
                        style: TextStyle(
                          fontSize: 13,
                          color: _textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.favorite_border,
                          size: 18, color: _primaryOrange),
                      SizedBox(width: 4),
                      Text(
                        '${post['likes']?.length ?? 0}',
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Description with View More/Less
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: description,
                          style: TextStyle(
                            fontSize: 13,
                            color: _textColor.withOpacity(0.9),
                          ),
                        ),
                        maxLines: 2,
                        textDirection: ui
                            .TextDirection.ltr, // Fixed: using ui.TextDirection
                      );
                      textPainter.layout(maxWidth: constraints.maxWidth);

                      final needsExpansion = textPainter.didExceedMaxLines;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 13,
                              color: _textColor.withOpacity(0.9),
                            ),
                            maxLines: isExpanded ? null : 2,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          if (description.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expandedStates[index] = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? 'Show less' : 'Show more',
                                style: TextStyle(
                                  color: _primaryOrange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 8),

                  // Date
                  Text(
                    DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(post['createdAt'])),
                    style: TextStyle(
                      fontSize: 11,
                      color: _secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightOrange,
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: _cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _primaryOrange),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _primaryOrange))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 40, color: _primaryOrange),
                      SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(color: _textColor, fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchPosts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Try Again',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) =>
                      _buildPostCard(_posts[index], index),
                ),
    );
  }
}
