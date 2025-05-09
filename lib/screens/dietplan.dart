import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DietPlanScreen extends StatefulWidget {
  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  double height = 170;
  double weight = 65;
  String gender = 'Male';
  String goal = 'Fatloss';
  String? dietPlan;
  bool isLoading = false;

  // Gradient orange colors
  final List<Color> primaryGradient = [
    Color(0xFFFF8C42), // Vibrant orange
    Color(0xFFFF6B35), // Deep orange
  ];

  final List<Color> lightGradient = [
    Color(0xFFFFB347), // Light orange
    Color(0xFFFFA036), // Peach orange
  ];

  final List<Color> darkGradient = [
    Color(0xFFE67F39), // Dark orange
    Color(0xFFD46B2E), // Burnt orange
  ];

  final Color backgroundColor = Color(0xFFF9F9F9);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF333333);

  Future<void> getDietPlan() async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://192.100.68.106:8000/diet_plan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'height_cm': height.round(),
          'weight_kg': weight.round(),
          'gender': gender,
          'goal': goal,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => dietPlan = data['diet_plan']);
      } else {
        setState(() => dietPlan = "Failed to get diet plan. Please try again.");
      }
    } catch (e) {
      setState(() => dietPlan = "Connection error. Please check your network.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: primaryGradient[0],
          secondary: lightGradient[0],
          surface: cardColor,
          background: backgroundColor,
          onPrimary: Colors.white,
          onSurface: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 26),
            elevation: 2,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Personalized Diet Plan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Input Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFFFF5EE),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryGradient[1],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Height Slider
                      _buildSlider(
                        title: 'Height',
                        value: height,
                        min: 100,
                        max: 220,
                        unit: 'cm',
                        onChanged: (val) => setState(() => height = val),
                      ),
                      SizedBox(height: 20),

                      // Weight Slider
                      _buildSlider(
                        title: 'Weight',
                        value: weight,
                        min: 30,
                        max: 150,
                        unit: 'kg',
                        onChanged: (val) => setState(() => weight = val),
                      ),
                      SizedBox(height: 20),

                      // Gender Dropdown
                      _buildDropdown(
                        title: 'Gender',
                        value: gender,
                        items: ['Male', 'Female'],
                        onChanged: (val) => setState(() => gender = val!),
                      ),
                      SizedBox(height: 20),

                      // Goal Dropdown
                      _buildDropdown(
                        title: 'Goal',
                        value: goal,
                        items: ['Fatloss', 'Muscle Gain', 'Maintenance'],
                        onChanged: (val) => setState(() => goal = val!),
                      ),
                      SizedBox(height: 20),

                      // Generate Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: primaryGradient,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGradient[1].withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: getDietPlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'GENERATE PLAN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Results Section
              if (dietPlan != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFFFF5EE),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: lightGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(Icons.food_bank,
                                  color: Colors.white, size: 20),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Your Custom Diet Plan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryGradient[1],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          dietPlan!,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (!isLoading)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: lightGradient,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightGradient[1].withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Loading Indicator
              if (isLoading && dietPlan == null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Creating your perfect diet plan...',
                        style: TextStyle(
                          color: primaryGradient[1],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.8),
              ),
            ),
            Text(
              '${value.round()} $unit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryGradient[1],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primaryGradient[1],
            inactiveTrackColor: lightGradient[0].withOpacity(0.3),
            thumbColor: Colors.white,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 4,
            ),
            overlayColor: primaryGradient[0].withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFFFFAF5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: textColor),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
            dropdownColor: Colors.white,
            style: TextStyle(color: textColor),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: primaryGradient[1]),
          ),
        ),
      ],
    );
  }
}
