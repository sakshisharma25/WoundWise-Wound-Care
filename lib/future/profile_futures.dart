import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/profile_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';

class ProfileFutures {
  static Future<ProfileModel> getProfile() async {
    final userAccount = await StorageServices.getUserData();
    if (userAccount.accountType == null) {
      throw 'User account type not found';
    }
    if (userAccount.email == null) {
      throw 'User email not found';
    }
    if (userAccount.token == null) {
      throw 'User token not found';
    }

    Response response;
    if (userAccount.accountType == AccountType.organization) {
      response = await OrganizationAPIServices.fetchProfileDetails(
        userEmail: userAccount.email!,
        token: userAccount.token!,
      );
    } else {
      response = await PractitionerAPIServices.fetchProfileDetails(
        userEmail: userAccount.email!,
        token: userAccount.token!,
      );
    }

    debugPrint("-> ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      throw 'Internal Server Error: ${response.statusCode}';
    }
  }
}
