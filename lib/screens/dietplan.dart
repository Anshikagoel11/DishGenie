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

  Future<void> getDietPlan() async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://192.100.68.106:8000/diet_plan');

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
      setState(() {
        dietPlan = data['diet_plan'];
      });
    } else {
      setState(() {
        dietPlan = "Failed to get diet plan.";
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange.shade100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Get Your Diet Plan'),
        backgroundColor: orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("Height: ${height.round()} cm"),
                    Slider(
                      value: height,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      onChanged: (val) => setState(() => height = val),
                      activeColor: Colors.deepOrange,
                    ),
                    SizedBox(height: 10),
                    Text("Weight: ${weight.round()} kg"),
                    Slider(
                      value: weight,
                      min: 30,
                      max: 150,
                      divisions: 120,
                      onChanged: (val) => setState(() => weight = val),
                      activeColor: Colors.deepOrange,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: gender,
                      items: ['Male', 'Female'].map((g) {
                        return DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Gender'),
                      onChanged: (val) => setState(() => gender = val!),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: goal,
                      items: ['Fatloss', 'Muscle Gain', 'Maintenance'].map((g) {
                        return DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Goal'),
                      onChanged: (val) => setState(() => goal = val!),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: getDietPlan,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Get Diet Plan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (dietPlan != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dietPlan!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
