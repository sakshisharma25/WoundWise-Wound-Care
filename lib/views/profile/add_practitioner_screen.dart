import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/country_code.model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';

class AddPractitionerScreen extends StatefulWidget {
  const AddPractitionerScreen({super.key});

  @override
  State<AddPractitionerScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<AddPractitionerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+61';

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 15);
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add Practitioner",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fill the details below to add a practitioner.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    style: textStyle,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Enter Name',
                      hintStyle: textStyle,
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    style: textStyle,
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
                      hintStyle: textStyle,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
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
                                      child: Image.asset(
                                        countryCode.flag,
                                        width: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      countryCode.code,
                                      style: textStyle,
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
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          style: textStyle,
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
                            hintText: 'Enter Registered number',
                            hintStyle: textStyle,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 200),
                  _AddPractitionerButton(
                    onPress: () => _addPractitioner(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (isSaving)
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

  void _addPractitioner() async {
    if (isSaving) return;

    try {
      setState(() {
        isSaving = true;
      });

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
        throw 'Invalid phone number. Please try again.';
      }

      final isPhoneNumberVaild = kValidatePhoneNumber(
        _selectedCountryCode,
        _phoneController.text,
      );

      if (!isPhoneNumberVaild) {
        return;
      }

      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final orgEmail = userData.email;

      if (token == null) {
        throw 'Token not found';
      }

      if (orgEmail == null) {
        throw 'Organization email not found';
      }

      final response = await OrganizationAPIServices.adminAddPractitioner(
        token: token,
        name: _nameController.text,
        email: _emailController.text,
        countryCode: _selectedCountryCode,
        phoneNumber: _phoneController.text,
        organizationEmail: orgEmail,
      );

      if (response.statusCode == 200) {
        kShowSnackBar("Practitioner added successfully.");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw data['error'];
      } else {
        throw 'Internal server error. Please try again later.${response.statusCode}';
      }
    } catch (error) {
      kShowSnackBar("$error");
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }
}

class _AddPractitionerButton extends StatelessWidget {
  const _AddPractitionerButton({required this.onPress});
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Add Practitioner',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
