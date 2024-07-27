import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woundwise/models/country_code.model.dart';

enum AccountType {
  organization,
  practitioner,
}

enum ActionType {
  createAnAccount,
  loginAccount,
}

enum PinType {
  fourDigit,
  sixDigit,
}

enum AimOfClick {
  takePicture,
  uploadPicture,
  savePatient,
}

void kShowSnackBar(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade100,
      textColor: Colors.black,
      fontSize: 16.0);
}

List<CountryCode> kCountryCodes = [
  CountryCode(code: '+91', country: 'India', flag: 'assets/in.png'),
];

bool kValidatePhoneNumber(String countryCode, String phoneNumber) {
  // Define the requirements for each country
  Map<String, List<int>> countryCodeToLength = {
    '+91': [10, 10], // India: Min 10, Max 10 digits
  };

  // Check if the country code is recognized
  if (countryCodeToLength.containsKey(countryCode)) {
    int actualLength = phoneNumber.length;
    List<int> lengthRequirements = countryCodeToLength[countryCode]!;
    // Validate the length of the phone number
    if (actualLength >= lengthRequirements[0] &&
        actualLength <= lengthRequirements[1]) {
      // Phone number is valid
      return true;
    } else {
      // Phone number is invalid
      kShowSnackBar(
        "Phone number should be ${lengthRequirements[0] == lengthRequirements[1] ? '${lengthRequirements[0]}' : '${lengthRequirements[0]}-${lengthRequirements[1]}'} digits.",
      );
      return false;
    }
  } else {
    // Country code not recognized
    kShowSnackBar("The country code $countryCode is not recognized.");
    return false;
  }
}
