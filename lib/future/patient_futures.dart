import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:woundwise/models/patient_information_model.dart';
import 'package:woundwise/models/progress_timeline_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';

class PatientFutures {
  static Future<PatientInformationModel> getPatientInformation({
    required String patientId,
  }) async {
    final userData = await StorageServices.getUserData();
    final token = userData.token;
    if (token == null) {
      throw "Token not found. Please try again";
    }

    final response = await PatientAPIServices.getInformations(
      token: token,
      patientId: patientId,
    );

    debugPrint("->  ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PatientInformationModel.fromJson(data);
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      throw "${data['error']}";
    } else {
      throw 'Internal server error. ${response.statusCode}';
    }
  }

  static Future<List<ProgressTimeLineModel>> getWoundProgressTimeline({
    required String patientId,
  }) async {
    final userData = await StorageServices.getUserData();
    final token = userData.token;
    if (token == null) {
      throw "Token not found. Please try again";
    }

    final response = await PatientAPIServices.getProgressTimeline(
      token: token,
      patientId: patientId,
    );

    debugPrint("-> ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final list = data.map((e) => ProgressTimeLineModel.fromJson(e)).toList();
      if (list.isEmpty) {
        throw "No data to display.";
      }
      return list;
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      throw "${data['error']}";
    } else {
      throw 'Internal server error. ${response.statusCode}';
    }
  }
}
