import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woundwise/controllers/patients_controller.dart';
import 'package:woundwise/models/patients_model.dart';
import 'package:woundwise/views/components/appointments_graph.dart';
import 'package:woundwise/views/components/patient_tile.dart';
import 'package:woundwise/views/patients/patient_info_screen.dart';


class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  UniqueKey unquicKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          unquicKey = UniqueKey();
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Appointments Analysis",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AppointmentsGraph(
              unqicKey: unquicKey,
            ),
            Consumer<PatientsController>(builder: (context, controller, child) {
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
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Search Patient Profile',
                        labelStyle: const TextStyle(),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
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
                      return ListView.builder(
                        itemCount: patients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientInfoScreen(
                                      patient: patients[index]),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: PatientTile(
                                patientData: patients[index],
                                showViewButton: true,
                                showSelectButton: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
