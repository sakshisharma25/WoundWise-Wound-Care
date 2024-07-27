import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/wound_assessment/followup_exit_screen.dart';

class ScheduleFollowUpScreen extends StatefulWidget {
  const ScheduleFollowUpScreen({required this.patientData, super.key});
  final PatientModel patientData;

  @override
  State<ScheduleFollowUpScreen> createState() => _ScheduleFollowUpScreenState();
}

class _ScheduleFollowUpScreenState extends State<ScheduleFollowUpScreen> {
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  bool isSchedulingFollowUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Schedule Follow-Up',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Please select the date from the calendar to \n schedule an follow up for the patient",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildCalendar()),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
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
                      _scheduleFollowUp(
                        patientId: widget.patientData.id ?? 'unknown',
                        selectedDate: DateFormat('yyyy-MM-dd')
                            .format(_selectedDate.value),
                      ).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FollowUpExitScreen(),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Schedule Follow-up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isSchedulingFollowUp)
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

  Widget _buildCalendar() {
    return ValueListenableBuilder(
        valueListenable: _selectedDate,
        builder: (context, value, _) {
          return CalendarDatePicker(
            initialDate: value,
            firstDate: DateTime.now()
                .subtract(const Duration(days: 365 * 5)), // Set to 5 years ago
            lastDate: DateTime.now().add(
                const Duration(days: 365 * 5)), // Set to 5 years in the future
            currentDate: DateTime.now(),
            onDateChanged: (DateTime date) {
              _selectedDate.value = date;
            },
            initialCalendarMode: DatePickerMode.day,
          );
        });
  }

  Future<void> _scheduleFollowUp(
      {required String patientId, required String selectedDate}) async {
    try {
      setState(() {
        isSchedulingFollowUp = true;
      });

      final userData = await StorageServices.getUserData();
      final token = userData.token;
      final email = userData.email;

      if (token == null) {
        throw "Token not found. Please login again";
      }
      if (email == null) {
        throw "Email not found. Please login again";
      }

      final response = await WoundAPIServices.updateScheduledDate(
        token: token,
        userEmail: email,
        patientId: patientId,
        scheduledDate: selectedDate,
      );

      debugPrint("-> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        kShowSnackBar("Follow-up scheduled successfully");
      } else if (response.statusCode == 401) {
        throw "Unauthorized.";
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final data = jsonDecode(response.body);
        throw "${data['error']}";
      } else {
        throw "Internal Server Error. ${response.statusCode}, ${response.body}";
      }
    } catch (e) {
      kShowSnackBar("$e");
    } finally {
      setState(() {
        isSchedulingFollowUp = false;
      });
    }
  }
}
