import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/views/register/select_pin_type_screen.dart';

class LicenseKeyVerificationScreen extends StatefulWidget {
  const LicenseKeyVerificationScreen(
      {super.key, required this.accountType, required this.licenseKey});
  final String licenseKey;
  final AccountType accountType;

  @override
  State<LicenseKeyVerificationScreen> createState() =>
      _LicenseKeyVerificationScreenState();
}

class _LicenseKeyVerificationScreenState
    extends State<LicenseKeyVerificationScreen> {
  final TextEditingController _licenseKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    const subTitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
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
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/logo1.png', height: 100),
                    const SizedBox(height: 30),
                    const Text(
                      'License Verification',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A license key has been sent to your registered email. Please verify your license key to proceed.',
                      textAlign: TextAlign.center,
                      style: subTitleStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'License Key',
                style: subTitleStyle,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _licenseKeyController,
                style: subTitleStyle,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Enter License Key Here',
                  hintStyle: subTitleStyle,
                ),
                keyboardType: TextInputType.name,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 180),
              Container(
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
                  onPressed: _validateLicenseKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Verify License Key',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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

  void _validateLicenseKey() {
    if (_licenseKeyController.text.isEmpty) {
      kShowSnackBar('Please enter your license key');
      return;
    }

    if (_licenseKeyController.text != widget.licenseKey) {
      kShowSnackBar('Invalid License Key. Please enter a valid license key.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectPinTypeScreen(
          licenseKey: widget.licenseKey,
          accountType: widget.accountType,
        ),
      ),
    );
  }
}
