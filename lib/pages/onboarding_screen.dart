import 'package:ewaste/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final List<String> titles = [
    "Welcome to E-Waste Guide",
    "Scan & Track",
    "Make an Impact"
  ];
  final List<String> subtitles = [
    "Learn how to properly dispose of your electronic waste.",
    "Scan your e-waste and track your recycling impact.",
    "Join our community and help protect the environment."
  ];
  final List<Color> colors = [Colors.green, Colors.blue, Colors.purple];

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true); // Save onboarding status

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: titles.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: colors[index].withOpacity(0.3),
                      child: Icon(Icons.eco, size: 80, color: colors[index]),
                    ),
                    SizedBox(height: 20),
                    Text(titles[index],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        subtitles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(titles.length, (index) {
              return Container(
                margin: EdgeInsets.all(5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currentIndex == index ? colors[index] : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (currentIndex < titles.length - 1) {
                setState(() => currentIndex++);
              } else {
                _completeOnboarding(); // Save status and navigate
              }
            },
            child: Text(currentIndex == titles.length - 1 ? "Get Started" : "Next"),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
