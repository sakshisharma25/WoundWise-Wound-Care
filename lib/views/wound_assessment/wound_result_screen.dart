import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/models/analyzed_wound_model.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/services/wound_drop_down.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/wound_assessment/anatomy_screen.dart';
import 'package:woundwise/views/wound_assessment/prescription_pin_popup.dart';

class WoundResultScreen extends StatefulWidget {
  final File imageFile;
  final PatientModel patientData;

  const WoundResultScreen(
      {super.key, required this.imageFile, required this.patientData});

  @override
  State<WoundResultScreen> createState() => _WoundResultScreenState();
}

class _WoundResultScreenState extends State<WoundResultScreen> {
  final TextEditingController _causeOfWoundController = TextEditingController();

  final ValueNotifier<String?> _select360 = ValueNotifier(null);
  final ValueNotifier<String> _skinTone =
      ValueNotifier(WoundDropDown.skinTone[0]);
  final ValueNotifier<String> _type = ValueNotifier(WoundDropDown.type[0]);
  final ValueNotifier<String> _categoryController =
      ValueNotifier(WoundDropDown.category[0]);
  final ValueNotifier<String> _tissue = ValueNotifier(WoundDropDown.tissue[0]);
  final ValueNotifier<String> _edges = ValueNotifier(WoundDropDown.edges[0]);
  final ValueNotifier<String> _exudate =
      ValueNotifier(WoundDropDown.exudate[0]);
  final ValueNotifier<String> _periwound =
      ValueNotifier(WoundDropDown.periwound[0]);
  final ValueNotifier<String> _periwoundType =
      ValueNotifier(WoundDropDown.periwoundType[0]);
  final ValueNotifier<String> _infection =
      ValueNotifier(WoundDropDown.infection[0]);
  final ValueNotifier<DateTime> _lastDressingTime =
      ValueNotifier(DateTime.now());

  @override
  void initState() {
    super.initState();
    context
        .read<PatientsController>()
        .analyzeWound(context, widget.imageFile.path);
  }

