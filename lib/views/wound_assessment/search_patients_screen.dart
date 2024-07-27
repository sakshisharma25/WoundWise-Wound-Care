// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/wound_assessment/wound_result_screen.dart';
import 'package:woundwise/views/wound_assessment/open_camera_screen.dart';

class SearchPatientsScreen extends StatelessWidget {
  const SearchPatientsScreen({required this.aimOfClick, super.key});
  final AimOfClick aimOfClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Existing Patient Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Consumer<PatientsController>(
        builder: (context, controller, child) {
          ValueNotifier<List<PatientModel>> patientList =
              ValueNotifier(List.from(controller.patientsList));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Patient Profile',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    patientList.value = controller.patientsList
                        .where((element) => "${element.name}"
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  },
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: patientList,
                builder: (context, List<PatientModel> patients, child) {
                  if (patients.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: const Column(
                        children: [
                          Icon(Icons.line_weight_sharp,
                              size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'No Patients Found',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (aimOfClick == AimOfClick.takePicture) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OpenCameraScreen(
                                    patientData: patients[index],
                                  ),
                                ),
                              );
                            } else {
                              _pickImageForNextStep(
                                context: context,
                                patientData: patients[index],
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: PatientTile(
                              patientData: patients[index],
                              showViewButton: false,
                              showSelectButton: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickImageForNextStep({
    required BuildContext context,
    required PatientModel patientData,
  }) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WoundResultScreen(
            imageFile: File(pickedFile.path),
            patientData: patientData,
          ),
        ),
      );
    } else {
      kShowSnackBar("No image selected.");
      debugPrint('No image selected.');
    }
  }
}
