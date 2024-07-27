import 'package:flutter/material.dart';

class FollowUpExitScreen extends StatelessWidget {
  const FollowUpExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100), // Space above the logo
              Center(
                child: Image.asset('assets/logo1.png', height: 100), // Logo
              ),
              const SizedBox(height: 50), // Space between logo and text
              Container(
                height: 460, // Adjusted height to include the button
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Follow-Up Created',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Schedule for follow up successful. \n Please click on below',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('assets/verified.png', height: 150), // Verified image
                    const SizedBox(height: 30), // Space between image and button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50), // Adjust horizontal padding to reduce button width
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.settings.name == "DashboardScreen");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Ensuring the button background is transparent
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            shadowColor: Colors.transparent, // No shadow for cleaner design
                          ),
                          child: const Text(
                            'Save & Exit',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
