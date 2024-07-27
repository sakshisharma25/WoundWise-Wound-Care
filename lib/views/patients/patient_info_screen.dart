import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/future/patient_futures.dart';
import 'package:woundwise/models/patient_information_model.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/api_services.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/components/anatomy_component.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/patients/progress_timeline_screen.dart';

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({required this.patient, super.key});
  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Patient Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (patient.id == null) {
                kShowSnackBar('Patient ID is null. Please try again.');
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProgressTimelineScreen(patientId: patient.id!);
              }));
            },
            icon: const Icon(Icons.timeline_rounded),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder(
        future: PatientFutures.getPatientInformation(patientId: patient.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final patientInfo = snapshot.data as PatientInformationModel;
          return _Builder(patientInfo: patientInfo, patient: patient);
        },
      ),
    );
  }
}

class _Builder extends StatefulWidget {
  const _Builder({required this.patient, required this.patientInfo});
  final PatientModel patient;
  final PatientInformationModel patientInfo;

  @override
  State<_Builder> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<_Builder> {
  bool isLoading = false;
  // Allergies
  List<String> allergiesList = [];
  final TextEditingController allergyEditingController = TextEditingController();
  bool isEditingAllergies = false;

  // Past History
  List<String> pastHistoryList = [];
  final TextEditingController pastHistoryEditingController = TextEditingController();
  bool isEditingPasHistory = false;

  // Body Part
  final ValueNotifier<String?> selectedPart = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    final tempAllergiesList = widget.patientInfo.allergies?.split(",");
    final tempPastHistoryList = widget.patientInfo.pastHistory?.split(",");
    final tempLocation = widget.patientInfo.woundLocation;

    if (tempAllergiesList != null) allergiesList = tempAllergiesList;
    if (tempPastHistoryList != null) pastHistoryList = tempPastHistoryList;
    if (tempLocation != null) selectedPart.value = tempLocation;
  }

  Future<void> _savePatientInfo() async {
    try {
      final userInfo = await StorageServices.getUserData();
      final token = userInfo.token;
      final doctorName = userInfo.name;

      if (widget.patient.id == null) {
        throw 'Patient ID is null';
      }
      if (token == null) {
        throw 'Token is null';
      }

      final response = await PatientAPIServices.updateDetails(
        patientId: widget.patient.id!,
        allergies: allergiesList.join(","),
        pastHistory: pastHistoryList.join(","),
        doctorName: doctorName ?? "",
        careFacilities: widget.patientInfo.careFacilities ?? "",
        token: token,
      );

      if (response.statusCode == 200) {
        kShowSnackBar('Patient information updated successfully');
      } else {
        throw 'Internal server error. ${response.statusCode}';
      }
    } catch (error) {
      kShowSnackBar("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned.fill(
        //   child: Image.asset(
        //     "assets/background_image11.png",
        //     fit: BoxFit.cover,
        //   ),
        // ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                const SizedBox(height: 10),
                PatientTile(
                  patientData: widget.patient,
                  showViewButton: false,
                  showSelectButton: false,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 7,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          child: buildDimensionRow(
                            label: 'D.O.B',
                            value: "${widget.patientInfo.dob}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: buildDimensionRow(
                          label: 'Reg Date',
                          value: "${widget.patientInfo.registerDate}",
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          child: buildDimensionRow(
                            label: 'Doctor name',
                            value: "${widget.patientInfo.doctorName}",
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 4,
                      //   ),
                      //   child: buildDimensionRow(
                      //     label: 'Care Facility',
                      //     value: "${widget.patientInfo.careFacilities}",
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Allergies',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          (isEditingAllergies == false)
                              ? IconButton.filled(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.grey.shade50),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEditingAllergies = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit_sharp,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _savePatientInfo();
                                    setState(() {
                                      isEditingAllergies = false;
                                    });
                                  },
                                  icon: const Icon(Icons.check_outlined),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isEditingAllergies == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: TextField(
                          controller: allergyEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter allergy..',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                final text = allergyEditingController.text;
                                if (text.isNotEmpty) {
                                  setState(() {
                                    allergiesList.add(text);
                                    allergyEditingController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    (allergiesList.isEmpty == false)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: allergiesList
                                  .map(
                                    (ward) => Chip(
                                      color: WidgetStatePropertyAll(Colors.grey.shade200),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      label: Text(
                                        ward,
                                        style: const TextStyle(),
                                      ),
                                      onDeleted: isEditingAllergies
                                          ? () {
                                              setState(() {
                                                allergiesList.remove(ward);
                                              });
                                            }
                                          : null,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : const Text(
                            "No allergies found",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Past History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          (isEditingPasHistory == false)
                              ? IconButton.filled(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEditingPasHistory = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit_sharp,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _savePatientInfo();
                                    setState(() {
                                      isEditingPasHistory = false;
                                    });
                                  },
                                  icon: const Icon(Icons.check_outlined),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isEditingPasHistory == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: TextField(
                          controller: pastHistoryEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter past history..',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                final text = pastHistoryEditingController.text;
                                if (text.isNotEmpty) {
                                  setState(() {
                                    pastHistoryList.add(text);
                                    pastHistoryEditingController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    (pastHistoryList.isEmpty == false)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: pastHistoryList
                                  .map(
                                    (ward) => Chip(
                                      color: WidgetStatePropertyAll(Colors.grey.shade200),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      label: Text(
                                        ward,
                                        style: const TextStyle(),
                                      ),
                                      onDeleted: isEditingPasHistory
                                          ? () {
                                              setState(() {
                                                pastHistoryList.remove(ward);
                                              });
                                            }
                                          : null,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : const Text(
                            "No past history found",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Wound Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnatomyComponent(
                  selectedPart: selectedPart,
                  isEditable: false,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDimensionRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget buildButton({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
