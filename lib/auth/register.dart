import 'package:dishgenie/auth/otp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dishgenie/auth/homeauth.dart';
import 'package:dishgenie/auth/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  bool _isStrongPassword(String password) {
    RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
    );
    return passwordRegExp.hasMatch(password.trim());
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please fill all fields.';
      });
      return;
    }

    print("Entered password: '$password'");
    print("Valid password: ${_isStrongPassword(password)}");

    if (!_isStrongPassword(password)) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Password is too weak. Must contain uppercase, lowercase, number, and special character.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://ai-rasoi.onrender.com/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Response data: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = responseData["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Successfully Registered')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(email: email),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = responseData['message'] ??
              'Something went wrong. Please try again.';
        });
        print('Error: ${responseData['message']}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Failed to connect to the server. Please try again later.';
      });
      print('Registration failed: $error');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4A261),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1B18),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 30),
                  child: Center(
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: const Color(0xFF2C2925),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFF4A261),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: const Color(0xFF2C2925),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFF4A261),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF4A261),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _register,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFFF4A261),
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
