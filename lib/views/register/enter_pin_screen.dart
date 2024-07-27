// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:woundwise/constants.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/models/account_preference_model.dart';
import 'package:woundwise/views/register/signup_success_screen.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({
    super.key,
    required this.licenseKey,
    required this.accountType,
    required this.pinType,
  });
  final String licenseKey;
  final AccountType accountType;
  final PinType pinType;

  @override
  State<EnterPinScreen> createState() => _FourDigitPinScreenState();
}

class _FourDigitPinScreenState extends State<EnterPinScreen> {
  final TextEditingController _firstPinController = TextEditingController();
  final TextEditingController _secondPinController = TextEditingController();
  final FocusNode _firstPinFocusNode = FocusNode();
  final FocusNode _secondPinFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    const subTitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    const fieldTitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Image.asset('assets/logo1.png', height: 100),
                  const SizedBox(height: 30),
                  const Text(
                    'Create PIN',
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your PIN successfully created. Please create a custom PIN for your account.',
                    textAlign: TextAlign.center,
                    style: subTitleStyle,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Create custom PIN',
                    style: fieldTitleStyle,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    autofocus: true,
                    focusNode: _firstPinFocusNode,
                    controller: _firstPinController,
                    length: (widget.pinType == PinType.fourDigit) ? 4 : 6,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Re-enter PIN',
                    style: fieldTitleStyle,
                  ),
                  const SizedBox(height: 10),
                  Pinput(
                    focusNode: _secondPinFocusNode,
                    controller: _secondPinController,
                    length: (widget.pinType == PinType.fourDigit) ? 4 : 6,
                    pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                    showCursor: true,
                    onCompleted: (pin) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 110),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: _arePinsMatching()
                            ? [const Color(0xFF1B5FC1), const Color(0xFF7EB3FF)]
                            : [Colors.grey, Colors.grey],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed:
                          _arePinsMatching() ? _createPINAndSaveData : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  bool _arePinsMatching() {
    if (_firstPinController.text.isEmpty ||
        _secondPinController.text.isEmpty ||
        _firstPinController.text != _secondPinController.text) {
      return false;
    }
    return true;
  }

  Future<void> _createPINAndSaveData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final accountData = await StorageServices.getUserData();
      final name = accountData.name;
      final email = accountData.email;
      final cCode = accountData.countryCode;
      final phone = accountData.phoneNumber;

      Response response;
      if (widget.accountType == AccountType.organization) {
        response = await OrganizationAPIServices.createPinAndSaveData(
          name: "$name",
          email: "$email",
          countryCode: "$cCode",
          phone: "$phone",
          licenseKey: widget.licenseKey,
          pin: _firstPinController.text,
        );
      } else {
        response = await PractitionerAPIServices.createPinAndSaveData(
          name: "$name",
          email: "$email",
          countryCode: "$cCode",
          phone: "$phone",
          licenseKey: widget.licenseKey,
          pin: _firstPinController.text,
        );
      }

      debugPrint("->${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await StorageServices.setUserData(
          AccountPreferenceModel(
            token: token,
            pin: _firstPinController.text,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpSuccessScreen(
              accountType: widget.accountType,
            ),
          ),
        );
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        final data = jsonDecode(response.body);
        throw "${data['error']}";
      } else {
        throw 'Internal server error. ${response.statusCode}';
      }
    } catch (error) {
      kShowSnackBar("$error");
      debugPrint("Error: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