  void _saveWoundDetails() {
    final PatientsController controller = context.read<PatientsController>();
    final AnalyzedWoundModel? value = controller.analyzedWoundData;
    if (controller.isWoundResultSaved == false) {
      context.read<PatientsController>().saveWoundDetails(
            realImagePath: widget.imageFile.path,
            apiImagePath: value?.imageFile.path ?? widget.imageFile.path,
            lengthCm: value?.lengthCm ?? 0.0,
            breadthCm: value?.breadthCm ?? 0.0,
            depthCm: value?.depthCm ?? 0.0,
            areaCm2: value?.areaCm2 ?? 0.0,
            moisture: (value?.moisture == null)
                ? 'Unknown'
                : (value!.moisture > 160 ? 'High  ' : 'Low  '),
            woundLocation: _select360.value.toString(),
            tissue: _tissue.value.toString(),
            exudate: _exudate.value.toString(),
            periwound: _periwound.value.toString(),
            periwoundType: _periwoundType.value.toString(),
            patientId: widget.patientData.id.toString(),
            type: _type.value.toString(),
            category: _categoryController.value.toString(),
            edge: _edges.value.toString(),
            infection: _infection.value.toString(),
            lastDressingDate:
                DateFormat('yyyy-MM-dd HH:mm').format(_lastDressingTime.value),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle commonStyle = const TextStyle();
    TextStyle titleStyle =
        commonStyle.copyWith(fontSize: 21, fontWeight: FontWeight.w500);
    return Consumer<PatientsController>(
      builder: (context, controller, child) {
        return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[200],
              automaticallyImplyLeading: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text('Result', style: titleStyle),
              centerTitle: true,
              actions: [
                if (controller.analyzedWoundData != null &&
                    controller.woundDetectionError == null &&
                    controller.isWoundResultSaved == false)
                  TextButton(
                    onPressed: () {
                      _saveWoundDetails();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (controller.isWoundDetailsLoading == true) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Analyzing wound...',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.woundDetectionError != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${controller.woundDetectionError}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Try again',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (controller.analyzedWoundData != null) {
                  return _body();
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'No data found. Please try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  Widget _body() {
    final pictureSize = MediaQuery.of(context).size.height * 0.55;
    final sheetSize = MediaQuery.of(context).size.height * 0.5;
    return Consumer<PatientsController>(builder: (context, controller, child) {
      final AnalyzedWoundModel? value = controller.analyzedWoundData;
      return Stack(
        children: [
          Container(
            height: pictureSize,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  (value?.imageFile != null)
                      ? value!.imageFile
                      : widget.imageFile,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: sheetSize),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.keyboard_arrow_up_rounded,
                          size: 36, color: Colors.black45),
                      const Text(
                        'Wound Assessment Report',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Wound W1',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      PatientTile(
                        patientData: widget.patientData,
                        showViewButton: false,
                        showSelectButton: false,
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Text(
                                'Dimensions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 2,
                                ),
                                child: buildDimensionRow(
                                  label: 'Area',
                                  value:
                                      "${value?.areaCm2.toStringAsFixed(2)} cm²",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 2,
                              ),
                              child: buildDimensionRow(
                                label: 'Breadth',
                                value:
                                    "${value?.breadthCm.toStringAsFixed(2)} cm ",
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 2,
                                ),
                                child: buildDimensionRow(
                                  label: 'Length',
                                  value:
                                      "${value?.lengthCm.toStringAsFixed(2)} cm ",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 2,
                              ),
                              child: buildDimensionRow(
                                label: 'Depth',
                                value:
                                    "${value?.depthCm.toStringAsFixed(2)} cm ",
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // padding: const EdgeInsets.all(20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Wound Location',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              color: Colors.grey.shade100,
                              child: _buildTextField(
                                'Cause of Wound',
                                'Fill Cause',
                                _causeOfWoundController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: _build360Tile(),
                            ),
                          ],
                        ),
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Text(
                                'Wound Assessment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            _buildDropDownMenu(
                              label: 'Skin Tone',
                              list: WoundDropDown.skinTone,
                              valueNotifier: _skinTone,
                              isColored: true,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Moisture',
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    (value?.moisture == null)
                                        ? 'Unknown'
                                        : (value!.moisture > 160
                                            ? 'High  '
                                            : 'Low  '),
                                    style: const TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            _buildDropDownMenu(
                              label: "Type",
                              list: WoundDropDown.type,
                              valueNotifier: _type,
                              isColored: true,
                            ),
                            _buildDropDownMenu(
                                label: "Category",
                                list: WoundDropDown.category,
                                valueNotifier: _categoryController,
                                isColored: false),
                            _buildDropDownMenu(
                              label: "Tissue",
                              list: WoundDropDown.tissue,
                              valueNotifier: _tissue,
                              isColored: true,
                            ),
                            _buildDropDownMenu(
                              label: "Edge",
                              list: WoundDropDown.edges,
                              valueNotifier: _edges,
                              isColored: false,
                            ),
                            _buildDropDownMenu(
                              label: "Exudate",
                              list: WoundDropDown.exudate,
                              valueNotifier: _exudate,
                              isColored: true,
                            ),
                            _buildDropDownMenu(
                              label: "Periwound",
                              list: WoundDropDown.periwound,
                              valueNotifier: _periwound,
                              isColored: false,
                            ),
                            _buildDropDownMenu(
                              label: "Periwound Type",
                              list: WoundDropDown.periwoundType,
                              valueNotifier: _periwoundType,
                              isColored: true,
                            ),
                            _buildDropDownMenu(
                              label: "Infection",
                              list: WoundDropDown.infection,
                              valueNotifier: _infection,
                              isColored: false,
                            ),
                            Container(
                              color: Colors.grey.shade100,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Last Dressing Time',
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yy HH:mm')
                                        .format(_lastDressingTime.value),
                                    style: const TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: double.infinity,
                          height: 50, // Define height for the button
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1B5FC1),
                                Color(0xFF7EB3FF)
                              ], // Define your gradient colors here
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Save wound details
                              _saveWoundDetails();
                              // Show the popup
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return PrescriptionPinPopUp(
                                    patientData: widget.patientData,
                                    woundType: _type.value,
                                    woundLocation: _select360.value,
                                    areaOfWound:
                                        "${value?.areaCm2.toStringAsFixed(2)} cm²",
                                    causeOfWound: _causeOfWoundController.text,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Important for gradient visibility
                              shadowColor: Colors.transparent,
                              elevation: 0, // No elevation for flat design
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets
                                  .zero, // Remove padding so the gradient background covers the button completely
                            ),
                            child: const Text(
                              'View Detailed Prescription',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _selectBodyPart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnatomyScreen(
          selectedPart: _select360,
        ),
      ),
    );
  }

  Widget _buildDropDownMenu(
      {required String label,
      required List<String> list,
      required ValueNotifier<String> valueNotifier,
      bool isColored = false}) {
    // Ensure the initial value is in the list
    if (!list.contains(valueNotifier.value)) {
      valueNotifier.value = list.first;
    }
    return Container(
      color: isColored ? Colors.grey.shade100 : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ValueListenableBuilder<String>(
        valueListenable: valueNotifier,
        builder: (context, value, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$label:', style: const TextStyle()),
              const Spacer(),
              DropdownButton<String>(
                alignment: Alignment.centerRight,
                value: value,
                icon: const Icon(Icons.arrow_drop_down_rounded, size: 27),
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    valueNotifier.value = newValue;
                  }
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label:', style: const TextStyle()),
        Expanded(
          child: TextField(
              autofocus: false,
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 0),
              ),
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              }),
        ),
      ],
    );
  }

  Widget _build360Tile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select from Model View',
          style: TextStyle(),
        ),
        Flexible(
          child: ValueListenableBuilder(
              valueListenable: _select360,
              builder: (context, value, _) {
                final text =
                    (value == null || value.isEmpty) ? 'Click here' : value;
                return TextButton(
                  onPressed: _selectBodyPart,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget dottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            30,
            (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                    height: 1,
                  ),
                )),
      ),
    );
  }

  Widget buildDimensionRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label:', style: const TextStyle()),
        Text(
          value,
          style: const TextStyle(),
        ),
      ],
    );
  }
}
