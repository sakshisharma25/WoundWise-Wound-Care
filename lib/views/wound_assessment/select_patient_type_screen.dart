import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/views/patients/add_patient_screen.dart';
import 'package:woundwise/views/wound_assessment/search_patients_screen.dart';

class SelectPatientTypeScreen extends StatelessWidget {
  const SelectPatientTypeScreen({required this.aimOfClick, super.key});
  final AimOfClick aimOfClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Select Patient Type',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background_image11.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                _buildButton(context, 'New Patient', true),
                const SizedBox(height: 20),
                _buildButton(context, 'Existing Patient', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, bool isNewPatient) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.9, // Make button width 90% of screen width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              const Color.fromARGB(255, 161, 160, 160), // Dark grey text color
          backgroundColor: Colors.grey[100], // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded rectangle
            side: const BorderSide(
                color: Color.fromARGB(255, 161, 160, 160)), // Dark grey border
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 25), // Padding inside button
          elevation: 0, // Remove shadow
        ),
        onPressed: () {
          if (isNewPatient) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPatientScreen(
                  aimOfClick: aimOfClick,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPatientsScreen(
                  aimOfClick: aimOfClick,
                ),
              ),
            );
          }
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A237E),
          ),
        ),
      ),
    );
  }
}
