import 'package:woundwise/constants.dart';

class AccountPreferenceModel {
  // On Create Account Screen
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final AccountType? accountType;

  // On Pin Screen
  final String? token;
  final String? pin;

  AccountPreferenceModel({
    this.countryCode,
    this.phoneNumber,
    this.accountType,
    this.token,
    this.email,
    this.name,
    this.pin,
  });

  factory AccountPreferenceModel.fromMap(Map<String, dynamic> map) {
    return AccountPreferenceModel(
      countryCode: map['countryCode'],
      phoneNumber: map['phoneNumber'],
      accountType: map['accountType'],
      token: map['token'],
      email: map['email'],
      name: map['name'],
      pin: map['pin'],
    );
  }
}
