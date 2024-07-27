// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/country_code.model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/models/account_preference_model.dart';
import 'package:woundwise/views/register/license_key_verification_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({required this.accountType, super.key});
  final AccountType accountType;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+61';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    const textFieldStyle = TextStyle(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Center(child: Image.asset('assets/logo1.png', height: 100)),
                  const SizedBox(height: 30),
                  const Text('Name', style: headingStyle),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _nameController,
                    style: textFieldStyle,
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
                      hintText: 'Enter Name',
                      hintStyle: textFieldStyle,
                    ),
                    keyboardType: TextInputType.name,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Email', style: headingStyle),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    style: textFieldStyle,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Enter Your Email',
                      hintStyle: textFieldStyle,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text('Mobile Number', style: headingStyle),
                  const SizedBox(height: 4),
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
                            value: _selectedCountryCode,
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
                                      child: Image.asset(countryCode.flag,
                                          width: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      countryCode.code,
                                      style: textFieldStyle,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCountryCode = newValue!;
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
                          controller: _phoneController,
                          style: textFieldStyle,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Enter Registered number',
                            hintStyle: textFieldStyle,
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
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
                      onPressed: _validateSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Sign Up',
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

  Future<void> _validateSignUp() async {
    if (_isLoading == true) return;
    setState(() {
      _isLoading = true;
    });

    try {
      if (_nameController.text.isEmpty) {
        throw 'Please enter your name.';
      }
      if (_emailController.text.isEmpty) {
        throw 'Please enter your email.';
      }
      if (!_emailController.text.contains('@') ||
          !_emailController.text.contains('.')) {
        throw 'Invalid email, Please re-enter again.';
      }
      if (_phoneController.text.isEmpty) {
        throw 'Please enter your phone number.';
      }
      final isNumberVaild = kValidatePhoneNumber(
        _selectedCountryCode,
        _phoneController.text,
      );
      if (isNumberVaild == false) return;

      final name = _nameController.text;
      final email = _emailController.text;
      final countryCode = _selectedCountryCode;
      final phoneNumber = _phoneController.text;

      Response response;
      if (widget.accountType == AccountType.organization) {
        response = await OrganizationAPIServices.sendEmail(
          name: name,
          email: email,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
        );
      } else {
        response = await PractitionerAPIServices.sendEmail(
          name: name,
          email: email,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
        );
      }

      debugPrint("->${response.body}");
      if (response.statusCode == 200) {
        await StorageServices.setUserData(
          AccountPreferenceModel(
            name: _nameController.text,
            email: _emailController.text,
            countryCode: _selectedCountryCode,
            phoneNumber: _phoneController.text,
            accountType: widget.accountType,
          ),
        );
        final data = jsonDecode(response.body);
        kShowSnackBar("${data['message']}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LicenseKeyVerificationScreen(
              accountType: widget.accountType,
              licenseKey: data['license_key'],
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
