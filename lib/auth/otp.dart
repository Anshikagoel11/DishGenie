import 'package:dishgenie/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, required this.email});

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (_otpController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter the OTP.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://ai-rasoi.onrender.com/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': widget.email,
          'otp': _otpController.text,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('API Response: $responseData'); // Debug log

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData["message"] ?? 'Registered successfully')),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = responseData['message'] ??
              'OTP verification failed. Please try again.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Failed to connect to the server. Please try again later.';
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8C42),
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
              const SizedBox(height: 40),
              const Text(
                'Verify OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 30),
                  child: Center(
                    child: Column(
                      children: [
                        TextField(
                          controller: _otpController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
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
                        ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C42),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Verify OTP'),
                        ),
                        const SizedBox(height: 20),
                        if (_isLoading)
                          const CircularProgressIndicator(
                              color: Color(0xFFF4A261)),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Color(0xFFF4A261)),
                            ),
                          ),
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
