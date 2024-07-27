// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/account_preference_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/settings/changed_succesfully_screen.dart';

class ForgetPinNewScreen extends StatelessWidget {
  const ForgetPinNewScreen(
      {required this.otp, required this.newPinType, super.key});
  final String otp;
  final PinType newPinType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 80,
            width: 160,
          ),
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.check, color: Colors.transparent),
            onPressed: null,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _Builder(pinType: newPinType, otp: otp),
    );
  }
}

class _Builder extends StatefulWidget {
  const _Builder({required this.otp, required this.pinType});
  final String otp;
  final PinType pinType;

  @override
  State<_Builder> createState() => _ChangePINScreenState();
}

class _ChangePINScreenState extends State<_Builder> {
  final TextEditingController _firstNewPinController = TextEditingController();
  final TextEditingController _secondNewPinController = TextEditingController();
  final FocusNode _firstNewPinFocusNode = FocusNode();
  final FocusNode _secondNewPinFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create new PIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'The password should be different from previous password.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 30, width: double.infinity),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create New PIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Pinput(
              autofocus: true,
              focusNode: _firstNewPinFocusNode,
              controller: _firstNewPinController,
              enableSuggestions: false,
              length: (widget.pinType == PinType.fourDigit) ? 4 : 6,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              showCursor: true,
              onChanged: (pin) {
                setState(() {});
              },
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(_secondNewPinFocusNode);
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Re-enter PIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Pinput(
              focusNode: _secondNewPinFocusNode,
              controller: _secondNewPinController,
              enableSuggestions: false,
              length: (widget.pinType == PinType.fourDigit) ? 4 : 6,
              pinputAutovalidateMode: PinputAutovalidateMode.disabled,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              showCursor: true,
              onChanged: (pin) {
                setState(() {});
              },
              onCompleted: (pin) {
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 120),
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
                onPressed: _arePinsMatching() ? _changePIN : _showIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Save',
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
    );
  }

  bool _arePinsMatching() {
    if (_firstNewPinController.text.isEmpty ||
        _secondNewPinController.text.isEmpty) {
      return false;
    }

    if (_firstNewPinController.text != _secondNewPinController.text) {
      return false;
    }

    return true;
  }

  void _showIssue() {
    if (_firstNewPinController.text != _secondNewPinController.text) {
      kShowSnackBar("New PINs do not match. Please try again.");
    }
  }

  void _changePIN() async {
    try {
      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final email = userData.email;
      final accounType = userData.accountType;

      if (token == null) {
        throw "Token is null";
      }
      if (email == null) {
        throw "Email is null";
      }
      if (accounType == null) {
        throw "Account type is null";
      }

      final newPin = _firstNewPinController.text;
      final otp = widget.otp;

      Response? response;

      if (accounType == AccountType.organization) {
        response = await OrganizationAPIServices.forgetPIN(
          token: token,
          email: email,
          newPin: newPin,
          otp: otp,
        );
      } else {
        response = await PractitionerAPIServices.forgetPIN(
          token: token,
          email: email,
          newPin: newPin,
          otp: otp,
        );
      }

      if (response.statusCode == 200) {
        _updateProfileInSharedPreference(pinCode: newPin);
        kShowSnackBar("PIN changed successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangedSuccessfullyScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw "${data['error']}";
      } else {
        throw "Internal server error. ${response.statusCode}";
      }
    } catch (error) {
      kShowSnackBar("$error");
      debugPrint("$error");
    }
  }

  /// Update profile locally
  Future<void> _updateProfileInSharedPreference({
    required String pinCode,
  }) async {
    final AccountPreferenceModel accountPreference = AccountPreferenceModel(
      pin: pinCode,
    );
    await StorageServices.setUserData(accountPreference);
  }
}
