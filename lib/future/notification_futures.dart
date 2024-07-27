import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:woundwise/models/notification_model.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';


class NotificationFutures {
  static Future<List<NotificationModel>> getNotifications() async {
    final userAccount = await StorageServices.getUserData();
    final email = userAccount.email;
    final token = userAccount.token;

    if (email == null) throw 'User email not found';
    if (token == null) throw 'User token not found';

    Response response = await NotificationAPIServices.fetchNotifications(
      email: email,
      token: token,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    debugPrint("-> ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return [NotificationModel.fromJson(data)];
    } else if (response.statusCode == 401 || response.statusCode == 405) {
      final data = jsonDecode(response.body);
      throw "${data['message']}";
    } else {
      throw 'Internal Server Error: ${response.statusCode}';
    }
  }

  static Future<List<PatientModel>> getTodaysAppointments() async {
    final userAccount = await StorageServices.getUserData();
    final email = userAccount.email;
    final token = userAccount.token;

    if (email == null) throw 'User email not found';
    if (token == null) throw 'User token not found';
    Response response = await NotificationAPIServices.getTodaysAppointments(
      email: email,
      token: token,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    debugPrint("-> ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rowList = data['patients'] as List;
      final list = rowList.map((patient) => PatientModel.fromJson(patient)).toList();
      return list;
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      final data = jsonDecode(response.body);
      throw "${data['message']}";
    } else {
      throw 'Internal Server Error: ${response.statusCode}';
    }
  }
}
