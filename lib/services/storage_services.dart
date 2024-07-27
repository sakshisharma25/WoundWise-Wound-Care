import 'package:shared_preferences/shared_preferences.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/account_preference_model.dart';

class StorageServices {
  static const _kFirstLaunchKey = 'isFirstLaunch';
  static const _kCountryCodeKey = 'countryCode';
  static const _kPhoneNumberKey = 'phoneNumber';
  static const _kEmailKey = 'email';
  static const _kAccountTypeKey = 'accountType';
  static const _kTokenKey = 'auth_token';
  static const _kName = 'name';
  static const _kPinCode = 'pin_code';

  static Future<bool> checkIsFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kFirstLaunchKey) ?? true;
  }

  static Future<void> setIntroLaunchComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kFirstLaunchKey, false);
  }

  static Future<void> removeIntroPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_kFirstLaunchKey);
  }

  static Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accountType = prefs.getString(_kAccountTypeKey);
    final token = prefs.getString(_kTokenKey);
    final email = prefs.getString(_kEmailKey);
    return (token != null && email != null && accountType != null);
  }

  static Future<AccountPreferenceModel> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final countryCode = prefs.getString(_kCountryCodeKey);
    final phoneNumber = prefs.getString(_kPhoneNumberKey);
    final email = prefs.getString(_kEmailKey);
    final accountType = prefs.getString(_kAccountTypeKey);
    final token = prefs.getString(_kTokenKey);
    final name = prefs.getString(_kName);
    final pin = prefs.getString(_kPinCode);

    final AccountType? enumAccountType = (accountType == null)
        ? null
        : AccountType.values.firstWhere(
            (type) => type.toString() == 'AccountType.$accountType',
          );
    return AccountPreferenceModel(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      accountType: enumAccountType,
      token: token,
      name: name,
      pin: pin,
    );
  }

  static Future<void> setUserData(AccountPreferenceModel accountData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (accountData.countryCode != null) {
      prefs.setString(_kCountryCodeKey, accountData.countryCode!);
    }

    if (accountData.phoneNumber != null) {
      prefs.setString(_kPhoneNumberKey, accountData.phoneNumber!);
    }

    if (accountData.accountType?.name != null) {
      prefs.setString(_kAccountTypeKey, accountData.accountType!.name);
    }

    if (accountData.token != null) {
      prefs.setString(_kTokenKey, accountData.token!);
    }

    if (accountData.email != null) {
      prefs.setString(_kEmailKey, accountData.email!);
    }

    if (accountData.name != null) {
      prefs.setString(_kName, accountData.name!);
    }

    if (accountData.pin != null) {
      prefs.setString(_kPinCode, accountData.pin!);
    }
  }

  static Future<void> logOutUser() async {
    await _clearAccountData();
  }

  static Future<void> _clearAccountData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_kPhoneNumberKey);
    prefs.remove(_kEmailKey);
    prefs.remove(_kAccountTypeKey);
    prefs.remove(_kTokenKey);
    prefs.remove(_kName);
  }
}
