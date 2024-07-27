// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/wound_assessment/prescription_screen.dart';

class PrescriptionPinPopUp extends StatelessWidget {
  const PrescriptionPinPopUp({
    required this.patientData,
    required this.woundType,
    this.causeOfWound,
    this.woundLocation,
    this.areaOfWound,
    super.key,
  });

  final PatientModel patientData;
  final String woundType;
  final String? causeOfWound;
  final String? woundLocation;
  final String? areaOfWound;

  @override
  Widget build(BuildContext context) {
    final FocusNode otpFocusNode = FocusNode();
    final TextEditingController otpControllers = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo1.png',
              height: 100,
              width: 100,
            ),
            const Text(
              'Please enter your PIN. In order to view the prescription',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            FutureBuilder(
                future: _getPinLength(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    );
                  }
                  final pinLength = snapshot.data as int;
                  return Pinput(
                    autofocus: true,
                    focusNode: otpFocusNode,
                    controller: otpControllers,
                    length: pinLength,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onTapOutside: (event) {
                      otpFocusNode.unfocus();
                    },
                    onCompleted: (value) {
                      _validateOTP(context, enteredPin: value);
                    },
                  );
                }),
            const SizedBox(height: 30),
            Container(
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
                  _validateOTP(context, enteredPin: otpControllers.value.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _getPinLength() async {
    final userData = await StorageServices.getUserData();
    final savedPin = userData.pin.toString();
    if (savedPin.isEmpty) {
      throw 'No PIN found. Login again';
    }
    return savedPin.length;
  }

  Future<void> _validateOTP(
    BuildContext context, {
    required String enteredPin,
  }) async {
    try {
      final userData = await StorageServices.getUserData();
      final savedPin = userData.pin.toString();
      if (savedPin.isEmpty) {
        throw 'No PIN found. Login again';
      }
      if (enteredPin == savedPin) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrescriptionScreen(
              patientData: patientData,
              woundType: woundType,
              causeOfWound: causeOfWound,
              woundLocation: woundLocation,
              areaOfWound: areaOfWound,
            ),
          ),
        );
      } else {
        throw "Invalid PIN. Please try again.";
      }
    } catch (error) {
      kShowSnackBar("$error");
    }
  }
}
