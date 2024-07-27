import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/views/settings/forget_pin_new_screen.dart';

class ForgetPinTypeScreen extends StatelessWidget {
  final String otp;

  const ForgetPinTypeScreen({
    super.key,
    required this.otp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/logo1.png', height: 100),
                    const SizedBox(height: 30),
                    const Text(
                      'Select PIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select your preferred PIN length.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 140),
              _buildButton(context, "4 Digit PIN", PinType.fourDigit),
              const SizedBox(height: 20),
              _buildButton(context, "6 Digit PIN", PinType.sixDigit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, PinType pinType) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
                color: Color(0xFF1a237e)), // Blue border for outlined effect
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgetPinNewScreen(
                newPinType: pinType,
                otp: otp,
              ),
            ),
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1a237e),
          ),
        ),
      ),
    );
  }
}
