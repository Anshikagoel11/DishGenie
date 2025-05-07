import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dishgenie/auth/homeauth.dart'; // Adjust the path as needed

class Splashscreen1 extends StatefulWidget {
  const Splashscreen1({super.key});

  @override
  State<Splashscreen1> createState() => _Splashscreen1State();
}

class _Splashscreen1State extends State<Splashscreen1> {
  int currentStep = 0;
  late Timer timer;
  bool isTapped = false;

  final heading = [
    'Hungry? Just Ask – Your AI Chef is Ready!',
    'From Thought to Taste – AI Makes It Easy!',
    'Your Smart Kitchen Partner – Powered by AI!',
    'AI-Powered Cooking – Learn, Ask, Create!'
  ];

  final subheading = [
    'Instant recipes, personalized suggestions, and step-by-step guidance – just ask and cook!',
    'Craving something specific? Let AI turn your ideas into delicious dishes in minutes',
    'Plan meals, explore cuisines, and cook smarter with your intelligent culinary assistant.',
    'Master the art of cooking with interactive learning, voice commands, and custom recipes.'
  ];

  final images = [
    "assets/images/meal.png",
    "assets/images/indian.png",
    "assets/images/drinks.png",
    "assets/images/loading.png"
  ];

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!isTapped) {
        nextStep();
      }
    });
  }

  void nextStep() {
    if (currentStep < heading.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      timer.cancel();
      _navigateToAuthScreen();
    }
  }

  void _navigateToAuthScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        timer.cancel();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isTapped = true;
          });
          nextStep();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Background image
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: Image.asset(
                  images[currentStep],
                  key: ValueKey(currentStep),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),

              // Dark overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                ),
              ),

              // Progress indicators
              Column(
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(heading.length, (index) {
                      return Row(
                        children: [
                          buildProgressBar(index, width),
                          if (index < heading.length - 1)
                            const SizedBox(width: 10),
                        ],
                      );
                    }),
                  ),
                ],
              ),

              // Animated text content
              Positioned(
                top: height * 0.60,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child:
                      buildTextForStep(currentStep, key: ValueKey(currentStep)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(int step, double width) {
    double progressValue = (currentStep >= step) ? 1.0 : 0.0;

    return Container(
      width: width / 5,
      height: 10,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(62, 62, 62, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: progressValue),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF9800),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextForStep(int step, {required Key key}) {
    return Column(
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              heading[step],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              subheading[step],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
