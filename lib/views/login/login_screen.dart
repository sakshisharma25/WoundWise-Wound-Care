import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/account_preference_model.dart';
import 'package:woundwise/models/country_code.model.dart';
import 'package:woundwise/models/login_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/dashboard/dashboard_screen.dart';
import 'package:woundwise/views/register/create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.accountType, super.key});
  final AccountType accountType;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedCountryCode = kCountryCodes.first.code;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpControllers = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  bool isTryingToSendOTP = false;
  bool isOtpSended = false;
  bool isOtpCanBeResend = true;
  LoginModel? loginModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/logo1.png',
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 110,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCountryCode,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            items: kCountryCodes.map((CountryCode countryCode) {
                              return DropdownMenuItem<String>(
                                value: countryCode.code,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                        countryCode.flag,
                                        width: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      countryCode.code,
                                      style: const TextStyle(),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedCountryCode =
                                    value ?? kCountryCodes.first.code;
                              });
                            },
                            dropdownColor: Colors.grey[200],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: phoneController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Enter Registered Number',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Visibility(
                    visible: isOtpSended,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            'Enter OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Pinput(
                            autofocus: true,
                            focusNode: otpFocusNode,
                            controller: otpControllers,
                            length: 4,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onTapOutside: (event) {
                              otpFocusNode.unfocus();
                            },
                            onCompleted: (value) {
                              _validateOTP(context);
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: (isOtpSended && isOtpCanBeResend),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Didn\'t receive OTP?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            isOtpCanBeResend = false;
                            _sendOTP(context: context);
                            Future.delayed(
                              const Duration(seconds: 10),
                              () {
                                setState(() {
                                  isOtpCanBeResend = true;
                                });
                              },
                            );
                          },
                          child: const Text(
                            'Click Here',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 160),
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
                      onPressed: () {
                        isOtpSended
                            ? _validateOTP(context)
                            : _sendOTP(context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        isOtpSended ? 'Login' : 'Send OTP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Create an Account',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAccountScreen(
                                  accountType: widget.accountType,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Click Here',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isTryingToSendOTP)
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

  Future<void> _sendOTP({required BuildContext context}) async {
    if (phoneController.text.isEmpty) {
      kShowSnackBar('Please enter a phone number.');
      return;
    }
    final isValid = kValidatePhoneNumber(
      selectedCountryCode,
      phoneController.text,
    );
    if (isValid == false) return;

    try {
      // Check if already sended OTP
      if (isTryingToSendOTP) {
        return;
      }
      setState(() {
        isTryingToSendOTP = true;
      });

      final AccountType accountType = widget.accountType;
      final String phoneNumber = phoneController.text;

      // Send OTP
      Response response;
      if (accountType == AccountType.practitioner) {
        response = await PractitionerAPIServices.sendOTP(
          phone: phoneNumber,
        );
      } else {
        response = await OrganizationAPIServices.sendOTP(
          phone: phoneNumber,
        );
      }

      debugPrint("-> ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("OTP: $data");
        loginModel = LoginModel.fromJson(data);
        setState(() {
          isOtpSended = true;
        });
        kShowSnackBar("OTP sent successfully!!");
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        final data = jsonDecode(response.body);
        throw "${data['message']}";
      } else {
        throw "Internal server error. ${response.statusCode}";
      }
    } catch (error) {
      kShowSnackBar("$error");
    } finally {
      setState(() {
        isTryingToSendOTP = false;
      });
    }
  }

  Future<void> _validateOTP(BuildContext context) async {
    try {
      if (loginModel == null) {
        throw "OTP not sent. Please try again.";
      }

      if (otpControllers.text.isEmpty) {
        throw "Please enter OTP.";
      }

      if (otpControllers.text.length != 4) {
        throw "Please enter a valid OTP.";
      }

      if (otpControllers.text != loginModel?.otp) {
        throw "Incorrect OTP. Please try again.";
      }

      // Save Deatils to storage
      await StorageServices.setUserData(
        AccountPreferenceModel(
          countryCode: selectedCountryCode,
          phoneNumber: phoneController.text,
          accountType: widget.accountType,
          token: loginModel?.token,
          email: loginModel?.email,
          name: loginModel?.name,
          pin: loginModel?.pin,
        ),
      );

      // Navigate to Dashboard
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            accountType: widget.accountType,
          ),
          settings: const RouteSettings(name: "DashboardScreen"),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      kShowSnackBar("$error");
    }
  }
}
