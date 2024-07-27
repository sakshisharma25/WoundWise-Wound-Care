import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/wound_assessment/medication_pdf_screen.dart';
import 'package:woundwise/views/wound_assessment/prescription_pdf_screen.dart';

class CheckBoxMedicationModel {
  String title;
  bool isChecked;

  CheckBoxMedicationModel({required this.title, required this.isChecked});
}

class PrescriptionScreen extends StatefulWidget {
  final PatientModel patientData;
  final String woundType;
  final String? causeOfWound;
  final String? woundLocation;
  final String? areaOfWound;

  const PrescriptionScreen({
    super.key,
    required this.patientData,
    required this.woundType,
    required this.woundLocation,
    this.causeOfWound,
    this.areaOfWound,
  });

  @override
  State<PrescriptionScreen> createState() => _PrescriptionMedPageState();
}

class _PrescriptionMedPageState extends State<PrescriptionScreen> {
  final TextEditingController _remarksController = TextEditingController();
  final ValueNotifier<List<CheckBoxMedicationModel>> _dressingList =
      ValueNotifier([
    CheckBoxMedicationModel(title: "Semi permeable film", isChecked: false),
    CheckBoxMedicationModel(title: "Hydrocolloids", isChecked: false),
    CheckBoxMedicationModel(title: "Alignates", isChecked: false),
    CheckBoxMedicationModel(title: "Hydrofibre", isChecked: false),
    CheckBoxMedicationModel(title: "Hydrogels", isChecked: false),
    CheckBoxMedicationModel(title: "Foams", isChecked: false),
  ]);
  final DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _recommendationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Prescription',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Patient Info',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              PatientTile(
                  patientData: widget.patientData,
                  showViewButton: false,
                  showSelectButton: false),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 253, 253),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 238, 238, 238)
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildDetailsHeader(),
                    buildNonEditableField(
                      label: 'Wound Type:',
                      value: widget.woundType,
                      isColored: true,
                    ),
                    buildNonEditableField(
                      label: 'Wound Location:',
                      value: (widget.woundLocation ?? "Not Selected"),
                      isColored: false,
                    ),
                    buildNonEditableField(
                      label: 'Presc Date:',
                      value: DateFormat('yyyy-MM-dd').format(_selectedDateTime),
                      isColored: true,
                    ),
                    buildNonEditableField(
                      label: 'Review Date:',
                      value: DateFormat('yyyy-MM-dd').format(_selectedDateTime),
                      isColored: false,
                    ),
                    buildEditableField(
                      label: 'Remarks:    ',
                      value: '.',
                      isColored: true,
                      controller: _remarksController,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dressing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton.filled(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        // Navigate to help screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicationPDFScreen(
                              asset: "assets/Medication-mapping.pdf",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.help_outline_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              // Add checkBoxes for medications
              ValueListenableBuilder(
                  valueListenable: _dressingList,
                  builder: (context, value, child) {
                    return ListView.builder(
                        itemCount: value.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            enabled: false,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: value[index].isChecked,
                            onChanged: (newValue) {
                              // Trick:
                              var newList = List.from(_dressingList.value);
                              // Update the item in the new list
                              final medication = newList[index];
                              medication.isChecked = newValue ?? false;
                              newList[index] = medication;
                              // Update the ValueNotifier with the new list
                              _dressingList.value = List.from(newList);
                            },
                            title: Text(
                              value[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        });
                  }),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Recommendation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                child: TextField(
                  controller: _recommendationController,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write Recommendation',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  minLines: 3,
                  maxLines: 7,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            _storeRecommendation();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrescriptionPDFScreen(
                  patientData: widget.patientData,
                  woundType: widget.woundType,
                  woundLocation: widget.woundLocation,
                  causeOfWound: widget.causeOfWound,
                  areaOfWound: widget.areaOfWound,
                  recommendation: _recommendationController.text,
                  remarks: _remarksController.text,
                ),
              ),
            );
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
            'Generate Prescription',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade200),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.black,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget buildNonEditableField({
    required String label,
    required String value,
    required bool isColored,
  }) {
    return Container(
      color: isColored ? Colors.grey.shade100 : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableField({
    required String label,
    required String value,
    required bool isColored,
    required TextEditingController controller,
  }) {
    return Container(
      color: isColored ? Colors.grey.shade100 : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Enter $label',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              textAlign: TextAlign.right,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _storeRecommendation() async {
    final patientId = widget.patientData.id;
    final recommendation = _recommendationController.text;
    final remarks = _remarksController.text;

    try {
      final userData = await StorageServices.getUserData();
      final token = userData.token;
      if (token == null) {
        throw "Token not found. Please try again";
      }

      if (patientId == null) {
        throw "Patient ID not found. Please try again";
      }

      final response = await WoundAPIServices.saveNotes(
        token: token,
        patientId: patientId,
        notes: recommendation,
        remarks: remarks,
      );

      debugPrint("-> Response: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("-> Response: $data");
        kShowSnackBar("Recommendation saved successfully.");
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final data = jsonDecode(response.body);
        final message = data['error'];
        kShowSnackBar("$message");
      } else {
        throw "Server error occurred. ${response.statusCode}";
      }
    } catch (error) {
      kShowSnackBar("$error");
    }
  }
}
