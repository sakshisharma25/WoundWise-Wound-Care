// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/views/wound_assessment/wound_result_screen.dart';
import 'package:woundwise/views/wound_assessment/open_camera_screen.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({required this.aimOfClick, super.key});
  final AimOfClick aimOfClick;

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final ValueNotifier<double> _heightController = ValueNotifier(170.0);
  final ValueNotifier<double> _weightController = ValueNotifier(65.0);
  final ValueNotifier<String> _selectedGender = ValueNotifier("Male");
  File? _profileImage;
  PatientModel? _patientData;

  @override
  void initState() {
    super.initState();
    context.read<PatientsController>().resetAddPatient();
  }

  Future<void> _pickPhotoImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> _pickImageForNextStep() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WoundResultScreen(
            imageFile: File(pickedFile.path),
            patientData: _patientData!,
          ),
        ),
      );
    } else {
      debugPrint('No image selected.');
    }
  }

  void onNextPressed() {
    if (_patientData == null) {
      kShowSnackBar("First save the patient details.");
      return;
    }
    final isPatientAdded = context.read<PatientsController>().isPatientAdded;
    if (isPatientAdded) {
      if (widget.aimOfClick == AimOfClick.takePicture) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OpenCameraScreen(
            patientData: _patientData!,
          );
        }));
      } else if (widget.aimOfClick == AimOfClick.uploadPicture) {
        _pickImageForNextStep();
      }
    }
  }

  Future<void> onSavePressed() async {
    if (_patientNameController.text.isEmpty) {
      kShowSnackBar("Enter patient name.");
    } else if (_dateOfBirthController.text.isEmpty) {
      kShowSnackBar("Choose patient date of birth.");
    } else if (_selectedGender.value.isEmpty) {
      kShowSnackBar("Choose patient gender.");
    } else {
      String? patientId =
          await context.read<PatientsController>().addNewPatient(
                imagePath: _profileImage?.path,
                name: _patientNameController.text,
                dob: _dateOfBirthController.text,
                gender: _selectedGender.value,
                age: int.tryParse(_ageController.text) ?? 0,
                height: _heightController.value,
                weight: _weightController.value,
              );

      // If the patient is added successfully, then update the patient data
      _patientData = PatientModel(
        profileImagePath: _profileImage?.path,
        profileImageUrl: null,
        id: patientId,
        name: _patientNameController.text,
        dob: _dateOfBirthController.text,
        gender: _selectedGender.value,
        age: _ageController.text,
        height: _heightController.value.toString(),
        weight: _weightController.value.toString(),
      );
      if (widget.aimOfClick == AimOfClick.savePatient) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create New Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              "assets/background_image11.png",
              fit: BoxFit.cover,
            )),
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color:
                              _profileImage == null ? Colors.grey[200] : null,
                          borderRadius: BorderRadius.circular(10),
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (_profileImage != null)
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.blue.shade200,
                                  size: 30,
                                ),
                                onPressed: _pickPhotoImageFromGallery,
                              ),
                      ),
                      TextButton(
                        onPressed: _pickPhotoImageFromGallery,
                        child: Text(
                          (_profileImage != null)
                              ? 'Change Profile Photo'
                              : 'Add Profile Photo',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildNameTextField(),
                  _buildChooseDateofBirth(),
                  _buildAgeTextField(),
                  const SizedBox(height: 20),
                  _buildGenderRadioButtons(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildHeightNumberPicker()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildWeightNumberPicker())
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Consumer<PatientsController>(
              builder: (context, value, child) {
                if (value.isPatientAddLoading || value.isPatientAdded) {
                  return Container(
                    color: Colors.black.withOpacity(0.1),
                  );
                } else {
                  return const SizedBox(height: 0, width: 0);
                }
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildNameTextField() {
    return Consumer<PatientsController>(
      builder: (context, controller, _) {
        final isPatientAdding = controller.isPatientAddLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Patient Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: !isPatientAdding,
              controller: _patientNameController,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter Patient Name",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]+')),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildChooseDateofBirth() {
    return Consumer<PatientsController>(
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((value) {
              if (value != null) {
                _dateOfBirthController.text = value.toString().substring(0, 10);
                // Calaculate age and update the age field
                var age = DateTime.now().year - value.year;
                _ageController.text = age.toString();
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose Date of Birth",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                enabled: false,
                controller: _dateOfBirthController,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Click to choose",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgeTextField() {
    return Consumer<PatientsController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Age",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: false,
              controller: _ageController,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                fillColor: Colors.grey[100],
                filled: true,
                hintText: "Age calculated automatically",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildGenderRadioButtons() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      value: _selectedGender.value,
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender.value = newValue ?? "Male";
        });
      },
      focusColor: Colors.grey.shade200,
      dropdownColor: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle()),
        );
      }).toList(),
    );
  }

  Widget _buildHeightNumberPicker() {
    return Column(
      children: [
        const Text(
          "Height (in cm)",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
            valueListenable: _heightController,
            builder: (context, value, _) {
              return NumberPicker(
                value: value.toInt(),
                minValue: 0,
                maxValue: 210,
                step: 1,
                haptics: true,
                onChanged: (value) {
                  _heightController.value = value.toDouble();
                },
                selectedTextStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              );
            }),
      ],
    );
  }

  Widget _buildWeightNumberPicker() {
    return Column(
      children: [
        const Text(
          "Weight (in kg)",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
            valueListenable: _weightController,
            builder: (context, value, _) {
              return NumberPicker(
                value: value.toInt(),
                minValue: 0,
                maxValue: 200,
                step: 1,
                haptics: true,
                onChanged: (value) {
                  _weightController.value = value.toDouble();
                },
                selectedTextStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              );
            }),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, bottom: 7),
      width: double.infinity,
      height: 50, // Standard button height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5FC1), Color(0xFF7EB3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Consumer<PatientsController>(
        builder: (context, controller, _) {
          final isPatientAdding = controller.isPatientAddLoading;
          final isPatientAdded = controller.isPatientAdded;
          return ElevatedButton(
            onPressed: () {
              if (isPatientAdding == true) {
                return;
              } else if (isPatientAdded == true) {
                onNextPressed();
              } else {
                onSavePressed();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  Colors.transparent, // Foreground (text/icon) color
              shadowColor: Colors.transparent, // No shadow for cleaner look
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: (isPatientAdding)
                ? const SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    isPatientAdded ? 'Next' : 'Save',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
