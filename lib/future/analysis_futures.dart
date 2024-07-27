import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/noofappointment_mode.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';

class AnalysisFutures {
  static Future<List<NoOfAppointmentModel>> getAppointments() async {
    final userData = await StorageServices.getUserData();
    final token = userData.token;
    final email = userData.email;

    if (token == null) {
      kShowSnackBar("Token not found. Please try again");
      debugPrint("Token not found. Please try again");
      return _demoAppoinmentData();
    }

    if (email == null) {
      kShowSnackBar("Email not found. Please try again");
      debugPrint("Email not found. Please try again");
      return _demoAppoinmentData();
    }

    final currentDate = DateTime.now();
    final startDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final endDate = DateFormat('yyyy-MM-dd')
        .format(currentDate.add(const Duration(days: 6)));

    final response = await WoundAPIServices.totalAppointments(
      token: token,
      userEmail: email,
      startDate: startDate,
      endDate: endDate,
    );

    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      final list = data['appointments_by_day'];
      List<NoOfAppointmentModel> appointmentList = [];
      list.forEach((keyAsDate, value) {
        final appointmentModel = NoOfAppointmentModel(
          date:
              DateFormat('dd MMM').format(DateTime.parse(keyAsDate)).toString(),
          totalAppointments: value,
        );
        appointmentList.add(appointmentModel);
      });
      return appointmentList;
    } else {
      throw 'Internal Server Error: ${response.statusCode}';
    }
  }

  static _demoAppoinmentData() {
    return [
      NoOfAppointmentModel(date: 'Mon', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Tue', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Wed', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Thu', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Fri', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Sat', totalAppointments: 0),
      NoOfAppointmentModel(date: 'Sun', totalAppointments: 0),
    ];
  }
}
